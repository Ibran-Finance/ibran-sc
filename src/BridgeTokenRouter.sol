// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IMailbox} from "./interfaces/IMailbox.sol";
import {IInterchainGasPaymaster} from "@hyperlane-xyz/interfaces/IInterchainGasPaymaster.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IHelperTestnet} from "./interfaces/IHelperTestnet.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title BridgeTokenRouter
 * @author Ibran Protocol
 * @notice A bridge token router contract that handles cross-chain token transfers
 * @dev This contract facilitates cross-chain token transfers by sending messages
 * via Hyperlane to destination chains. It acts as a router for token bridging
 * operations, handling gas payments and message encoding.
 * 
 * The contract:
 * - Transfers tokens from users to itself
 * - Encodes recipient and amount in cross-chain messages
 * - Handles gas payment for cross-chain operations
 * - Validates that transfers are to different chains
 * 
 * @custom:security This contract should only be used for legitimate cross-chain
 * transfers and should be properly integrated with secure bridge infrastructure.
 */
contract BridgeTokenRouter {
    // ============ ERRORS ============
    /// @notice Error thrown when a function is called by an unauthorized mailbox
    error NotMailbox();
    /// @notice Error thrown when token transfer fails
    error TransferFailed();
    /// @notice Error thrown when trying to bridge to the same chain
    error SameChain();
    /// @notice Error thrown when the receiver bridge is not set for the destination chain
    error ReceiverBridgeNotSet();
    /// @notice Error thrown when the mailbox address is not set
    error MailboxNotSet();
    /// @notice Error thrown when the interchain gas paymaster is not set
    error InterchainGasPaymasterNotSet();

    // ============ EVENTS ============
    /// @notice Emitted when a message is received from the bridge
    /// @param origin The origin chain ID
    /// @param sender The sender address on the origin chain
    /// @param message The decoded message body
    event ReceivedMessage(uint32 origin, bytes32 sender, bytes message);

    // ============ STATE VARIABLES ============
    /// @notice The address of the helper testnet contract
    address public helperTestnet;
    /// @notice The address of the Hyperlane mailbox contract
    address public mailbox;
    /// @notice The address of the interchain gas paymaster contract
    address public interchainGasPaymaster;
    /// @notice The address of the token to bridge
    address public token;

    /**
     * @notice Constructor to initialize the bridge token router
     * @param _helperTestnet The address of the helper testnet contract
     * @param _token The address of the token to bridge
     * @dev Gets mailbox and gas paymaster addresses from the helper contract
     * @dev Validates that both addresses are set for the current chain
     * 
     * @custom:error MailboxNotSet - If the mailbox address is not set for the current chain
     * @custom:error InterchainGasPaymasterNotSet - If the gas paymaster is not set for the current chain
     */
    constructor(address _helperTestnet, address _token) {
        helperTestnet = _helperTestnet;
        (address _mailbox, address _interchainGasPaymaster,) = IHelperTestnet(helperTestnet).chains(block.chainid);
        if (_mailbox == address(0)) revert MailboxNotSet();
        if (_interchainGasPaymaster == address(0)) revert InterchainGasPaymasterNotSet();

        mailbox = _mailbox;
        interchainGasPaymaster = _interchainGasPaymaster;
        token = _token;
    }

    /**
     * @notice Modifier to restrict function access to the mailbox only
     * @dev Reverts with NotMailbox error if the caller is not the mailbox
     */
    modifier onlyMailbox() {
        _onlyMailbox();
        _;
    }

    /**
     * @notice Internal function to check if the caller is the mailbox
     * @dev Reverts with NotMailbox error if the caller is not the mailbox
     */
    function _onlyMailbox() internal view {
        if (msg.sender != address(mailbox)) revert NotMailbox();
    }

    /**
     * @notice Bridges tokens to another chain
     * @param _amount The amount of tokens to bridge
     * @param _recipient The address to receive tokens on the destination chain
     * @param _chainId The chain ID of the destination chain
     * @return The message ID of the dispatched cross-chain message
     * @dev Transfers tokens from user to this contract and sends a message to mint on destination
     * @dev Calculates gas payment for the cross-chain operation
     * @dev Encodes recipient and amount in the message payload
     * 
     * @custom:error SameChain - If trying to bridge to the same chain
     * @custom:error ReceiverBridgeNotSet - If the receiver bridge is not set for the destination chain
     * @custom:error TransferFailed - If the token transfer fails
     */
    function bridge(uint256 _amount, address _recipient, uint256 _chainId) external payable returns (bytes32) {
        if (block.chainid == _chainId) revert SameChain();

        (,, uint32 destinationDomain) = IHelperTestnet(helperTestnet).chains(_chainId);
        address receiverBridge = IHelperTestnet(helperTestnet).receiverBridge(_chainId);

        if (receiverBridge == address(0)) revert ReceiverBridgeNotSet();
        if (!IERC20(token).transferFrom(msg.sender, address(this), _amount)) revert TransferFailed();

        // Encode payload
        bytes memory message = abi.encode(_recipient, _amount);

        // Kirim pesan ke Chain B
        uint256 gasAmount = IInterchainGasPaymaster(interchainGasPaymaster).quoteGasPayment(destinationDomain, _amount);
        bytes32 recipientAddress = bytes32(uint256(uint160(receiverBridge)));

        bytes32 messageId = IMailbox(mailbox).dispatch{value: gasAmount}(destinationDomain, recipientAddress, message);
        return messageId;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IMailbox} from "./interfaces/IMailbox.sol";
import {IInterchainGasPaymaster} from "@hyperlane-xyz/interfaces/IInterchainGasPaymaster.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IHelperTestnet} from "./interfaces/IHelperTestnet.sol";
import {ITokenSwap} from "./interfaces/ITokenSwap.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title IbranBridgeTokenSender
 * @author Ibran Protocol
 * @notice A bridge token sender contract that handles outgoing cross-chain token transfers
 * @dev This contract facilitates cross-chain token transfers by burning tokens on the
 * source chain and sending messages to the destination chain to mint equivalent tokens.
 * 
 * The contract:
 * - Burns tokens on the source chain when initiating a transfer
 * - Sends cross-chain messages via Hyperlane to the destination chain
 * - Handles gas payment for cross-chain operations
 * - Validates that transfers are to different chains
 * 
 * @custom:security This contract should only be used for legitimate cross-chain
 * transfers and should be properly integrated with secure bridge infrastructure.
 */
contract IbranBridgeTokenSender {
    // ============ ERRORS ============
    /// @notice Error thrown when trying to bridge to the same chain
    error SameChain();
    /// @notice Error thrown when token transfer fails
    error TransferFailed();
    /// @notice Error thrown when the mailbox address is not set
    error MailboxNotSet();
    /// @notice Error thrown when the interchain gas paymaster is not set
    error InterchainGasPaymasterNotSet();
    /// @notice Error thrown when the receiver bridge is not set
    error ReceiverBridgeNotSet();

    // ============ STATE VARIABLES ============
    /// @notice The address of the helper testnet contract
    address public helperTestnet;
    /// @notice The address of the Hyperlane mailbox contract
    address public mailbox;
    /// @notice The address of the interchain gas paymaster contract
    address public interchainGasPaymaster;
    /// @notice The address of the token to bridge
    address public token;
    /// @notice The address of the receiver bridge on the destination chain
    address public receiverBridge; // ** OTHER CHAIN
    /// @notice The chain ID of the destination chain
    uint256 public chainId; // ** OTHER CHAIN

    /**
     * @notice Constructor to initialize the bridge token sender
     * @param _helperTestnet The address of the helper testnet contract
     * @param _token The address of the token to bridge
     * @param _receiverBridge The address of the receiver bridge on the destination chain
     * @param _chainId The chain ID of the destination chain
     * @dev Gets mailbox and gas paymaster addresses from the helper contract
     * @dev Validates all constructor parameters
     * 
     * @custom:error MailboxNotSet - If the mailbox address is not set for the current chain
     * @custom:error InterchainGasPaymasterNotSet - If the gas paymaster is not set for the current chain
     * @custom:error ReceiverBridgeNotSet - If the receiver bridge address is not set
     * @custom:error SameChain - If trying to bridge to the same chain
     */
    constructor(address _helperTestnet, address _token, address _receiverBridge, uint256 _chainId) {
        helperTestnet = _helperTestnet;
        (address _mailbox, address _interchainGasPaymaster,) = IHelperTestnet(helperTestnet).chains(block.chainid);
        mailbox = _mailbox;
        interchainGasPaymaster = _interchainGasPaymaster;
        receiverBridge = _receiverBridge;
        chainId = _chainId;
        token = _token;

        _validateConstructorParams();
    }

    /**
     * @notice Validates all constructor parameters
     * @dev Calls both validation functions to ensure all parameters are valid
     */
    function _validateConstructorParams() private view {
        _validateSameChain();
        _validateDifferentChain();
    }

    /**
     * @notice Validates that the current chain has proper infrastructure
     * @dev Checks that mailbox and gas paymaster addresses are set
     * 
     * @custom:error MailboxNotSet - If the mailbox address is not set
     * @custom:error InterchainGasPaymasterNotSet - If the gas paymaster is not set
     */
    function _validateSameChain() private view {
        if (mailbox == address(0)) revert MailboxNotSet();
        if (interchainGasPaymaster == address(0)) revert InterchainGasPaymasterNotSet();
    }

    /**
     * @notice Validates that the destination chain is different and properly configured
     * @dev Checks that receiver bridge is set and destination chain is different
     * 
     * @custom:error ReceiverBridgeNotSet - If the receiver bridge is not set
     * @custom:error SameChain - If trying to bridge to the same chain
     */
    function _validateDifferentChain() private view {
        if (receiverBridge == address(0)) revert ReceiverBridgeNotSet();
        if (block.chainid == chainId) revert SameChain();
    }

    /**
     * @notice Bridges tokens to another chain
     * @param _amount The amount of tokens to bridge
     * @param _recipient The address to receive tokens on the destination chain
     * @param _token The address of the token to bridge
     * @return The message ID of the dispatched cross-chain message
     * @dev Burns tokens on the source chain and sends a message to mint on destination
     * @dev Calculates gas payment for the cross-chain operation
     * @dev Encodes recipient and amount in the message payload
     * 
     * @custom:error ReceiverBridgeNotSet - If the receiver bridge is not set
     * @custom:error TransferFailed - If the token transfer fails
     */
    function bridge(uint256 _amount, address _recipient, address _token) external payable returns (bytes32) {
        (,, uint32 destinationDomain) = IHelperTestnet(helperTestnet).chains(chainId); // ** OTHER CHAIN
        if (receiverBridge == address(0)) revert ReceiverBridgeNotSet();
        if (!IERC20(_token).transferFrom(msg.sender, address(this), _amount)) revert TransferFailed(); // TODO: BURN
        ITokenSwap(token).burn(_amount);
        // Encode payload
        bytes memory message = abi.encode(_recipient, _amount);
        // Send message to Chain B
        uint256 gasAmount = IInterchainGasPaymaster(interchainGasPaymaster).quoteGasPayment(destinationDomain, _amount);
        bytes32 recipientAddress = bytes32(uint256(uint160(receiverBridge)));
        bytes32 messageId = IMailbox(mailbox).dispatch{value: gasAmount}(destinationDomain, recipientAddress, message);
        return messageId;
    }
}

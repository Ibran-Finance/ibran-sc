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
 * @dev Router contract for cross-chain token bridging via Hyperlane
 * @notice This contract handles token bridging operations between different chains
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract BridgeTokenRouter {
    // ============ Errors ============
    
    /**
     * @dev Error thrown when a non-mailbox address tries to call restricted functions
     */
    error NotMailbox();
    
    /**
     * @dev Error thrown when token transfer fails
     */
    error TransferFailed();
    
    /**
     * @dev Error thrown when trying to bridge to the same chain
     */
    error SameChain();
    
    /**
     * @dev Error thrown when receiver bridge is not configured
     */
    error ReceiverBridgeNotSet();
    
    /**
     * @dev Error thrown when mailbox is not configured
     */
    error MailboxNotSet();
    
    /**
     * @dev Error thrown when interchain gas paymaster is not configured
     */
    error InterchainGasPaymasterNotSet();

    // ============ Events ============
    
    /**
     * @dev Emitted when a cross-chain message is received
     * @param origin Origin chain domain ID
     * @param sender Sender address on the origin chain
     * @param message The received message body
     */
    event ReceivedMessage(uint32 origin, bytes32 sender, bytes message);

    // ============ State Variables ============
    
    /**
     * @dev Address of the helper testnet contract
     */
    address public helperTestnet;
    
    /**
     * @dev Address of the Hyperlane mailbox contract
     */
    address public mailbox;
    
    /**
     * @dev Address of the interchain gas paymaster contract
     */
    address public interchainGasPaymaster;
    
    /**
     * @dev Address of the token to bridge
     */
    address public token;

    /**
     * @dev Constructor for the BridgeTokenRouter contract
     * @param _helperTestnet Address of the helper testnet contract
     * @param _token Address of the token to bridge
     * @notice Initializes the router with helper and token addresses, configures mailbox
     * @custom:security Ensure helper and token addresses are valid before deployment
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

    // ============ Modifiers ============
    
    /**
     * @dev Modifier to restrict access to mailbox only
     */
    modifier onlyMailbox() {
        _onlyMailbox();
        _;
    }

    /**
     * @dev Internal function to check if caller is mailbox
     * @notice Reverts if caller is not the mailbox contract
     */
    function _onlyMailbox() internal view {
        if (msg.sender != address(mailbox)) revert NotMailbox();
    }

    // ============ External Functions ============
    
    /**
     * @dev Bridges tokens to another chain via Hyperlane
     * @param _amount Amount of tokens to bridge
     * @param _recipient Address to receive tokens on destination chain
     * @param _chainId Chain ID of the destination chain
     * @return messageId The unique identifier of the bridge message
     * @notice This function transfers tokens and sends cross-chain message
     * @custom:security Users must approve tokens before calling this function
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

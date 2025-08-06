// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IMessageRecipient} from "@hyperlane-xyz/interfaces/IMessageRecipient.sol";
import {ITokenSwap} from "./interfaces/ITokenSwap.sol";
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
 * @title IbranBridgeTokenReceiver
 * @dev Contract for receiving bridged tokens via Hyperlane cross-chain messaging
 * @notice This contract handles incoming token bridge messages and mints tokens to recipients
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract IbranBridgeTokenReceiver is IMessageRecipient {
    // ============ Errors ============
    
    /**
     * @dev Error thrown when mailbox is not configured for the current chain
     */
    error MailboxNotSet();
    
    /**
     * @dev Error thrown when a non-mailbox address tries to call restricted functions
     */
    error NotMailbox();

    // ============ Events ============
    
    /**
     * @dev Emitted when a cross-chain message is received and processed
     * @param origin Origin chain domain ID
     * @param sender Sender address on the origin chain
     * @param message The received message body
     */
    event ReceivedMessage(uint32 origin, bytes32 sender, bytes message);

    // ============ State Variables ============
    
    /**
     * @dev Address of the Hyperlane mailbox contract
     */
    address public mailbox;
    
    /**
     * @dev Address of the token contract to mint
     */
    address public token;
    
    /**
     * @dev Address of the helper testnet contract
     */
    address public helperTestnet;

    /**
     * @dev Constructor for the IbranBridgeTokenReceiver contract
     * @param _helperTestnet Address of the helper testnet contract
     * @param _token Address of the token contract to mint
     * @notice Initializes the receiver with helper and token addresses, configures mailbox
     * @custom:security Ensure helper and token addresses are valid before deployment
     */
    constructor(address _helperTestnet, address _token) {
        helperTestnet = _helperTestnet;
        (address _mailbox,,) = IHelperTestnet(helperTestnet).chains(block.chainid);
        if (_mailbox == address(0)) revert MailboxNotSet();
        mailbox = _mailbox;
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
     * @dev Handles incoming cross-chain messages from Hyperlane
     * @param _origin Origin chain domain ID
     * @param _sender Sender address on the origin chain
     * @param _messageBody The message body containing recipient and amount
     * @notice This function is called by Hyperlane when a cross-chain message arrives
     * @custom:security Only the mailbox can call this function
     */
    function handle(uint32 _origin, bytes32 _sender, bytes calldata _messageBody) external override onlyMailbox {
        (address recipient, uint256 amount) = abi.decode(_messageBody, (address, uint256));
        // ITokenSwap(token).mint(recipient, amount);
        ITokenSwap(token).mintMock(recipient, amount);
        emit ReceivedMessage(_origin, _sender, _messageBody);
    }
}

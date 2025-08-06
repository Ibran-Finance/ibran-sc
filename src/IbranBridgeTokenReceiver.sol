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
 * @author Ibran Protocol
 * @notice A bridge token receiver contract that handles incoming cross-chain token transfers
 * @dev This contract implements the Hyperlane IMessageRecipient interface to receive
 * cross-chain messages and mint tokens to recipients on the destination chain.
 * 
 * The contract:
 * - Receives messages from the Hyperlane mailbox
 * - Decodes recipient address and amount from the message
 * - Mints tokens to the recipient on the destination chain
 * - Validates that messages come from the correct mailbox
 * 
 * @custom:security This contract should only receive messages from the authorized
 * Hyperlane mailbox contract to prevent unauthorized token minting.
 */
contract IbranBridgeTokenReceiver is IMessageRecipient {
    // ============ ERRORS ============
    /// @notice Error thrown when the mailbox address is not set for the current chain
    error MailboxNotSet();
    /// @notice Error thrown when a function is called by an unauthorized mailbox
    error NotMailbox();

    // ============ EVENTS ============
    /// @notice Emitted when a message is received from the bridge
    /// @param origin The origin chain ID
    /// @param sender The sender address on the origin chain
    /// @param message The decoded message body
    event ReceivedMessage(uint32 origin, bytes32 sender, bytes message);

    // ============ STATE VARIABLES ============
    /// @notice The address of the Hyperlane mailbox contract
    address public mailbox;
    /// @notice The address of the token to mint
    address public token;
    /// @notice The address of the helper testnet contract
    address public helperTestnet;

    /**
     * @notice Constructor to initialize the bridge token receiver
     * @param _helperTestnet The address of the helper testnet contract
     * @param _token The address of the token to mint
     * @dev Gets the mailbox address from the helper contract for the current chain
     * @dev Reverts if the mailbox is not set for the current chain
     * 
     * @custom:error MailboxNotSet - If the mailbox address is not set for the current chain
     */
    constructor(address _helperTestnet, address _token) {
        helperTestnet = _helperTestnet;
        (address _mailbox,,) = IHelperTestnet(helperTestnet).chains(block.chainid);
        if (_mailbox == address(0)) revert MailboxNotSet();
        mailbox = _mailbox;
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
     * @notice Handles incoming cross-chain messages from Hyperlane
     * @param _origin The origin chain ID
     * @param _sender The sender address on the origin chain
     * @param _messageBody The encoded message body containing recipient and amount
     * @dev Only the mailbox can call this function
     * @dev Decodes the message to extract recipient address and amount
     * @dev Mints tokens to the recipient using the ITokenSwap interface
     * 
     * @custom:error NotMailbox - If the caller is not the mailbox
     */
    function handle(uint32 _origin, bytes32 _sender, bytes calldata _messageBody) external override onlyMailbox {
        (address recipient, uint256 amount) = abi.decode(_messageBody, (address, uint256));
        // ITokenSwap(token).mint(recipient, amount);
        ITokenSwap(token).mintMock(recipient, amount);
        emit ReceivedMessage(_origin, _sender, _messageBody);
    }
}

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.8.0;

import {IInterchainSecurityModule} from "@hyperlane-xyz/interfaces/IInterchainSecurityModule.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title IMailbox
 * @dev Interface for Hyperlane mailbox functionality
 * @notice This interface defines the contract for cross-chain message passing via Hyperlane
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
interface IMailbox {
    // ============ Events ============
    /**
     * @notice Emitted when a new message is dispatched via Hyperlane
     * @param sender The address that dispatched the message
     * @param destination The destination domain of the message
     * @param recipient The message recipient address on `destination`
     * @param message Raw bytes of message
     */
    event Dispatch(address indexed sender, uint32 indexed destination, bytes32 indexed recipient, bytes message);

    /**
     * @notice Emitted when a new message is dispatched via Hyperlane
     * @param messageId The unique message identifier
     */
    event DispatchId(bytes32 indexed messageId);

    /**
     * @notice Emitted when a Hyperlane message is processed
     * @param messageId The unique message identifier
     */
    event ProcessId(bytes32 indexed messageId);

    /**
     * @notice Emitted when a Hyperlane message is delivered
     * @param origin The origin domain of the message
     * @param sender The message sender address on `origin`
     * @param recipient The address that handled the message
     */
    event Process(uint32 indexed origin, bytes32 indexed sender, address indexed recipient);

    /**
     * @dev Returns the local domain identifier
     * @return The domain ID of the current chain
     */
    function localDomain() external view returns (uint32);

    /**
     * @dev Checks if a message has been delivered
     * @param messageId The unique message identifier
     * @return True if the message has been delivered, false otherwise
     */
    function delivered(bytes32 messageId) external view returns (bool);

    /**
     * @dev Returns the default interchain security module
     * @return Address of the default ISM contract
     */
    function defaultIsm() external view returns (IInterchainSecurityModule);

    /**
     * @dev Dispatches a message to another domain
     * @param _destinationDomain The destination domain ID
     * @param _recipientAddress The recipient address on the destination domain
     * @param _messageBody The message body to send
     * @return messageId The unique identifier of the dispatched message
     * @notice This function sends a cross-chain message via Hyperlane
     * @custom:security Messages should be validated on the destination chain
     */
    function dispatch(uint32 _destinationDomain, bytes32 _recipientAddress, bytes calldata _messageBody)
        external
        payable
        returns (bytes32);

    /**
     * @dev Processes an incoming message from another domain
     * @param _metadata The message metadata
     * @param _message The message body to process
     * @notice This function handles incoming cross-chain messages
     * @custom:security Messages should be validated before processing
     */
    function process(bytes calldata _metadata, bytes calldata _message) external;

    /**
     * @dev Returns the message count
     * @return The total number of messages processed
     */
    function count() external view returns (uint32);

    /**
     * @dev Returns the current merkle root
     * @return The merkle root of processed messages
     */
    function root() external view returns (bytes32);

    /**
     * @dev Returns the latest checkpoint information
     * @return root The merkle root of the latest checkpoint
     * @return index The index of the latest checkpoint
     */
    function latestCheckpoint() external view returns (bytes32, uint32);

    /**
     * @dev Returns the ISM for a specific recipient
     * @param _recipient The recipient address
     * @return The ISM contract for the recipient
     */
    function recipientIsm(address _recipient) external view returns (IInterchainSecurityModule);
}

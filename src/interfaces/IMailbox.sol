// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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
 * @dev Interface for mailbox functionality
 * @notice Defines the interface for cross-chain messaging and communication
 * @author IBRAN Team
 */
interface IMailbox {
    /**
     * @notice Dispatches a message to another chain
     * @dev Sends a cross-chain message with specified parameters
     * @param destinationDomain Domain ID of the destination chain
     * @param recipient Address on destination chain to receive the message
     * @param messageBody Message content to be sent
     * @return messageId Unique identifier for the dispatched message
     */
    function dispatch(
        uint32 destinationDomain,
        bytes32 recipient,
        bytes calldata messageBody
    ) external returns (bytes32 messageId);

    /**
     * @notice Processes an incoming message from another chain
     * @dev Handles messages received from other chains
     * @param message The message to be processed
     */
    function process(bytes calldata message) external;

    /**
     * @notice Returns the domain ID of the current chain
     * @dev Used to identify the current chain in cross-chain operations
     * @return Domain ID of the current chain
     */
    function localDomain() external view returns (uint32);

    /**
     * @notice Returns the address of the default ISM (Interchain Security Module)
     * @dev ISM handles security and validation of cross-chain messages
     * @return Address of the default ISM
     */
    function defaultIsm() external view returns (address);

    /**
     * @notice Returns the address of the default hook
     * @dev Hook allows for custom processing of messages
     * @return Address of the default hook
     */
    function defaultHook() external view returns (address);
}
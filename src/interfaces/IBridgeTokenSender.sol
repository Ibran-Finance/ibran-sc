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
 * @title IBridgeTokenSender
 * @dev Interface for bridge token sender functionality
 * @notice Defines the interface for sending tokens across chains via bridge
 * @author IBRAN Team
 */
interface IBridgeTokenSender {
    /**
     * @notice Sends tokens to another chain via bridge
     * @dev Initiates cross-chain token transfer
     * @param recipient Address on destination chain to receive tokens
     * @param amount Amount of tokens to send
     */
    function sendTokens(address recipient, uint256 amount) external;
}
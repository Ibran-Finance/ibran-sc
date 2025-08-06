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
 * @title IIbranBridgeTokenSender
 * @dev Interface for IBRAN bridge token sender functionality
 * @notice Defines the interface for IBRAN-specific bridge token operations
 * @author IBRAN Team
 */
interface IIbranBridgeTokenSender {
    /**
     * @notice Returns the chain ID associated with this bridge sender
     * @dev Returns the destination chain ID for this bridge contract
     * @return Chain ID of the destination chain
     */
    function chainId() external view returns (uint256);

    /**
     * @notice Sends tokens to another chain via IBRAN bridge
     * @dev Initiates cross-chain token transfer using IBRAN bridge protocol
     * @param recipient Address on destination chain to receive tokens
     * @param amount Amount of tokens to send
     */
    function sendTokens(address recipient, uint256 amount) external;
}
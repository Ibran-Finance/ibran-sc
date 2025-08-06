// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
 * @notice This interface defines the contract for cross-chain token bridging operations
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
interface IBridgeTokenSender {
    /**
     * @dev Bridges tokens to another chain
     * @param amount Amount of tokens to bridge
     * @param recipient Address to receive the tokens on the destination chain
     * @notice This function initiates a cross-chain token transfer
     * @custom:security Users must approve tokens before calling this function
     */
    function bridge(uint256 amount, address recipient) external payable;
}

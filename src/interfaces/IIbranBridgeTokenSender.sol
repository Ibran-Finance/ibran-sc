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
 * @dev Interface for Ibran bridge token sender functionality
 * @notice This interface defines the contract for cross-chain token bridging in the Ibran protocol
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
interface IIbranBridgeTokenSender {
    /**
     * @dev Returns the chain ID for this bridge sender
     * @return The chain ID where this bridge sender operates
     */
    function chainId() external view returns (uint32);
    
    /**
     * @dev Bridges tokens to another chain
     * @param _amount Amount of tokens to bridge
     * @param _recipient Address to receive the tokens on the destination chain
     * @param _token Address of the token to bridge
     * @return messageId The unique identifier of the bridge message
     * @notice This function initiates a cross-chain token transfer
     * @custom:security Users must approve tokens before calling this function
     */
    function bridge(uint256 _amount, address _recipient, address _token) external payable returns (bytes32);
}

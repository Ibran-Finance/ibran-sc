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
 * @title IWrappedToken
 * @dev Interface for wrapped token functionality
 * @notice This interface defines the contract for wrapped token operations
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
interface IWrappedToken {
    /**
     * @dev Mints wrapped tokens to a specified address
     * @param to Address to receive the minted wrapped tokens
     * @param amount Amount of wrapped tokens to mint
     * @notice This function creates new wrapped tokens and assigns them to the recipient
     * @custom:security Only authorized addresses should be able to mint wrapped tokens
     */
    function mint(address to, uint256 amount) external;
}

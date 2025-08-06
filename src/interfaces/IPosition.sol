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
 * @title IPosition
 * @dev Interface for position management functionality
 * @notice Defines the interface for managing user positions and assets
 * @author IBRAN Team
 */
interface IPosition {
    /**
     * @notice Gets the balance of a specific token for a user
     * @dev Returns the amount of tokens held in the user's position
     * @param user Address of the user
     * @param token Address of the token to check
     * @return balance Amount of tokens held by the user
     */
    function getBalance(address user, address token) external view returns (uint256 balance);

    /**
     * @notice Deposits tokens into a user's position
     * @dev Adds tokens to the user's position balance
     * @param user Address of the user
     * @param token Address of the token to deposit
     * @param amount Amount of tokens to deposit
     */
    function deposit(address user, address token, uint256 amount) external;

    /**
     * @notice Withdraws tokens from a user's position
     * @dev Removes tokens from the user's position balance
     * @param user Address of the user
     * @param token Address of the token to withdraw
     * @param amount Amount of tokens to withdraw
     */
    function withdraw(address user, address token, uint256 amount) external;

    /**
     * @notice Transfers tokens between users
     * @dev Moves tokens from one user's position to another
     * @param from Address of the sender
     * @param to Address of the recipient
     * @param token Address of the token to transfer
     * @param amount Amount of tokens to transfer
     */
    function transfer(address from, address to, address token, uint256 amount) external;

    /**
     * @notice Gets the total balance of a token across all positions
     * @dev Returns the total amount of a token held by all users
     * @param token Address of the token to check
     * @return totalBalance Total amount of tokens held by all users
     */
    function getTotalBalance(address token) external view returns (uint256 totalBalance);

    /**
     * @notice Checks if a user has sufficient balance for a token
     * @dev Returns true if user has enough tokens for the specified amount
     * @param user Address of the user
     * @param token Address of the token to check
     * @param amount Amount to check against
     * @return True if user has sufficient balance, false otherwise
     */
    function hasSufficientBalance(address user, address token, uint256 amount) external view returns (bool);
}
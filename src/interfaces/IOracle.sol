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
 * @title IOracle
 * @dev Interface for oracle functionality
 * @notice Defines the interface for price oracles and data feeds
 * @author IBRAN Team
 */
interface IOracle {
    /**
     * @notice Gets the latest price for a specific token
     * @dev Returns the current price of the token in USD (with 8 decimals)
     * @param token Address of the token to get price for
     * @return price Current price of the token in USD
     * @return timestamp Timestamp when the price was last updated
     */
    function getPrice(address token) external view returns (uint256 price, uint256 timestamp);

    /**
     * @notice Gets the latest price for a specific token pair
     * @dev Returns the current price of token A in terms of token B
     * @param tokenA Address of the first token
     * @param tokenB Address of the second token
     * @return price Current price of token A in terms of token B
     * @return timestamp Timestamp when the price was last updated
     */
    function getPrice(address tokenA, address tokenB) external view returns (uint256 price, uint256 timestamp);

    /**
     * @notice Checks if a price feed is available for a token
     * @dev Returns true if the oracle has price data for the specified token
     * @param token Address of the token to check
     * @return True if price feed is available, false otherwise
     */
    function hasPrice(address token) external view returns (bool);

    /**
     * @notice Gets the number of decimals for price precision
     * @dev Returns the number of decimal places used for price representation
     * @return Number of decimal places
     */
    function decimals() external view returns (uint8);
}
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
 * @title IPriceFeed
 * @dev Interface for price feed functionality
 * @notice Defines the interface for price feeds and market data
 * @author IBRAN Team
 */
interface IPriceFeed {
    /**
     * @notice Gets the latest price for a specific asset
     * @dev Returns the current price of the asset with timestamp
     * @param asset Address of the asset to get price for
     * @return price Current price of the asset
     * @return timestamp Timestamp when the price was last updated
     */
    function getPrice(address asset) external view returns (uint256 price, uint256 timestamp);

    /**
     * @notice Gets the latest price for a specific asset pair
     * @dev Returns the current price of asset A in terms of asset B
     * @param assetA Address of the first asset
     * @param assetB Address of the second asset
     * @return price Current price of asset A in terms of asset B
     * @return timestamp Timestamp when the price was last updated
     */
    function getPrice(address assetA, address assetB) external view returns (uint256 price, uint256 timestamp);

    /**
     * @notice Checks if a price feed is available for an asset
     * @dev Returns true if the price feed has data for the specified asset
     * @param asset Address of the asset to check
     * @return True if price feed is available, false otherwise
     */
    function hasPrice(address asset) external view returns (bool);

    /**
     * @notice Gets the number of decimals for price precision
     * @dev Returns the number of decimal places used for price representation
     * @return Number of decimal places
     */
    function decimals() external view returns (uint8);
}
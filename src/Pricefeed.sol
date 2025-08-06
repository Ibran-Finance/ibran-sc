// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title Pricefeed
 * @author Ibran Protocol
 * @notice A simple price feed contract that mimics Chainlink's price feed interface
 * @dev This contract provides a basic price feed implementation that can be used
 * for testing and development purposes. It implements the same interface as
 * Chainlink price feeds but with simplified functionality.
 * 
 * The contract allows the owner to set prices manually and provides a
 * latestRoundData() function that returns price data in the same format
 * as Chainlink price feeds.
 * 
 * @custom:security This contract should only be used for testing purposes.
 * For production, use actual Chainlink price feeds or other reliable
 * price oracle solutions.
 */
contract Pricefeed is Ownable {
    // ============ STATE VARIABLES ============
    /// @notice The token address this price feed is for
    address public token;
    /// @notice The current round ID
    uint80 public roundId;
    /// @notice The current price (in 8 decimals)
    uint256 public price;
    /// @notice The timestamp when the price was first set
    uint256 public startedAt;
    /// @notice The timestamp when the price was last updated
    uint256 public updatedAt;
    /// @notice The round ID when the price was last answered
    uint80 public answeredInRound;
    /// @notice The number of decimals for the price (8 for compatibility with Chainlink)
    uint8 public decimals = 8;

    /**
     * @notice Constructor to initialize the price feed
     * @param _token The address of the token this price feed is for
     * @dev Sets the token address and initializes the owner
     */
    constructor(address _token) Ownable(msg.sender) {
        token = _token;
    }

    /**
     * @notice Sets the price for the token
     * @param _price The new price to set (in 8 decimals)
     * @dev Only the owner can call this function
     * @dev Updates all price feed data including timestamps and round ID
     * 
     * @custom:error "Ownable: caller is not the owner" - If caller is not the owner
     */
    function setPrice(uint256 _price) public onlyOwner {
        roundId = 1;
        price = _price;
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = 1;
    }

    /**
     * @notice Returns the latest price data in Chainlink format
     * @return roundId The current round ID
     * @return price The current price
     * @return startedAt The timestamp when the price was first set
     * @return updatedAt The timestamp when the price was last updated
     * @return answeredInRound The round ID when the price was last answered
     * @dev This function mimics the Chainlink price feed interface
     * @dev Returns data in the same format as Chainlink's latestRoundData()
     */
    function latestRoundData() public view returns (uint80, uint256, uint256, uint256, uint80) {
        return (roundId, price, startedAt, updatedAt, answeredInRound);
    }
}

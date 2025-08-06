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
 * @title IHelperTestnet
 * @dev Interface for testnet helper functionality
 * @notice Defines the interface for helper functions used in testnet environments
 * @author IBRAN Team
 */
interface IHelperTestnet {
    /**
     * @notice Gets the chain ID of the current network
     * @dev Returns the chain ID for network identification
     * @return chainId Chain ID of the current network
     */
    function getChainId() external view returns (uint256 chainId);

    /**
     * @notice Gets the current block timestamp
     * @dev Returns the timestamp of the current block
     * @return timestamp Current block timestamp
     */
    function getCurrentTimestamp() external view returns (uint256 timestamp);

    /**
     * @notice Gets the current block number
     * @dev Returns the number of the current block
     * @return blockNumber Current block number
     */
    function getCurrentBlockNumber() external view returns (uint256 blockNumber);

    /**
     * @notice Gets the balance of a token for a specific address
     * @dev Returns the token balance of the specified address
     * @param token Address of the token to check
     * @param account Address to check balance for
     * @return balance Token balance of the account
     */
    function getTokenBalance(address token, address account) external view returns (uint256 balance);

    /**
     * @notice Gets the native token balance of an address
     * @dev Returns the ETH/BNB/etc. balance of the specified address
     * @param account Address to check balance for
     * @return balance Native token balance of the account
     */
    function getNativeBalance(address account) external view returns (uint256 balance);
}
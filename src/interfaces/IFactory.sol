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
 * @title IFactory
 * @dev Interface for factory functionality
 * @notice Defines the interface for creating and managing lending pools
 * @author IBRAN Team
 */
interface IFactory {
    /**
     * @notice Creates a new lending pool
     * @dev Deploys a new lending pool contract with specified parameters
     * @param token Address of the token for the lending pool
     * @param ltv Loan-to-value ratio for the pool (in basis points)
     * @return poolAddress Address of the deployed lending pool
     */
    function createLendingPool(address token, uint256 ltv) external returns (address poolAddress);

    /**
     * @notice Gets the lending pool for a specific token
     * @dev Returns the address of the lending pool associated with the token
     * @param token Address of the token to query
     * @return poolAddress Address of the lending pool for the token
     */
    function getLendingPool(address token) external view returns (address poolAddress);

    /**
     * @notice Checks if a lending pool exists for a token
     * @dev Returns true if a lending pool has been created for the token
     * @param token Address of the token to check
     * @return True if lending pool exists, false otherwise
     */
    function hasLendingPool(address token) external view returns (bool);

    /**
     * @notice Gets the total number of lending pools created
     * @dev Returns the count of all lending pools deployed by this factory
     * @return Total number of lending pools
     */
    function getLendingPoolCount() external view returns (uint256);

    /**
     * @notice Gets the lending pool at a specific index
     * @dev Returns the address of the lending pool at the given index
     * @param index Index of the lending pool to retrieve
     * @return poolAddress Address of the lending pool at the specified index
     */
    function getLendingPoolAtIndex(uint256 index) external view returns (address poolAddress);
}
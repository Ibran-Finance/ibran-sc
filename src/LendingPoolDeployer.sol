// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {LendingPool} from "./LendingPool.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title LendingPoolDeployer
 * @author Ibran Protocol
 * @notice A factory contract for deploying new LendingPool instances
 * @dev This contract is responsible for creating new lending pools with specified parameters
 *
 * The LendingPoolDeployer allows the factory to create new lending pools with different
 * collateral and borrow token pairs, along with configurable loan-to-value (LTV) ratios.
 * Each deployed pool is a separate contract instance that manages lending and borrowing
 * operations for a specific token pair.
 * 
 * @custom:security This contract should only be called by authorized factory contracts
 * to ensure proper pool deployment and management.
 */
contract LendingPoolDeployer {
    // ============ ERRORS ============
    /// @notice Error thrown when a function is called by an unauthorized factory
    error OnlyFactoryCanCall();
    /// @notice Error thrown when a function is called by an unauthorized owner
    error OnlyOwnerCanCall();

    // ============ STATE VARIABLES ============
    /// @notice The address of the factory contract that can deploy pools
    address public factory;
    /// @notice The owner of the deployer contract
    address public owner;

    /**
     * @notice Constructor to initialize the deployer contract
     * @dev Sets the owner to msg.sender
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Modifier to restrict function access to the factory only
     * @dev Reverts with OnlyFactoryCanCall error if the caller is not the factory
     */
    modifier onlyFactory() {
        _onlyFactory();
        _;
    }

    /**
     * @notice Internal function to check if the caller is the factory
     * @dev Reverts with OnlyFactoryCanCall error if the caller is not the factory
     */
    function _onlyFactory() internal view {
        if (msg.sender != factory) revert OnlyFactoryCanCall();
    }

    /**
     * @notice Modifier to restrict function access to the owner only
     * @dev Reverts with OnlyOwnerCanCall error if the caller is not the owner
     */
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    /**
     * @notice Internal function to check if the caller is the owner
     * @dev Reverts with OnlyOwnerCanCall error if the caller is not the owner
     */
    function _onlyOwner() internal view {
        if (msg.sender != owner) revert OnlyOwnerCanCall();
    }

    /**
     * @notice Deploys a new LendingPool contract with specified parameters
     * @param _collateralToken The address of the collateral token (e.g., WETH, WBTC)
     * @param _borrowToken The address of the borrow token (e.g., USDC, USDT)
     * @param _ltv The loan-to-value ratio as a percentage (e.g., 8e17 for 80%)
     * @return The address of the newly deployed LendingPool contract
     *
     * @dev This function creates a new LendingPool instance with the provided parameters.
     * The ltv parameter should be provided as a basis point value (e.g., 8e17 = 80%).
     * Only the factory contract should call this function to ensure proper pool management.
     *
     * Requirements:
     * - _collateralToken must be a valid ERC20 token address
     * - _borrowToken must be a valid ERC20 token address
     * - _ltv must be greater than 0 and less than or equal to 1e18 (100%)
     *
     * @custom:security This function should only be called by the factory contract
     * @custom:error OnlyFactoryCanCall - If the caller is not the factory
     */
    function deployLendingPool(address _collateralToken, address _borrowToken, uint256 _ltv)
        public
        onlyFactory
        returns (address)
    {
        LendingPool lendingPool = new LendingPool(_collateralToken, _borrowToken, factory, _ltv);
        return address(lendingPool);
    }

    /**
     * @notice Sets the factory address that can deploy lending pools
     * @param _factory The address of the factory contract
     * @dev Only the owner can call this function
     * 
     * @custom:error OnlyOwnerCanCall - If the caller is not the owner
     */
    function setFactory(address _factory) public onlyOwner {
        factory = _factory;
    }
}

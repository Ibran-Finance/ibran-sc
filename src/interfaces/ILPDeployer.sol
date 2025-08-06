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
 * @title ILPDeployer
 * @dev Interface for lending pool deployer functionality
 * @notice Defines the interface for deploying new lending pools
 * @author IBRAN Team
 */
interface ILPDeployer {
    /**
     * @notice Deploys a new lending pool
     * @dev Creates a new lending pool contract with specified parameters
     * @param token Address of the token for the lending pool
     * @param ltv Loan-to-value ratio for the pool (in basis points)
     * @return poolAddress Address of the deployed lending pool
     */
    function deployLendingPool(address token, uint256 ltv) external returns (address poolAddress);
}
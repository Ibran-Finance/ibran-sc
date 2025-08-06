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
 * @title IIsHealthy
 * @dev Interface for health check functionality
 * @notice Defines the interface for checking system health and status
 * @author IBRAN Team
 */
interface IIsHealthy {
    /**
     * @notice Checks if the system is in a healthy state
     * @dev Returns true if all health checks pass
     * @return True if system is healthy, false otherwise
     */
    function isHealthy() external view returns (bool);

    /**
     * @notice Gets the current health status with detailed information
     * @dev Returns health status and any relevant health metrics
     * @return healthy Boolean indicating if system is healthy
     * @return details Additional health information
     */
    function getHealthStatus() external view returns (bool healthy, string memory details);
}
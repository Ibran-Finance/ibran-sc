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
 * @title ITokenSwap
 * @dev Interface for token swap functionality
 * @notice Defines the interface for swapping tokens between different types
 * @author IBRAN Team
 */
interface ITokenSwap {
    /**
     * @notice Swaps tokens from one type to another
     * @dev Executes a token swap operation
     * @param tokenIn Address of the input token
     * @param tokenOut Address of the output token
     * @param amountIn Amount of input tokens to swap
     * @return amountOut Amount of output tokens received
     */
    function swap(address tokenIn, address tokenOut, uint256 amountIn) external returns (uint256 amountOut);
}

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
 * @title ISwapRouter
 * @dev Interface for swap router functionality
 * @notice Defines the interface for executing token swaps with exact input parameters
 * @author IBRAN Team
 */
interface ISwapRouter {
    /**
     * @dev Struct containing parameters for exact input single token swap
     * @param tokenIn Address of the input token
     * @param tokenOut Address of the output token
     * @param fee Fee tier for the swap (in basis points)
     * @param recipient Address to receive the output tokens
     * @param amountIn Amount of input tokens to swap
     * @param amountOutMinimum Minimum amount of output tokens to receive
     * @param sqrtPriceLimitX96 Price limit for the swap (sqrt price in X96 format)
     */
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /**
     * @notice Executes a swap with exact input amount
     * @dev Swaps exact amount of input tokens for output tokens
     * @param params Struct containing swap parameters
     * @return amountOut Amount of output tokens received
     */
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ILendingPool} from "../src/interfaces/ILendingPool.sol";
import {Helper} from "./Helper.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title Shortcut_SwapCollateral
 * @author Ibran Team
 * @notice Script for swapping collateral tokens within a user's position
 * @dev This script allows users to swap collateral tokens within their lending pool position.
 * The script handles:
 * - Getting the user's position address from the lending pool
 * - Checking token balances before and after the swap
 * - Executing the token swap within the position
 * - Logging the swap operation details
 * 
 * The script provides comprehensive logging to track the swap process
 * and verify the token balance changes.
 * 
 * @custom:security This script should only be run by authorized users with proper
 * private key management
 */
contract Shortcut_SwapCollateral is Script, Helper {
    // ============ CONFIGURATION PARAMETERS ============
    /** @notice User's wallet address for the swap operation */
    address public yourWallet = vm.envAddress("ADDRESS");
    /** @notice Amount to swap (will be multiplied by 1e17) */
    uint256 public amount = 1;
    /** @notice Token to swap from (default: WETH) */
    address public tokenIn = ORIGIN_WETH;
    /** @notice Token to swap to (default: USDC) */
    address public tokenOut = ORIGIN_USDC;
    // ----------------------------

    /**
     * @notice Sets up the deployment environment by creating a fork of the target chain
     * @dev Currently configured for Etherlink testnet. Can be modified for other chains
     * by uncommenting the appropriate vm.createSelectFork line
     */
    function setUp() public {
        // ***************** HOST CHAIN *****************
        vm.createSelectFork(vm.rpcUrl("etherlink_testnet"));
        // **********************************************
        // vm.createSelectFork(vm.rpcUrl("rise_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("op_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("avalanche_fuji"));
        // vm.createSelectFork(vm.rpcUrl("cachain_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("educhain"));
        // vm.createSelectFork(vm.rpcUrl("pharos_devnet"));
        // vm.createSelectFork(vm.rpcUrl("op_sepolia"));
    }

    /**
     * @notice Main function that executes the collateral token swap
     * @dev This function performs the following steps:
     * 1. Gets the user's position address from the lending pool
     * 2. Checks token balances before the swap
     * 3. Executes the token swap within the position
     * 4. Checks token balances after the swap
     * 5. Logs all balance changes for verification
     * 
     * The function includes comprehensive logging to track the swap process
     * and provides detailed information about token balances before and after
     * the operation.
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address userPosition = ILendingPool(ORIGIN_lendingPool).addressPositions(yourWallet);

        vm.startBroadcast(privateKey);
        uint256 tokenInBefore = IERC20(tokenIn).balanceOf(userPosition);
        uint256 tokenOutBefore = IERC20(tokenOut).balanceOf(userPosition);
        console.log("tokenInBefore", tokenInBefore);
        console.log("tokenOutBefore", tokenOutBefore);
        ILendingPool(ORIGIN_lendingPool).swapTokenByPosition(tokenIn, tokenOut, amount * 1e17);
        uint256 tokenInAfter = IERC20(tokenIn).balanceOf(userPosition);
        uint256 tokenOutAfter = IERC20(tokenOut).balanceOf(userPosition);
        console.log("tokenInAfter", tokenInAfter);
        console.log("tokenOutAfter", tokenOutAfter);
        console.log("--------------------------------");
        vm.stopBroadcast();
    }
    // RUN
    // forge script Shortcut_SwapCollateral -vvv --broadcast
}

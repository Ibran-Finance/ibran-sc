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
 * @dev Script for swapping collateral tokens in lending pools
 * @notice This contract handles collateral token swaps within user positions
 * @author Ibran Team
 */
contract Shortcut_SwapCollateral is Script, Helper {
    // --------- FILL THIS ----------
    address public yourWallet = vm.envAddress("ADDRESS");
    uint256 public amount = 1;
    address public tokenIn = MOCK_WETH;
    address public tokenOut = MOCK_USDC;
    // ----------------------------

    /**
     * @dev Sets up the deployment environment by creating a fork of the target network
     * @notice This function initializes the blockchain environment for deployment
     */
    function setUp() public {
        // ***************** HOST CHAIN *****************
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
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
     * @dev Main function to swap collateral tokens within user position
     * @notice This function handles the collateral swap process within the user's lending pool position
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address userPosition = ILendingPool(BASE_lendingPool).addressPositions(yourWallet);

        vm.startBroadcast(privateKey);
        uint256 tokenInBefore = IERC20(tokenIn).balanceOf(userPosition);
        uint256 tokenOutBefore = IERC20(tokenOut).balanceOf(userPosition);
        console.log("tokenInBefore", tokenInBefore);
        console.log("tokenOutBefore", tokenOutBefore);
        ILendingPool(BASE_lendingPool).swapTokenByPosition(tokenIn, tokenOut, amount * 1e17);
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

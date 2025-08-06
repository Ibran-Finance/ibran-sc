// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20Metadata} from "@openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Helper} from "./Helper.sol";
import {ILendingPool} from "../src/interfaces/ILendingPool.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title LPSupplyCollateralScript
 * @author Ibran Team
 * @notice Script for supplying collateral to the lending pool
 * @dev This script allows users to supply collateral tokens to the lending pool.
 * The script handles:
 * - Getting the collateral token address from the lending pool
 * - Checking user's token balance before supply
 * - Calculating the supply amount with proper decimals
 * - Approving the lending pool to spend the tokens
 * - Executing the collateral supply operation
 * - Tracking balance before and after supply
 * 
 * The script includes balance validation to ensure the user has sufficient tokens
 * before attempting to supply collateral.
 * 
 * @custom:security This script should only be run by authorized users with proper
 * private key management
 */
contract LPSupplyCollateralScript is Script, Helper {
    // ============ CONFIGURATION PARAMETERS ============
    /** @notice User's wallet address for the supply collateral operation */
    address public yourWallet = vm.envAddress("ADDRESS");
    /** @notice Amount to supply (will be multiplied by token decimals) */
    uint256 public amount = 2;
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
     * @notice Main function that executes the collateral supply to the lending pool
     * @dev This function performs the following steps:
     * 1. Gets the collateral token address from the lending pool
     * 2. Calculates the supply amount with proper decimals
     * 3. Adjusts amount based on token decimals (3 for tokens with >=6 decimals)
     * 4. Checks if user has sufficient balance
     * 5. Approves the lending pool to spend the tokens
     * 6. Executes the collateral supply operation
     * 7. Tracks balance before and after supply
     * 
     * The function includes comprehensive logging to track the supply process
     * and provides detailed information about balances and supply amounts.
     * 
     * @custom:error Insufficient token balance for supply operation
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address collateralToken = ILendingPool(ORIGIN_lendingPool).collateralToken();
        uint256 decimal = IERC20Metadata(collateralToken).decimals();

        vm.startBroadcast(privateKey);
        amount = decimal >= 6 ? 3 : amount;
        uint256 amountSupplyCollateral = amount * (10 ** decimal);

        uint256 balance = IERC20(collateralToken).balanceOf(yourWallet);

        if (balance < amountSupplyCollateral) {
            console.log("not enough collateral");
            console.log("balance", balance);
            return;
        } else {
            console.log("Your balance before supply collateral", balance);
            IERC20(collateralToken).approve(ORIGIN_lendingPool, amountSupplyCollateral);
            ILendingPool(ORIGIN_lendingPool).supplyCollateral(amountSupplyCollateral);
            console.log("success");
            console.log("Your balance after supply collateral", IERC20(collateralToken).balanceOf(yourWallet));
        }
        vm.stopBroadcast();
    }
    // RUN
    // forge script LPSupplyCollateralScript -vvv --broadcast
}

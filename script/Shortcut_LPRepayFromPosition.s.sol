// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
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
 * @title LPRepayFromPositionScript
 * @author Ibran Team
 * @notice Script for repaying debt from a user's position using position funds
 * @dev This script allows users to repay their borrowed debt using funds from their
 * position rather than from their wallet. The script handles:
 * - Calculating the repayment amount with proper decimals
 * - Checking the user's debt before repayment
 * - Approving the lending pool to spend the repayment token
 * - Executing the repayment from position (using position funds)
 * - Tracking debt before and after repayment
 * 
 * The script provides comprehensive logging to track the repayment process
 * and verify the debt reduction.
 * 
 * @custom:security This script should only be run by authorized users with proper
 * private key management
 */
contract LPRepayFromPositionScript is Script, Helper {
    // ============ CONFIGURATION PARAMETERS ============
    /** @notice User's wallet address for the repay operation */
    address public yourWallet = vm.envAddress("ADDRESS");
    /** @notice Amount to repay (will be multiplied by token decimals) */
    uint256 public amount = 1;
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
        // vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("avalanche_fuji"));
    }

    /**
     * @notice Main function that executes the debt repayment from position
     * @dev This function performs the following steps:
     * 1. Gets the borrow token address from the lending pool
     * 2. Calculates the repayment amount with proper decimals
     * 3. Checks the user's debt before repayment
     * 4. Calculates the shares to be repaid
     * 5. Approves the lending pool to spend the repayment token
     * 6. Executes the repayment from position (using position funds)
     * 7. Tracks the debt after repayment
     * 
     * The function includes comprehensive logging to track the repayment process
     * and provides detailed information about debt before and after the operation.
     * 
     * The key difference from regular repayment is that this uses position funds
     * (true parameter in repayWithSelectedToken) instead of wallet funds.
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address borrowToken = ILendingPool(ORIGIN_lendingPool).borrowToken();
        uint256 decimals = 10 ** IERC20Metadata(borrowToken).decimals();
        uint256 amountToPay = amount * decimals;

        uint256 debtBefore = ILendingPool(ORIGIN_lendingPool).userBorrowShares(yourWallet);
        console.log("debtBefore", debtBefore);
        vm.startBroadcast(privateKey);
        // approve
        uint256 shares = (
            (amountToPay * ILendingPool(ORIGIN_lendingPool).totalBorrowShares())
                / ILendingPool(ORIGIN_lendingPool).totalBorrowAssets()
        );
        IERC20(borrowToken).approve(ORIGIN_lendingPool, amountToPay + 1e6);
        ILendingPool(ORIGIN_lendingPool).repayWithSelectedToken(shares, address(ORIGIN_USDC), true);
        uint256 debtAfter = ILendingPool(ORIGIN_lendingPool).userBorrowShares(yourWallet);
        console.log("-------------------------------- repay from position --------------------------------");
        console.log("debtAfter", debtAfter);
        vm.stopBroadcast();
    }

    // RUN
    // forge script LPRepayFromPositionScript -vvv --broadcast
}

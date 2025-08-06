// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20Metadata} from "@openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IInterchainGasPaymaster} from "@hyperlane-xyz/interfaces/IInterchainGasPaymaster.sol";
import {Helper} from "./Helper.sol";
import {ILendingPool} from "../src/interfaces/ILendingPool.sol";
import {IHelperTestnet} from "../src/interfaces/IHelperTestnet.sol";
import {IFactory} from "../src/interfaces/IFactory.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title LPBorrowScript
 * @author Ibran Team
 * @notice Script for borrowing debt from the lending pool with cross-chain functionality
 * @dev This script allows users to borrow tokens from the lending pool and automatically
 * handles the cross-chain gas payment for the transaction. The script:
 * - Checks if the lending pool has sufficient borrow balance
 * - Calculates the required gas payment for cross-chain operations
 * - Executes the borrow operation with proper gas handling
 * 
 * The script supports multiple chains and automatically detects the current chain
 * to determine if gas payment is required for cross-chain operations.
 * 
 * @custom:security This script should only be run by authorized users with proper
 * private key management
 */
contract LPBorrowScript is Script, Helper {
    // ============ CONFIGURATION PARAMETERS ============
    /** @notice User's wallet address for the borrow operation */
    address public yourWallet = vm.envAddress("ADDRESS");
    /** @notice Amount to borrow (will be multiplied by token decimals) */
    uint256 public amount = 1;
    // uint32 public chainId = 421614;
    /** @notice Destination chain ID for the borrow operation */
    uint32 public chainId = 84532;
    // uint256 public chainId = 128123;
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
     * @notice Main function that executes the borrow operation from the lending pool
     * @dev This function performs the following steps:
     * 1. Gets the borrow token address from the lending pool
     * 2. Checks if the lending pool has sufficient borrow balance
     * 3. Calculates the borrow amount with proper decimals
     * 4. Determines if cross-chain gas payment is required
     * 5. Executes the borrow operation with appropriate gas handling
     * 
     * The function includes comprehensive logging to track the operation status
     * and provides detailed information about balances and gas calculations.
     * 
     * @custom:error Insufficient borrow balance in the lending pool
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address borrowToken = ILendingPool(ORIGIN_lendingPool).borrowToken();
        uint256 lpBorrowBalance = IERC20(borrowToken).balanceOf(ORIGIN_lendingPool);
        uint256 decimal = IERC20Metadata(borrowToken).decimals();
        uint256 amountBorrow = amount * (10 ** decimal);

        vm.startBroadcast(privateKey);
        if (lpBorrowBalance < amountBorrow) {
            console.log("not enough borrow balance");
            console.log("lpBorrowBalance", lpBorrowBalance);
            console.log("Your debt amount application", amountBorrow);
            return;
        } else {
            console.log("LP balance before borrow", lpBorrowBalance);
            console.log("borrow token address", borrowToken);

            address helperTestnet = IFactory(ORIGIN_lendingPoolFactory).helper();
            (,, uint32 destinationDomain) = IHelperTestnet(helperTestnet).chains(uint256(chainId));
            console.log("destinationDomain", destinationDomain);
            (, address interchainGasPaymaster,) = IHelperTestnet(helperTestnet).chains(uint256(block.chainid));
            console.log("interchainGasPaymaster", interchainGasPaymaster);
            uint256 gasAmount;
            if (block.chainid == chainId) {
                gasAmount = 0;
            } else {
                gasAmount =
                    IInterchainGasPaymaster(interchainGasPaymaster).quoteGasPayment(destinationDomain, amountBorrow);
                console.log("gasAmount", gasAmount);
            }
            ILendingPool(ORIGIN_lendingPool).borrowDebt{value: gasAmount}(amountBorrow, chainId, 0);

            console.log("success");
            console.log("LP balance after borrow", IERC20(borrowToken).balanceOf(ORIGIN_lendingPool));
        }
        vm.stopBroadcast();
    }
    // RUN
    // forge script LPBorrowScript -vvv --broadcast
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20Metadata} from "@openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {Helper} from "./Helper.sol";
import {ITokenSwap} from "../src/interfaces/ITokenSwap.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title FaucetsScript
 * @author Ibran Team
 * @notice Script for minting mock tokens from faucets for testing purposes
 * @dev This script allows users to mint mock tokens from the faucet for testing
 * the cross-chain lending protocol. The script handles:
 * - Calculating the mint amount with proper decimals
 * - Minting tokens to the user's address
 * - Logging the mint operation details
 * 
 * The script is designed for testnet environments and should not be used
 * in production. It provides a convenient way to obtain test tokens for
 * protocol testing and development.
 * 
 * @custom:security This script should only be run on testnet environments
 * and by authorized users for testing purposes
 */
contract FaucetsScript is Script, Helper {
    // ============ CONFIGURATION PARAMETERS ============
    /** @notice Token address to mint from faucet (default: USDC) */
    address public claimToken = ORIGIN_USDC;
    /** @notice Amount to mint (will be multiplied by token decimals) */
    uint256 public amount = 10_000;
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
     * @notice Main function that mints tokens from the faucet
     * @dev This function performs the following steps:
     * 1. Gets the token decimals from the ERC20Metadata interface
     * 2. Calculates the mint amount with proper decimals
     * 3. Mints the tokens to the user's address using the ITokenSwap interface
     * 4. Logs the mint operation details including amount and address
     * 
     * The function uses the claimAddress from the Helper contract which is
     * set from the ADDRESS environment variable.
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        uint256 decimal = IERC20Metadata(claimToken).decimals();
        uint256 amountFaucets = amount * (10 ** decimal);

        vm.startBroadcast(privateKey);
        ITokenSwap(claimToken).mintMock(claimAddress, amountFaucets);
        console.log("faucet success amount", amountFaucets);
        console.log("faucet success address", claimAddress);
        vm.stopBroadcast();
    }
    // RUN
    // forge script FaucetsScript -vvv --broadcast
}

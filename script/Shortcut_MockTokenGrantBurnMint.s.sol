// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
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
 * @title MockTokenGrantBurnMint
 * @author Ibran Team
 * @notice Script for granting mint and burn roles to bridge token senders
 * @dev This script grants mint and burn roles to bridge token senders for all mock tokens
 * on the Arbitrum Sepolia testnet. This is a crucial step in setting up cross-chain
 * token functionality, as bridge token senders need the ability to mint and burn tokens
 * when facilitating cross-chain transfers.
 * 
 * The script handles:
 * - USDC token bridge sender role granting
 * - USDT token bridge sender role granting
 * - WXTZ token bridge sender role granting
 * - WBTC token bridge sender role granting
 * - WETH token bridge sender role granting
 * 
 * @custom:security This script should only be run by authorized deployers with proper
 * role management permissions
 */
contract MockTokenGrantBurnMint is Script, Helper {
    /**
     * @notice Sets up the deployment environment by creating a fork of the target chain
     * @dev Currently configured for Arbitrum Sepolia testnet. Can be modified for other chains
     * by uncommenting the appropriate vm.createSelectFork line
     */
    function setUp() public {
        // host chain
        vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    /**
     * @notice Main function that grants mint and burn roles to bridge token senders
     * @dev This function performs the following steps for each mock token:
     * 1. Gets the bridge token sender address for the target chain (Base Sepolia - 84532)
     * 2. Grants mint and burn roles to the bridge token sender
     * 
     * The process is repeated for all mock tokens:
     * - USDC (ARB_USDC)
     * - USDT (ARB_USDT)
     * - WXTZ (ARB_WXTZ)
     * - WBTC (ARB_WBTC)
     * - WETH (ARB_WETH)
     * 
     * This enables the bridge token senders to mint tokens when receiving cross-chain
     * transfers and burn tokens when sending cross-chain transfers.
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        
        // Grant roles for USDC
        address tokenSenderUSDC = ITokenSwap(ARB_USDC).bridgeTokenSenders(84532, 0);
        ITokenSwap(ARB_USDC).grantMintAndBurnRoles(tokenSenderUSDC);

        // Grant roles for USDT
        address tokenSenderUSDT = ITokenSwap(ARB_USDT).bridgeTokenSenders(84532, 0);
        ITokenSwap(ARB_USDT).grantMintAndBurnRoles(tokenSenderUSDT);

        // Grant roles for WXTZ
        address tokenSenderWxtz = ITokenSwap(ARB_WXTZ).bridgeTokenSenders(84532, 0);
        ITokenSwap(ARB_WXTZ).grantMintAndBurnRoles(tokenSenderWxtz);

        // Grant roles for WBTC
        address tokenSenderWBTC = ITokenSwap(ARB_WBTC).bridgeTokenSenders(84532, 0);
        ITokenSwap(ARB_WBTC).grantMintAndBurnRoles(tokenSenderWBTC);

        // Grant roles for WETH
        address tokenSenderWETH = ITokenSwap(ARB_WETH).bridgeTokenSenders(84532, 0);
        ITokenSwap(ARB_WETH).grantMintAndBurnRoles(tokenSenderWETH);

        vm.stopBroadcast();
    }
    // RUN
    // forge script MockTokenGrantBurnMint -vvv --broadcast
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

interface IAccountRouter {
    function enrollRemoteRouterAndIsm(uint32 _destinationDomain, bytes32 _router, bytes32 _ism) external;
}

/**
 * @title ShortcutPairBridgeScript
 * @author Ibran Team
 * @notice Script for enrolling remote routers and ISMs (Interchain Security Modules) for cross-chain communication
 * @dev This script handles the enrollment of remote routers and ISMs on both source and destination chains
 * to enable secure cross-chain communication in the Hyperlane protocol. The script supports:
 * - Etherlink Testnet (Chain ID: 128123)
 * - Base Sepolia (Chain ID: 84532)
 * - Arbitrum Sepolia (Chain ID: 421614)
 * 
 * The enrollment process is bidirectional, requiring execution on both chains to establish
 * a complete cross-chain communication channel.
 * 
 * @custom:security This script should only be run by authorized deployers with proper
 * chain configuration
 */
contract ShortcutPairBridgeScript is Script {
    // ============ ETHERLINK TESTNET CONFIGURATION ============
    /** @notice Mailbox contract address on Etherlink testnet */
    address public ETHERLINK_TESTNET_MAILBOX = 0xDfaa17BF52afc5a12d06964555fAAFDADD53FF5e;
    /** @notice Domain ID for Etherlink testnet */
    uint32 public ETHERLINK_TESTNET_DOMAIN = 128123;
    /** @notice Account router address on Etherlink testnet */
    address public ETHERLINK_TESTNET_ACCOUNT_ROUTER = 0xC4c34aFF9f5dE4D9623349ce8EAc8589cE796fD7;
    /** @notice Interchain Security Module address on Etherlink testnet */
    address public ETHERLINK_TESTNET_ISM = 0x8fe413C32a6A481f5926460E45d04D07d9Be2700;

    // ============ BASE SEPOLIA CONFIGURATION ============
    /** @notice Mailbox contract address on Base Sepolia */
    address public BASE_SEPOLIA_MAILBOX = 0x743Ff3d08e13aF951e4b60017Cf261BFc8457aE4;
    /** @notice Domain ID for Base Sepolia */
    uint32 public BASE_SEPOLIA_DOMAIN = 84532;
    /** @notice Account router address on Base Sepolia */
    address public BASE_SEPOLIA_ACCOUNT_ROUTER = 0x677a021bdf36a7409D02A974cb6E19EE4c2F0632;
    /** @notice Interchain Security Module address on Base Sepolia */
    address public BASE_SEPOLIA_ISM = 0x924fF8657070da8e038F0B5867e09aFd7c46D1A9;

    // ============ ARBITRUM SEPOLIA CONFIGURATION ============
    /** @notice Mailbox contract address on Arbitrum Sepolia */
    address public ARB_SEPOLIA_MAILBOX = 0xeeCe1088FD44E74Eb7B0045a4798a4c97A8143dC;
    /** @notice Domain ID for Arbitrum Sepolia */
    uint32 public ARB_SEPOLIA_DOMAIN = 421614;
    /** @notice Account router address on Arbitrum Sepolia */
    address public ARB_SEPOLIA_ACCOUNT_ROUTER = 0xdf2706AD5966ac71C9016b4a4F93c9054e48F54b;
    /** @notice Interchain Security Module address on Arbitrum Sepolia */
    address public ARB_SEPOLIA_ISM = 0x810bCA522337827fC846edd5d34020080Ecbfc0B;

    // ============ DESTINATION CHAIN CONFIGURATION ============
    // ** Deploy hyperlane on new chain
    /** @notice Mailbox contract address for destination chain (currently Arbitrum Sepolia) */
    address public DESTINATION_CHAIN_MAILBOX = ARB_SEPOLIA_MAILBOX;
    /** @notice Domain ID for destination chain (currently Arbitrum Sepolia) */
    uint32 public DESTINATION_CHAIN_DOMAIN = ARB_SEPOLIA_DOMAIN;
    /** @notice Account router address for destination chain (currently Arbitrum Sepolia) */
    address public DESTINATION_CHAIN_ACCOUNT_ROUTER = ARB_SEPOLIA_ACCOUNT_ROUTER;
    /** @notice Interchain Security Module address for destination chain (currently Arbitrum Sepolia) */
    address public DESTINATION_CHAIN_ISM = ARB_SEPOLIA_ISM;

    /** @notice Current chain ID for the deployment */
    uint256 public currentChainId = 421614;

    /**
     * @notice Sets up the deployment environment by creating a fork of the target chain
     * @dev Currently configured for Arbitrum Sepolia testnet. Can be modified for other chains
     * by uncommenting the appropriate vm.createSelectFork line
     */
    function setUp() public {
        // source chain
        // vm.createSelectFork(vm.rpcUrl("etherlink_testnet"));

        // destination chain
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
    }

    /**
     * @notice Main function that enrolls remote routers and ISMs for cross-chain communication
     * @dev This function handles the bidirectional enrollment process:
     * - If on Etherlink testnet: Enrolls the destination chain's router and ISM
     * - If on destination chain: Enrolls Etherlink testnet's router and ISM
     * 
     * The enrollment process is essential for establishing secure cross-chain communication
     * channels in the Hyperlane protocol. Both chains must be enrolled for complete functionality.
     * 
     * The function uses the IAccountRouter interface to call the enrollRemoteRouterAndIsm
     * function with the appropriate parameters for each chain.
     */
    function run() public payable {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        if (block.chainid == ETHERLINK_TESTNET_DOMAIN) {
            IAccountRouter(ETHERLINK_TESTNET_ACCOUNT_ROUTER).enrollRemoteRouterAndIsm(
                uint32(DESTINATION_CHAIN_DOMAIN),
                bytes32(uint256(uint160(DESTINATION_CHAIN_ACCOUNT_ROUTER))),
                bytes32(uint256(uint160(DESTINATION_CHAIN_ISM)))
            );
            console.log("Enrolled remote router and ism are successfully on source chain:", block.chainid);
        } else if (block.chainid == DESTINATION_CHAIN_DOMAIN) {
            IAccountRouter(DESTINATION_CHAIN_ACCOUNT_ROUTER).enrollRemoteRouterAndIsm(
                uint32(ETHERLINK_TESTNET_DOMAIN),
                bytes32(uint256(uint160(ETHERLINK_TESTNET_ACCOUNT_ROUTER))),
                bytes32(uint256(uint160(ETHERLINK_TESTNET_ISM)))
            );
            console.log("Enrolled remote router and ism are successfully on destination chain:", block.chainid);
        }
        vm.stopBroadcast();
    }

    // RUN and verify
    // forge script ShortcutPairBridgeScript --verify --broadcast -vvv
    // forge script ShortcutPairBridgeScript --broadcast -vvv
}

// Warp Route config is valid, writing to file undefined:

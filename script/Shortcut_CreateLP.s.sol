// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

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
    function unenrollRemoteRouterAndIsm(uint32 _destinationDomain) external;
}

/**
 * @title ShortcutEnrollRemoteISM
 * @author Ibran Team
 * @notice Script for enrolling remote routers and ISMs between Base Sepolia and Etherlink testnet
 * @dev This script handles the enrollment of remote routers and ISMs (Interchain Security Modules)
 * between Base Sepolia (Chain ID: 84532) and Etherlink testnet (Chain ID: 128123) to enable
 * secure cross-chain communication in the Hyperlane protocol.
 * 
 * The enrollment process is bidirectional, requiring execution on both chains to establish
 * a complete cross-chain communication channel. The script automatically detects the current
 * chain and performs the appropriate enrollment.
 * 
 * @custom:security This script should only be run by authorized deployers with proper
 * chain configuration
 */
contract ShortcutEnrollRemoteISM is Script {
    // ============ BASE SEPOLIA CONFIGURATION ============
    /** @notice Account router address on Base Sepolia */
    address public baseSepoliaAccountRouter = 0x677a021bdf36a7409D02A974cb6E19EE4c2F0632;
    /** @notice Interchain Security Module address on Base Sepolia */
    address public baseSepoliaIsm = 0x924fF8657070da8e038F0B5867e09aFd7c46D1A9;

    // ============ ETHERLINK TESTNET CONFIGURATION ============
    /** @notice Account router address on Etherlink testnet */
    address public etherlinkTestnetAccountRouter = 0xC4c34aFF9f5dE4D9623349ce8EAc8589cE796fD7;
    /** @notice Interchain Security Module address on Etherlink testnet */
    address public etherlinkTestnetIsm = 0x8fe413C32a6A481f5926460E45d04D07d9Be2700;

    /**
     * @notice Sets up the deployment environment by creating a fork of the target chain
     * @dev Currently configured for Base Sepolia testnet. Can be modified for other chains
     * by uncommenting the appropriate vm.createSelectFork line
     */
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("etherlink_testnet"));
    }

    /**
     * @notice Main function that enrolls remote routers and ISMs for cross-chain communication
     * @dev This function handles the bidirectional enrollment process:
     * - If on Etherlink testnet (Chain ID: 128123): Enrolls Base Sepolia's router and ISM
     * - If on Base Sepolia (Chain ID: 84532): Enrolls Etherlink testnet's router and ISM
     * 
     * The enrollment process is essential for establishing secure cross-chain communication
     * channels in the Hyperlane protocol. Both chains must be enrolled for complete functionality.
     * 
     * The function uses the IAccountRouter interface to call the enrollRemoteRouterAndIsm
     * function with the appropriate parameters for each chain.
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        if (block.chainid == 128123) {
            IAccountRouter(etherlinkTestnetAccountRouter).enrollRemoteRouterAndIsm(
                uint32(84532),
                bytes32(uint256(uint160(baseSepoliaAccountRouter))),
                bytes32(uint256(uint160(baseSepoliaIsm)))
            );
        } else if (block.chainid == 84532) {
            IAccountRouter(baseSepoliaAccountRouter).enrollRemoteRouterAndIsm(
                uint32(128123),
                bytes32(uint256(uint160(etherlinkTestnetAccountRouter))),
                bytes32(uint256(uint160(etherlinkTestnetIsm)))
            );
        }

        vm.stopBroadcast();
    }

    // RUN
    // forge script ShortcutEnrollRemoteISM --broadcast -vvv
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {HelperTestnet} from "../src/HelperTestnet.sol";
import {IbranBridgeTokenReceiver} from "../src/IbranBridgeTokenReceiver.sol";
import {IbranBridgeTokenSender} from "../src/IbranBridgeTokenSender.sol";
import {MockWBTC} from "../src/mocks/MockWBTC.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {MockUSDC} from "../src/mocks/MockUSDC.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";
import {MockWXTZ} from "../src/mocks/MockWXTZ.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title DeployTokenNewChainScript
 * @author Ibran Team
 * @notice Deployment script for deploying mock tokens and bridge receivers on a new destination chain
 * @dev This script is used to deploy the complete token infrastructure on a new chain that will
 * serve as a destination for cross-chain lending operations. It deploys:
 * - HelperTestnet contract for chain management
 * - Mock tokens (USDC, USDT, WXTZ, WBTC, WETH)
 * - Bridge token receivers for each token
 * 
 * The script outputs the deployed addresses in both Solidity and JavaScript formats
 * for easy integration with other deployment scripts.
 * 
 * @custom:security This script should only be run by authorized deployers on testnet chains
 */
contract DeployTokenNewChainScript is Script, Helper {
    // Core infrastructure contracts
    HelperTestnet public helperTestnet;
    IbranBridgeTokenReceiver public ibranBridgeTokenReceiver;
    IbranBridgeTokenSender public ibranBridgeTokenSender;
    
    // Mock token contracts
    MockUSDC public mockUSDC;
    MockUSDT public mockUSDT;
    MockWXTZ public mockWXTZ;
    MockWBTC public mockWBTC;
    MockWETH public mockWETH;

    /**
     * @notice Sets up the deployment environment by creating a fork of the target chain
     * @dev Currently configured for Arbitrum Sepolia testnet. Can be modified for other chains
     * by uncommenting the appropriate vm.createSelectFork line
     */
    function setUp() public {
        // host chain (etherlink)
        // vm.createSelectFork(vm.rpcUrl("etherlink_testnet"));
        // receiver chain
        vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    /**
     * @notice Main deployment function that deploys all token infrastructure on the destination chain
     * @dev This function deploys the complete token ecosystem including:
     * 1. HelperTestnet contract for chain management
     * 2. Mock tokens (USDC, USDT, WXTZ, WBTC, WETH)
     * 3. Bridge token receivers for each token
     * 
     * The function outputs all deployed addresses in both Solidity and JavaScript formats
     * for easy copying into other deployment scripts.
     * 
     * The deployment process follows this sequence:
     * 1. Deploy HelperTestnet
     * 2. Deploy each mock token with HelperTestnet as parameter
     * 3. Deploy bridge token receiver for each token
     * 4. Output addresses in multiple formats
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        
        // Deploy HelperTestnet contract
        helperTestnet = new HelperTestnet();
        
        // Deploy USDC infrastructure
        mockUSDC = new MockUSDC(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDC));
        console.log("address public UsdcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        
        // Deploy USDT infrastructure
        mockUSDT = new MockUSDT(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDT));
        console.log("address public UsdtBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        
        // Deploy WXTZ infrastructure
        mockWXTZ = new MockWXTZ(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWXTZ));
        console.log("address public WXTZBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        
        // Deploy WBTC infrastructure
        mockWBTC = new MockWBTC(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWBTC));
        console.log("address public BtcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        
        // Deploy WETH infrastructure
        mockWETH = new MockWETH(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWETH));
        console.log("address public EthBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");

        // Output Solidity format addresses
        console.log("************ COPY DESTINATION ADDRESS **************");
        console.log("address public DESTINATION_helperTestnet = ", address(helperTestnet), ";");
        console.log("address public DESTINATION_mockUSDC = ", address(mockUSDC), ";");
        console.log("address public DESTINATION_mockUSDT = ", address(mockUSDT), ";");
        console.log("address public DESTINATION_mockWXTZ = ", address(mockWXTZ), ";");
        console.log("address public DESTINATION_mockWBTC = ", address(mockWBTC), ";");
        console.log("address public DESTINATION_mockWETH = ", address(mockWETH), ";");
        
        // Output JavaScript format addresses
        console.log("************ COPY DESTINATION ADDRESS **************");
        console.log("export const DESTINATION_helperTestnet = ", address(helperTestnet), ";");
        console.log("export const DESTINATION_mockWETH = ", address(mockWETH), ";");
        console.log("export const DESTINATION_mockUSDC = ", address(mockUSDC), ";");
        console.log("export const DESTINATION_mockUSDT = ", address(mockUSDT), ";");
        console.log("export const DESTINATION_mockWXTZ = ", address(mockWXTZ), ";");
        console.log("export const DESTINATION_mockWBTC = ", address(mockWBTC), ";");
        
        vm.stopBroadcast();
    }

    // RUN
    // forge script DeployTokenNewChainScript --verify --broadcast -vvv
}

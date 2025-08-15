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
import {MockWCORE} from "../src/mocks/MockWCORE.sol";

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
 * @dev Script for deploying tokens and bridge components on new chains
 * @notice This contract handles the deployment of mock tokens and bridge receivers on destination chains
 * @author Ibran Team
 */
contract DeployTokenNewChainScript is Script, Helper {
    HelperTestnet public helperTestnet;
    IbranBridgeTokenReceiver public ibranBridgeTokenReceiver;
    IbranBridgeTokenSender public ibranBridgeTokenSender;
    MockUSDC public mockUSDC;
    MockUSDT public mockUSDT;
    MockWCORE public mockWCORE;
    MockWBTC public mockWBTC;
    MockWETH public mockWETH;

    /**
     * @dev Sets up the deployment environment by creating a fork of the target network
     * @notice This function initializes the blockchain environment for deployment
     */
    function setUp() public {
        // host chain (etherlink)
        // vm.createSelectFork(vm.rpcUrl("etherlink_testnet"));
        // receiver chain
        vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    /**
     * @dev Main function to deploy tokens and bridge components on new chains
     * @notice This function deploys helper testnet, mock tokens, and bridge token receivers
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        helperTestnet = new HelperTestnet();
        mockUSDC = new MockUSDC(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDC));
        console.log("address public UsdcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        mockUSDT = new MockUSDT(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDT));
        console.log("address public UsdtBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        mockWCORE = new MockWCORE(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWCORE));
        console.log("address public WCOREBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        mockWBTC = new MockWBTC(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWBTC));
        console.log("address public BtcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        mockWETH = new MockWETH(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWETH));
        console.log("address public EthBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");

        // **************** SOLIDITY ****************
        console.log("************ COPY DESTINATION ADDRESS **************");
        console.log("address public DESTINATION_helperTestnet = ", address(helperTestnet), ";");
        console.log("address public DESTINATION_mockUSDC = ", address(mockUSDC), ";");
        console.log("address public DESTINATION_mockUSDT = ", address(mockUSDT), ";");
        console.log("address public DESTINATION_mockWCORE = ", address(mockWCORE), ";");
        console.log("address public DESTINATION_mockWBTC = ", address(mockWBTC), ";");
        console.log("address public DESTINATION_mockWETH = ", address(mockWETH), ";");
        // **************** JAVASCRIPT ****************
        console.log("************ COPY DESTINATION ADDRESS **************");
        console.log("export const DESTINATION_helperTestnet = ", address(helperTestnet), ";");
        console.log("export const DESTINATION_mockWETH = ", address(mockWETH), ";");
        console.log("export const DESTINATION_mockUSDC = ", address(mockUSDC), ";");
        console.log("export const DESTINATION_mockUSDT = ", address(mockUSDT), ";");
        console.log("export const DESTINATION_mockWCORE = ", address(mockWCORE), ";");
        console.log("export const DESTINATION_mockWBTC = ", address(mockWBTC), ";");
        vm.stopBroadcast();
    }

    // RUN
    // forge script DeployTokenNewChainScript --verify --broadcast -vvv
}

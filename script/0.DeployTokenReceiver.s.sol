// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {IbranBridgeTokenReceiver} from "../src/IbranBridgeTokenReceiver.sol";
import {MockUSDC} from "../src/mocks/MockUSDC.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";
import {MockWBTC} from "../src/mocks/MockWBTC.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {HelperTestnet} from "../src/HelperTestnet.sol";

contract DeployTokenReceiver is Script, Helper {
    MockUSDC public mockUSDC;
    MockUSDT public mockUSDT;
    MockWBTC public mockWBTC;
    MockWETH public mockWETH;
    HelperTestnet public helperTestnet;
    IbranBridgeTokenReceiver public ibranBridgeTokenReceiver;

    // deploy all chain
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("op_sepolia"));
    }

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
        mockWBTC = new MockWBTC(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWBTC));
        console.log("address public BtcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
        mockWETH = new MockWETH(address(helperTestnet));
        ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWETH));
        console.log("address public EthBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");

        console.log("address public MOCK_USDC = ", address(mockUSDC), ";");
        console.log("address public MOCK_USDT = ", address(mockUSDT), ";");
        console.log("address public MOCK_WBTC = ", address(mockWBTC), ";");
        console.log("address public MOCK_WETH = ", address(mockWETH), ";");

        vm.stopBroadcast();
    }
}

// RUN
// forge script DeployTokenReceiver --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY

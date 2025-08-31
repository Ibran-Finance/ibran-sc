// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {IbranBridgeTokenSender} from "../src/IbranBridgeTokenSender.sol";
import {ITokenSwap} from "../src/interfaces/ITokenSwap.sol";

contract PairBridgeToken is Script, Helper {
    IbranBridgeTokenSender public ibranBridgeTokenSender;
    uint256 destinationChainId = 11155420;

    // only source chain
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        if (destinationChainId == 0) revert("destinationChainId is not set");

        if (UsdcBridgeTokenReceiver == address(0)) revert("UsdcBridgeTokenReceiver is not set");

        ibranBridgeTokenSender = new IbranBridgeTokenSender(
            DEPLOYED_helperTestnet,
            MOCK_USDC,
            UsdcBridgeTokenReceiver, // ** otherchain ** RECEIVER BRIDGE
            destinationChainId // ** otherchain ** CHAIN ID
        );
        console.log("address public MOCK_USDC_SENDER = ", address(ibranBridgeTokenSender), ";");
        ITokenSwap(MOCK_USDC).addBridgeTokenSender(address(ibranBridgeTokenSender));

        if (UsdtBridgeTokenReceiver == address(0)) revert("UsdtBridgeTokenReceiver is not set");
        ibranBridgeTokenSender = new IbranBridgeTokenSender(
            DEPLOYED_helperTestnet,
            MOCK_USDT,
            UsdtBridgeTokenReceiver, // ** otherchain ** RECEIVER BRIDGE
            destinationChainId // ** otherchain ** CHAIN ID
        );
        console.log("address public MOCK_USDT_SENDER = ", address(ibranBridgeTokenSender), ";");
        ITokenSwap(MOCK_USDT).addBridgeTokenSender(address(ibranBridgeTokenSender));

        if (BtcBridgeTokenReceiver == address(0)) revert("BtcBridgeTokenReceiver is not set");
        ibranBridgeTokenSender = new IbranBridgeTokenSender(
            DEPLOYED_helperTestnet,
            MOCK_WBTC,
            BtcBridgeTokenReceiver, // ** otherchain ** RECEIVER BRIDGE
            destinationChainId // ** otherchain ** CHAIN ID
        );
        console.log("address public MOCK_WBTC_SENDER = ", address(ibranBridgeTokenSender), ";");
        ITokenSwap(MOCK_WBTC).addBridgeTokenSender(address(ibranBridgeTokenSender));

        if (EthBridgeTokenReceiver == address(0)) revert("EthBridgeTokenReceiver is not set");
        ibranBridgeTokenSender = new IbranBridgeTokenSender(
            DEPLOYED_helperTestnet,
            MOCK_WETH,
            EthBridgeTokenReceiver, // ** otherchain ** RECEIVER BRIDGE
            destinationChainId // ** otherchain ** CHAIN ID
        );
        console.log("address public MOCK_WETH_SENDER = ", address(ibranBridgeTokenSender), ";");
        ITokenSwap(MOCK_WETH).addBridgeTokenSender(address(ibranBridgeTokenSender));
        vm.stopBroadcast();
    }
}
// RUN
// forge script PairBridgeToken --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY

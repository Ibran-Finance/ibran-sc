// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {HelperUtils} from "../src/HelperUtils.sol";

contract ShortcutGetExchangeRate is Script, Helper {
    HelperUtils public helperUtils;
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        uint256 exchangeRate = HelperUtils(BASE_helperUtils).getExchangeRate(address(MOCK_WETH), address(MOCK_USDT), 1e18, BASE_position);
        console.log("exchangeRate", exchangeRate);
        vm.stopBroadcast();
    }

    // RUN
    // forge script ShortcutGetExchangeRate --broadcast -vvv 
}
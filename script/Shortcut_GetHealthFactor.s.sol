// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {HelperUtils} from "../src/HelperUtils.sol";
import {LendingPool} from "../src/LendingPool.sol";

contract ShortcutGetHealthFactor is Script, Helper {
    
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        // address addressPosition = LendingPool(BASE_lendingPool).addressPositions(vm.envAddress("ADDRESS"));
        uint256 healthFactor = HelperUtils(BASE_helperUtils).getHealthFactor(BASE_lendingPool, vm.envAddress("ADDRESS"));
        console.log("healthFactor", healthFactor/1e8);
        vm.stopBroadcast();
    }
}

// RUN
// forge script ShortcutGetHealthFactor --broadcast -vvv 
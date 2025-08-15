// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

interface IApi3ReaderProxy {
    function read() external view returns (int224 value, uint32 timestamp);
}

contract ShortcutAPI3 is Script {
    address public ethUsd = 0x6c75b16496384caE307f7E842e7133590E6D79Af;
    address public btcUsd = 0x121296103189009d9D082943bE723387A6c7D30C;
    address public coreUsd = 0x1C17f47A297Ed0cCb0dD566eD79C65DA0EE69566;

    function setUp() public {
        // host chain (etherlink)
        vm.createSelectFork(vm.rpcUrl("core_testnet"));
        // receiver chain
        // vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        (int224 value, uint32 timestamp) = IApi3ReaderProxy(ethUsd).read();
        console.log("ethUsd value", value);
        console.log("ethUsd timestamp", timestamp);
        vm.stopBroadcast();
    }

    // RUN
    // forge script ShortcutAPI3 --broadcast -vvv
    // 4755.306538461537500000
}

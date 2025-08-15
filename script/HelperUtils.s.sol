// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "../src/HelperUtils.sol";

contract HelperUtilsScript is Script {
    HelperUtils public helperUtils;
    address public factory = 0x92b3f4D2312a108998a8E0fF91B90e6aB7AC97bE;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("core_testnet"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        helperUtils = new HelperUtils(factory);

        vm.stopBroadcast();

        console.log("helperUtils", address(helperUtils));
    }

    // RUN
    // forge script HelperUtilsScript --verify --broadcast -vvv --with-gas-price 10000000000 --priority-gas-price 1000000000

//     forge verify-contract \
//   --rpc-url https://node.ghostnet.etherlink.com \
//   --verifier blockscout \
//   --verifier-url 'https://testnet.explorer.etherlink.com/api/' \
//   0x1788042Ef20a790c27758255159D7E815A755320 \
//   src/hyperlane/HelperUtils.sol:HelperUtils
}

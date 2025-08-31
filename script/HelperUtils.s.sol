// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "../src/HelperUtils.sol";

contract HelperUtilsScript is Script {
    HelperUtils public helperUtils;
    address public factory = 0x31c3850D2cBDC5B084D632d1c61d54161790bFF8;

    function setUp() public {
        // vm.createSelectFork(vm.rpcUrl("core_testnet"));
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
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
    // forge script HelperUtilsScript --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY

//     forge verify-contract \
//   --rpc-url https://node.ghostnet.etherlink.com \
//   --verifier blockscout \
//   --verifier-url 'https://testnet.explorer.etherlink.com/api/' \
//   0x1788042Ef20a790c27758255159D7E815A755320 \
//   src/hyperlane/HelperUtils.sol:HelperUtils
}

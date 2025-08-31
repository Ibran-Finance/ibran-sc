// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {ITokenSwap} from "../src/interfaces/ITokenSwap.sol";
import {Oracle} from "../src/Oracle.sol";
import {console} from "forge-std/console.sol";
import {LendingPoolFactory} from "../src/LendingPoolFactory.sol";

contract ShortcutSetTokenDataStream is Script, Helper {
    Oracle public oracle;
    LendingPoolFactory public lendingPoolFactory;
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        lendingPoolFactory = LendingPoolFactory(BASE_lendingPoolFactory);
        oracle = new Oracle(UsdcUsd);
        lendingPoolFactory.addTokenDataStream(address(MOCK_USDC), address(oracle));
        console.log("address public oracleUsdcUsd = ", address(oracle), ";");
        oracle = new Oracle(UsdtUsd);
        lendingPoolFactory.addTokenDataStream(address(MOCK_USDT), address(oracle));
        console.log("address public oracleUsdtUsd = ", address(oracle), ";");
        oracle = new Oracle(EthUsd);
        lendingPoolFactory.addTokenDataStream(address(MOCK_WETH), address(oracle));
        console.log("address public oracleEthUsd = ", address(oracle), ";");
        oracle = new Oracle(BtcUsd);
        lendingPoolFactory.addTokenDataStream(address(MOCK_WBTC), address(oracle));
        console.log("address public oracleBtcUsd = ", address(oracle), ";");
        vm.stopBroadcast();
    }
}

// RUN
// forge script ShortcutSetTokenDataStream --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY

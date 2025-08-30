// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {Helper} from "./Helper.sol";
import {Protocol} from "../src/Protocol.sol";
import {IsHealthy} from "../src/IsHealthy.sol";
import {LendingPoolDeployer} from "../src/LendingPoolDeployer.sol";
import {HelperTestnet} from "../src/HelperTestnet.sol";
import {Oracle} from "../src/Oracle.sol";
import {LendingPoolFactory} from "../src/LendingPoolFactory.sol";
import {LendingPool} from "../src/LendingPool.sol";
import {Position} from "../src/Position.sol";

contract DeployUtilities is Script, Helper {
    Protocol public protocol;
    IsHealthy public isHealthy;
    LendingPoolDeployer public lendingPoolDeployer;
    HelperTestnet public helperTestnet;
    LendingPoolFactory public lendingPoolFactory;
    LendingPool public lendingPool;
    Position public position;
    Oracle public oracle;

    // only source chain
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        protocol = new Protocol();
        console.log("address public protocol = ", address(protocol), ";");
        isHealthy = new IsHealthy();
        console.log("address public isHealthy = ", address(isHealthy), ";");
        lendingPoolDeployer = new LendingPoolDeployer();
        console.log("address public lendingPoolDeployer = ", address(lendingPoolDeployer), ";");
        lendingPoolFactory = new LendingPoolFactory(
            address(isHealthy), address(lendingPoolDeployer), address(protocol), address(DEPLOYED_helperTestnet)
        );
        console.log("address public lendingPoolFactory = ", address(lendingPoolFactory), ";");
        lendingPool = new LendingPool(address(MOCK_WETH), address(MOCK_USDC), address(lendingPoolFactory), 7e17);
        console.log("address public lendingPool = ", address(lendingPool), ";");
        position =
            new Position(address(MOCK_WETH), address(MOCK_USDC), address(lendingPool), address(lendingPoolFactory));
        console.log("address public position = ", address(position), ";");

        lendingPoolDeployer.setFactory(address(lendingPoolFactory));

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
// forge script DeployUtilities --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY

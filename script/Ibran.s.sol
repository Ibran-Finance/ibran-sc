// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MockUSDC} from "../src/mocks/MockUSDC.sol";
import {MockUSDT} from "../src/mocks/MockUSDT.sol";
// import {MockWCORE} from "../src/mocks/MockWCORE.sol";
import {HelperTestnet} from "../src/HelperTestnet.sol";
import {IbranBridgeTokenSender} from "../src/IbranBridgeTokenSender.sol";
import {IbranBridgeTokenReceiver} from "../src/IbranBridgeTokenReceiver.sol";
import {MockWBTC} from "../src/mocks/MockWBTC.sol";
import {MockWETH} from "../src/mocks/MockWETH.sol";
import {ITokenSwap} from "../src/interfaces/ITokenSwap.sol";
import {Protocol} from "../src/Protocol.sol";
import {IsHealthy} from "../src/IsHealthy.sol";
import {LendingPoolDeployer} from "../src/LendingPoolDeployer.sol";
import {LendingPoolFactory} from "../src/LendingPoolFactory.sol";
import {LendingPool} from "../src/LendingPool.sol";
import {Position} from "../src/Position.sol";
// import {Pricefeed} from "../src/Pricefeed.sol";
import {Oracle} from "../src/Oracle.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title IbranScript
 * @dev Main deployment script for the Ibran protocol
 * @notice This contract handles the deployment and configuration of all Ibran protocol components
 * @author Ibran Team
 */
contract IbranScript is Script {
    HelperTestnet public helperTestnet;
    IbranBridgeTokenReceiver public ibranBridgeTokenReceiver;
    IbranBridgeTokenSender public ibranBridgeTokenSender;
    MockUSDC public mockUSDC;
    MockUSDT public mockUSDT;
    // // MockWCORE public mockWCORE;
    MockWBTC public mockWBTC;
    MockWETH public mockWETH;

    Protocol public protocol;
    IsHealthy public isHealthy;
    LendingPoolDeployer public lendingPoolDeployer;
    LendingPoolFactory public lendingPoolFactory;
    LendingPool public lendingPool;
    Position public position;
    // Pricefeed public pricefeed;
    Oracle public oracle;
    // ****************************************************************************
    //************** DEPLOYED TOKEN ************** (ORIGIN CHAIN)
    address public ORIGIN_helperTestnet = 0x891Af21A126035E84d5344825CbC8Ef6fa3d0851;
    address public ORIGIN_mockUSDC = 0x2439759843B84300813cB354D045bF8Ee700536d;
    address public ORIGIN_mockUSDT = 0x666ca8639f5d28943c0B4769Df7d918AF538041E;
    address public ORIGIN_mockWBTC = 0x356f0e9af99906FdAdFcF13125047353933188F5;
    address public ORIGIN_mockWETH = 0x57F0b106BD8779B7Ff721126e01fD757D48d265E;

    //************** Price feed ************** (ORIGIN CHAIN)
    address public EthUsd = 0x6c75b16496384caE307f7E842e7133590E6D79Af;
    address public BtcUsd = 0x121296103189009d9D082943bE723387A6c7D30C;
    address public UsdtUsd = 0x3ec8593F930EA45ea58c968260e6e9FF53FC934f;
    address public UsdcUsd = 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165;
    // address public CoreUsd = 0x1C17f47A297Ed0cCb0dD566eD79C65DA0EE69566;
    // ****************************************************************************

    uint32 public ORIGIN_chainId = 84532;

    //************** Receiver chain **************
    //************** Base Sepolia **************
    // address public UsdcBridgeTokenReceiver =  0xD16dd67DD0B131626fF5d06A00F9D31C8196b5Fc ;
    // address public UsdtBridgeTokenReceiver =  0x0aD1563Af384090361d91163490b55013D2D9929 ;
    // address public BtcBridgeTokenReceiver =  0xe2E96b56A73Bc53521e1449573D47129f6a7382A ;
    // address public EthBridgeTokenReceiver =  0xdDA7c8Fd4767a6b429Dbe4Eb1728D2b16ddB99Da ;

    // address public DESTINATION_helperTestnet = 0xbFc5D78E1B69F6f194C5822Ad55CFD1ae0fF796c;
    // address public DESTINATION_mockUSDC = 0xf5c7624c3054C5F093EfE22BdA58eFbe120a4B43;
    // address public DESTINATION_mockUSDT = 0x05e78872ab0AFb3b89022Bc3a729447B19E8121a;
    // address public DESTINATION_mockWCORE = 0xa8F162af976b55cACE08F4D7088aa69B6fcb3bF6;
    // address public DESTINATION_mockWBTC = 0x40A8146cA211fb65014f3d3DFbe3F4FD0b20e86b;
    // address public DESTINATION_mockWETH = 0x8fe413C32a6A481f5926460E45d04D07d9Be2700;
    // ****************************************************************************
    //************** Arbitrum Sepolia **************
    address public UsdcBridgeTokenReceiver = 0x8c9Ec6Bc7b82cD3475A5CbcC53811E3b41702F77;
    address public UsdtBridgeTokenReceiver = 0x28a6b8F44C7dD36977DACEEB4651a31455978D81;
    address public BtcBridgeTokenReceiver = 0xCB22Ef0448CB0a6286FCF0158b8CA3fDC0d5c818;
    address public EthBridgeTokenReceiver = 0x056d833Aa56687FFfF98247813c7c02206E4E69F;

    address public DESTINATION_helperTestnet = 0xc08979873dC84c018D451E9450F750887B4aD74f;
    address public DESTINATION_mockUSDC = 0xc46C21ab15a6F1009168490219dBE10B68067E4B;
    address public DESTINATION_mockUSDT = 0x58DC0146D7B3BF45692c9eD47C7ca39FAE0877bC;
    address public DESTINATION_mockWBTC = 0x52435F547961766a75DDfc6Dae5b6E1a54ca04a0;
    address public DESTINATION_mockWETH = 0x9163B0A3BD71073e860b16b78Bb976987f773E6E;
    // ****************************************************************************

    // ****************************************************************************
    // ********** FILL THIS
    bool public isDeployed = true;
    // uint32 public DESTINATION_chainId = 84532;
    uint32 public DESTINATION_chainId = 421614;

    /**
     * @dev Sets up the deployment environment by creating a fork of the target network
     * @notice This function initializes the blockchain environment for deployment
     */
    function setUp() public {
        // host chain (etherlink)
        // vm.createSelectFork(vm.rpcUrl("core_testnet"));
        // receiver chain
        // vm.createSelectFork(vm.rpcUrl("arb_sepolia"));
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    /**
     * @dev Main deployment function that handles the deployment of all protocol components
     * @notice This function deploys tokens, bridge contracts, and protocol components based on the target chain
     */
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        if (block.chainid == DESTINATION_chainId) {
            // ** RECEIVER AND TOKEN
            helperTestnet = new HelperTestnet();
            mockUSDC = new MockUSDC(address(helperTestnet));
            ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDC));
            console.log("address public UsdcBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
            mockUSDT = new MockUSDT(address(helperTestnet));
            ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockUSDT));
            console.log("address public UsdtBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
            // // mockWCORE = new MockWCORE(address(helperTestnet));
            // ibranBridgeTokenReceiver = new IbranBridgeTokenReceiver(address(helperTestnet), address(mockWCORE));
            // console.log("address public WCOREBridgeTokenReceiver = ", address(ibranBridgeTokenReceiver), ";");
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
            // // console.log("address public DESTINATION_mockWCORE = ", address(mockWCORE), ";");
            console.log("address public DESTINATION_mockWBTC = ", address(mockWBTC), ";");
            console.log("address public DESTINATION_mockWETH = ", address(mockWETH), ";");
            // **************** JAVASCRIPT ****************
            console.log("************ COPY DESTINATION ADDRESS **************");
            console.log("export const DESTINATION_helperTestnet = ", address(helperTestnet), ";");
            console.log("export const DESTINATION_mockUSDC = ", address(mockUSDC), ";");
            console.log("export const DESTINATION_mockUSDT = ", address(mockUSDT), ";");
            // // console.log("export const DESTINATION_mockWCORE = ", address(mockWCORE), ";");
            console.log("export const DESTINATION_mockWBTC = ", address(mockWBTC), ";");
            console.log("export const DESTINATION_mockWETH = ", address(mockWETH), ";");
            // *************************************************
        } else if (block.chainid == ORIGIN_chainId && !isDeployed) {
            // **************** DEPLOY PROTOCOL ******************
            protocol = new Protocol();
            isHealthy = new IsHealthy();
            lendingPoolDeployer = new LendingPoolDeployer();
            helperTestnet = new HelperTestnet();
            // *************************************************

            // **************** DEPLOY TOKEN ******************
            deployMockToken();
            // *************************************************

            // **************** CORE CONTRACT ******************
            lendingPoolFactory = new LendingPoolFactory(
                address(isHealthy), address(lendingPoolDeployer), address(protocol), address(helperTestnet)
            );
            lendingPool = new LendingPool(address(mockWETH), address(mockUSDC), address(lendingPoolFactory), 7e17);
            position =
                new Position(address(mockWETH), address(mockUSDC), address(lendingPool), address(lendingPoolFactory));
            lendingPoolDeployer.setFactory(address(lendingPoolFactory));
            // *************************************************

            // **************** PRICE FEED ******************
            oracle = new Oracle(UsdcUsd);
            lendingPoolFactory.addTokenDataStream(address(mockUSDC), address(oracle));

            oracle = new Oracle(UsdtUsd);
            lendingPoolFactory.addTokenDataStream(address(mockUSDT), address(oracle));

            oracle = new Oracle(EthUsd);
            lendingPoolFactory.addTokenDataStream(address(mockWETH), address(oracle));

            oracle = new Oracle(BtcUsd);
            lendingPoolFactory.addTokenDataStream(address(mockWBTC), address(oracle));

            // oracle = new Oracle(CoreUsd);
            // lendingPoolFactory.addTokenDataStream(address(mockWCORE), address(oracle));
            // *************************************************

            // **************** SOLIDITY ****************
            console.log("************ COPY ORIGIN ADDRESS **************");
            console.log("address public protocol = ", address(protocol), ";");
            console.log("address public isHealthy = ", address(isHealthy), ";");
            console.log("address public lendingPoolDeployer = ", address(lendingPoolDeployer), ";");
            console.log("address public helperTestnet = ", address(helperTestnet), ";");
            console.log("address public lendingPoolFactory = ", address(lendingPoolFactory), ";");
            console.log("address public lendingPool = ", address(lendingPool), ";");
            console.log("address public position = ", address(position), ";");
            console.log("address public oracleEthUsd = ", address(EthUsd), ";");
            console.log("address public oracleBtcUsd = ", address(BtcUsd), ";");
            console.log("address public oracleUsdcUsd = ", address(UsdcUsd), ";");
            console.log("address public oracleUsdtUsd = ", address(UsdtUsd), ";");
            // **************** JAVASCRIPT ****************
            console.log("************ COPY ORIGIN ADDRESS **************");
            console.log("export const protocol = ", address(protocol), ";");
            console.log("export const isHealthy = ", address(isHealthy), ";");
            console.log("export const lendingPoolDeployer = ", address(lendingPoolDeployer), ";");
            console.log("export const helperTestnet = ", address(helperTestnet), ";");
            console.log("export const lendingPoolFactory = ", address(lendingPoolFactory), ";");
            console.log("export const lendingPool = ", address(lendingPool), ";");
            console.log("export const position = ", address(position), ";");
            console.log("export const oracleEthUsd = ", address(EthUsd), ";");
            console.log("export const oracleBtcUsd = ", address(BtcUsd), ";");
            console.log("export const oracleUsdcUsd = ", address(UsdcUsd), ";");
            console.log("export const oracleUsdtUsd = ", address(UsdtUsd), ";");
        } else if (block.chainid == ORIGIN_chainId && isDeployed) {
            ///* 1.DEPLOY HYPERLANE TO DESTINATION CHAIN
            ///* 2.DEPLOY RECEIVER
            if (DESTINATION_chainId == 84532) {
                revert("Deployed");
            }
            pairBridgeToToken(ORIGIN_helperTestnet, ORIGIN_mockUSDC, UsdcBridgeTokenReceiver, DESTINATION_chainId);
            pairBridgeToToken(ORIGIN_helperTestnet, ORIGIN_mockUSDT, UsdtBridgeTokenReceiver, DESTINATION_chainId);
            // // pairBridgeToToken(ORIGIN_helperTestnet, ORIGIN_mockWCORE, WCOREBridgeTokenReceiver, DESTINATION_chainId);
            pairBridgeToToken(ORIGIN_helperTestnet, ORIGIN_mockWBTC, BtcBridgeTokenReceiver, DESTINATION_chainId);
            pairBridgeToToken(ORIGIN_helperTestnet, ORIGIN_mockWETH, EthBridgeTokenReceiver, DESTINATION_chainId);
            ///* DONE
            ///**** ETHERLINK
            ///**** BASE
            ///**** ARBITRUM
        }

        vm.stopBroadcast();
    }

    /**
     * @dev Deploys mock tokens and pairs them with bridge token receivers
     * @notice This function creates mock tokens and establishes bridge connections
     */
    function deployMockToken() public {
        if (UsdcBridgeTokenReceiver == address(0)) revert("UsdcBridgeTokenReceiver is not set");
        mockUSDC = new MockUSDC(address(helperTestnet));
        pairBridgeToToken(address(helperTestnet), address(mockUSDC), UsdcBridgeTokenReceiver, DESTINATION_chainId);

        if (UsdtBridgeTokenReceiver == address(0)) revert("UsdtBridgeTokenReceiver is not set");
        mockUSDT = new MockUSDT(address(helperTestnet));
        pairBridgeToToken(address(helperTestnet), address(mockUSDT), UsdtBridgeTokenReceiver, DESTINATION_chainId);

        // // if (WCOREBridgeTokenReceiver == address(0)) revert("WCOREBridgeTokenReceiver is not set");
        // // mockWCORE = new MockWCORE(address(helperTestnet));
        // // pairBridgeToToken(address(helperTestnet), address(mockWCORE), WCOREBridgeTokenReceiver, DESTINATION_chainId);

        if (BtcBridgeTokenReceiver == address(0)) revert("BtcBridgeTokenReceiver is not set");
        mockWBTC = new MockWBTC(address(helperTestnet));
        pairBridgeToToken(address(helperTestnet), address(mockWBTC), BtcBridgeTokenReceiver, DESTINATION_chainId);

        if (EthBridgeTokenReceiver == address(0)) revert("EthBridgeTokenReceiver is not set");
        mockWETH = new MockWETH(address(helperTestnet));
        pairBridgeToToken(address(helperTestnet), address(mockWETH), EthBridgeTokenReceiver, DESTINATION_chainId);
        // **************** SOLIDITY ****************
        console.log("************ COPY ORIGIN ADDRESS **************");
        console.log("address public ORIGIN_helperTestnet = ", address(helperTestnet), ";");
        console.log("address public ORIGIN_mockUSDC = ", address(mockUSDC), ";");
        console.log("address public ORIGIN_mockUSDT = ", address(mockUSDT), ";");
        // // console.log("address public ORIGIN_mockWCORE = ", address(mockWCORE), ";");
        console.log("address public ORIGIN_mockWBTC = ", address(mockWBTC), ";");
        console.log("address public ORIGIN_mockWETH = ", address(mockWETH), ";");
        // **************** JAVASCRIPT ****************
        console.log("************ COPY ORIGIN ADDRESS **************");
        console.log("export const ORIGIN_helperTestnet = ", address(helperTestnet), ";");
        console.log("export const ORIGIN_mockUSDC = ", address(mockUSDC), ";");
        console.log("export const ORIGIN_mockUSDT = ", address(mockUSDT), ";");
        // // console.log("export const ORIGIN_mockWCORE = ", address(mockWCORE), ";");
        console.log("export const ORIGIN_mockWBTC = ", address(mockWBTC), ";");
        console.log("export const ORIGIN_mockWETH = ", address(mockWETH), ";");
    }

    /**
     * @dev Pairs a bridge token sender with a token and receiver
     * @param _helperTestnet Address of the helper testnet contract
     * @param _mockToken Address of the mock token to be bridged
     * @param _ibranBridgeTokenReceiver Address of the bridge token receiver on the destination chain
     * @param _chainId Chain ID of the destination chain
     * @notice This function creates a bridge token sender and adds it to the token's bridge system
     */
    function pairBridgeToToken(
        address _helperTestnet,
        address _mockToken,
        address _ibranBridgeTokenReceiver,
        uint32 _chainId
    ) public {
        ibranBridgeTokenSender = new IbranBridgeTokenSender(
            _helperTestnet,
            _mockToken,
            _ibranBridgeTokenReceiver, // ** otherchain ** RECEIVER BRIDGE
            _chainId // ** otherchain ** CHAIN ID
        );
        ITokenSwap(_mockToken).addBridgeTokenSender(address(ibranBridgeTokenSender));
    }

    // RUN
    // forge script IbranScript --broadcast -vvv --verify
    // forge script IbranScript --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
    // forge script IbranScript --verify --broadcast -vvv --with-gas-price 10000000000 --priority-gas-price 1000000000
    // forge verify-contract 0xb268f61c7dF38E14574fdC8b042f9Ad25ea0839A src/LendingPool.sol:LendingPool --verifier blockscout --verifier-url https://api.test2.btcs.network/api --etherscan-api-key 005d2ba2cee04671bb4fa9b2061959e5
}

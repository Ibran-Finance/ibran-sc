// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title Helper
 * @dev Helper contract containing addresses and configuration for the Ibran protocol
 * @notice This contract provides centralized address management for tokens, contracts, and chain configurations
 * @author Ibran Team
 */
contract Helper is Script {
    address public BASE_UsdcBridgeTokenReceiver = 0xEaD20Aecb4ccDc78f7a01Da82cF137E445948080;
    address public BASE_UsdtBridgeTokenReceiver = 0x34B081f1922919FC8D237127e07ab5C9d2ea27df;
    address public BASE_BtcBridgeTokenReceiver = 0x1bD54e7177eb1AbdaF1b2A552a20D51c0Ab603AD;
    address public BASE_EthBridgeTokenReceiver = 0xCC27fFB2A1dDF2a60063Bc8880a166d92cBb8EDD;

    address public BASE_ARB_MOCK_USDC_SENDER = 0x8bdD245899fF5fcaB4C413FAFb0aa20748DD2E48;
    address public BASE_ARB_MOCK_USDT_SENDER = 0x204f67926C8E32CDBEE3804d9eAAd1285E90F536;
    address public BASE_ARB_MOCK_WBTC_SENDER = 0xbF5d87C06d9928F7C26F8e2c4389Bc7C9aC87Da4;
    address public BASE_ARB_MOCK_WETH_SENDER = 0xA610d431d569fd19F725161c7F1C2C0c52Ad06F9;

    address public BASE_OP_MOCK_USDC_SENDER = 0xdaB78aCDEAbFdB3ac96ee95efA9336a190b9Dfe5;
    address public BASE_OP_MOCK_USDT_SENDER = 0xAeb1279d0BCa98819bb25D76e54d49c221AB5656;
    address public BASE_OP_MOCK_WBTC_SENDER = 0x326D971476D5ECa067Ca075075e0db66d011A072;
    address public BASE_OP_MOCK_WETH_SENDER = 0x4DB881b3f4C5e2Fa6e5ad01af5aB3fd942534b9A;

    address public MOCK_USDC = 0xDa11C806176678e4228C904ec27014267e128fb5;
    address public MOCK_USDT = 0xA391a85B3B8D9cC90555E848aF803BF97067aA81;
    address public MOCK_WBTC = 0x7CC19AdfCB73A81A6769dC1A9f7f9d429b27f000;
    address public MOCK_WETH = 0xB5155367af0Fab41d1279B059571715068dE263C;

    address public ARB_UsdcBridgeTokenReceiver = 0xdd9d2108B4014d804940A69c4060d314fDD12894;
    address public ARB_UsdtBridgeTokenReceiver = 0x9225628bb7c56f382E69B4f1dE9C54309A820582;
    address public ARB_BtcBridgeTokenReceiver = 0x212e6963DBf8AfE6043c2F8e671978d855cd73a6;
    address public ARB_EthBridgeTokenReceiver = 0x55D2E82C8d571D27B36fA3466ADb43Ea57254E3F;

    address public ARB_MOCK_USDC = 0x1e965B05CF6336c3162a5CA0Eb9f7a908f0Bb6a6;
    address public ARB_MOCK_USDT = 0x4c7432B98a68E09B14C2d13F5B9e7fa4e8F6Ee66;
    address public ARB_MOCK_WBTC = 0xdDc6E8700d1207Ea9347793Ba84914Ae34A37c6D;
    address public ARB_MOCK_WETH = 0x455Dd69cB8845354a240e68fc79508502024cf8D;

    address public OP_UsdcBridgeTokenReceiver = 0x4d14429334D78d808e9a1039f13F59713b772e12;
    address public OP_UsdtBridgeTokenReceiver = 0x948aaC248FEF678e34cC2d609dF4328B9DA6dC76;
    address public OP_BtcBridgeTokenReceiver = 0x468170e92311D432e69B03A52C613A3DBb371f1D;
    address public OP_EthBridgeTokenReceiver = 0xC9479F89fA8fcb9035A97e83B7Ae2A232f7560fc;

    address public OP_MOCK_USDC = 0xd60DC891520f85Eb55346A077390D32b747fd30c;
    address public OP_MOCK_USDT = 0x7f6486552841bE742FC396C8AB1fa9Cb20053983;
    address public OP_MOCK_WBTC = 0xAc8C44c09Cfd282EBdE45CDFc7fd213402c5e614;
    address public OP_MOCK_WETH = 0x4C1cA3C06ff0AFA986B68FF4C75b3357E6AB0D2A;

    address public BASE_protocol = 0x12D5C6Cdd764D661cce70F1BB1eE144b7ac6D664;
    address public BASE_isHealthy = 0x4f27734719F12D10258bbA889C789641fb4A122e;
    address public BASE_lendingPoolDeployer = 0x37f2Bd8f84e0eA1488053B2090d29D8dE76b338a;
    address public BASE_lendingPoolFactory = 0x31c3850D2cBDC5B084D632d1c61d54161790bFF8;
    address public BASE_lendingPool = 0x76091aC74058d69e32CdbCc487bF0bCA09cb59D7;
    address public BASE_position = 0x7C1A494ED22eAFC04e314c79Fc81AD11386f63a1;

    address public EthUsd = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
    address public BtcUsd = 0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298;
    address public UsdtUsd = 0x3ec8593F930EA45ea58c968260e6e9FF53FC934f;
    address public UsdcUsd = 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165;

    address public oracleUsdcUsd = 0x472D927f50bBbCf493fF70f00344e419c4344158;
    address public oracleUsdtUsd = 0x3f7563696E8be45f0B20BC2D99D220B1925E8efd;
    address public oracleEthUsd = 0xF0470C81960C1f40A8A56e654034aC5176356AA2;
    address public oracleBtcUsd = 0xa6c5C0dFe1fBD9e7361B459Fa18C08249805be55;

    address public DEPLOYED_helperTestnet = 0x6b07A08C5c42576F5F32e7404eFEf3509D1A99C9;
    address public BASE_helperUtils = 0x6234F07ad85805D01446BB7D8e1f8E5e2018cEB1;


    address public AVAX_USDC = 0xC014F158EbADce5a8e31f634c0eb062Ce8CDaeFe;
    address public AVAX_USDT = 0x1E713E704336094585c3e8228d5A8d82684e4Fb0;
    address public AVAX_WETH = 0x63CFd5c58332c38d89B231feDB5922f5817DF180;
    address public AVAX_WBTC = 0xa7A93C5F0691a5582BAB12C0dE7081C499aECE7f;
    address public AVAX_WXTZ = 0xA61Eb0D33B5d69DC0D0CE25058785796296b1FBd;

    address public ARB_USDC = 0x93Abc28490836C3f50eF44ee7B300E62f4bda8ab;
    address public ARB_USDT = 0x8B34f890d496Ff9FCdcDb113d3d464Ee54c35623;
    address public ARB_WXTZ = 0x64D3ee701c5d649a8a1582f19812416c132c9700;
    address public ARB_WBTC = 0xa998cBD0798F827a5Ed40A5c461E5052c06ff7C6;
    address public ARB_WETH = 0x9eCee5E6a7D23703Ae46bEA8c293Fa63954E8525;

    address public ETHERLINK_USDC = 0xB8DB4FcdD486a031a3B2CA27B588C015CB99F5F0;
    address public ETHERLINK_USDT = 0x2761372682FE39A53A5b1576467a66b258C3fec2;
    address public ETHERLINK_WXTZ = 0x0320aC8A299b3da6469bE3Da9ED6c84D09309418;
    address public ETHERLINK_WBTC = 0x50df5e25AB60e150f753B9444D160a80f0279559;
    address public ETHERLINK_WETH = 0x0355360B7F943974404277936a5C7536B51B9A77;

    address public ORIGIN_USDC = ETHERLINK_USDC;
    address public ORIGIN_USDT = ETHERLINK_USDT;
    address public ORIGIN_WXTZ = ETHERLINK_WXTZ;
    address public ORIGIN_WBTC = ETHERLINK_WBTC;
    address public ORIGIN_WETH = ETHERLINK_WETH;

    // address public protocol = 0x0AF08ff73ED8C3666f54b9B8C7044De90Ef2b7cb;
    // address public isHealthy = 0x7234365A362e33C93C8E9eeAd107266368C57f0d;
    address public ORIGIN_lendingPoolDeployer = 0xFaE7aC9665bd0F22A3b01C8C4F22B83581Ea4Ba9;
    address public ORIGIN_lendingPoolFactory = 0x6361193Eb93685c0218AD2c698809c99CF6d7e38;
    address public ORIGIN_lendingPool = 0xcE05d498fED4B72620b8D42954002bdEbe65Fb0e;
    address public ORIGIN_position = 0x4aF0b3462411a18934318e7F17E905C77F078b5b;

    address public claimAddress = vm.envAddress("ADDRESS");

    // chain id
    uint256 public ETH_Sepolia = 11155111;
    uint256 public Avalanche_Fuji = 43113;
    uint256 public Arb_Sepolia = 421614;
    uint256 public Base_Sepolia = 84532;
    uint256 public Etherlink_Testnet = 128123;
}

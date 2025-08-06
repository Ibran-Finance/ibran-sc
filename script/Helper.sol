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
 * @author Ibran Team
 * @notice Helper contract containing deployed contract addresses across different chains
 * @dev This contract serves as a central registry for all deployed contract addresses
 * in the Ibran cross-chain lending protocol. It contains addresses for:
 * - Mock tokens (USDC, USDT, WXTZ, WBTC, WETH) on different chains
 * - Core protocol contracts (Protocol, IsHealthy, LendingPool, etc.)
 * - Chain-specific configurations
 * 
 * The contract is used by deployment scripts to reference existing deployments
 * and avoid redeploying contracts that are already live on target chains.
 * 
 * @custom:security This contract contains sensitive address information and should be
 * used carefully in production environments
 */
contract Helper is Script {
    // ============ AVALANCHE FUJI TESTNET ADDRESSES ============
    /** @notice Mock USDC token address on Avalanche Fuji testnet */
    address public AVAX_USDC = 0xC014F158EbADce5a8e31f634c0eb062Ce8CDaeFe;
    /** @notice Mock USDT token address on Avalanche Fuji testnet */
    address public AVAX_USDT = 0x1E713E704336094585c3e8228d5A8d82684e4Fb0;
    /** @notice Mock WETH token address on Avalanche Fuji testnet */
    address public AVAX_WETH = 0x63CFd5c58332c38d89B231feDB5922f5817DF180;
    /** @notice Mock WBTC token address on Avalanche Fuji testnet */
    address public AVAX_WBTC = 0xa7A93C5F0691a5582BAB12C0dE7081C499aECE7f;
    /** @notice Mock WXTZ token address on Avalanche Fuji testnet */
    address public AVAX_WXTZ = 0xA61Eb0D33B5d69DC0D0CE25058785796296b1FBd;

    // ============ ARBITRUM SEPOLIA TESTNET ADDRESSES ============
    /** @notice Mock USDC token address on Arbitrum Sepolia testnet */
    address public ARB_USDC = 0x93Abc28490836C3f50eF44ee7B300E62f4bda8ab;
    /** @notice Mock USDT token address on Arbitrum Sepolia testnet */
    address public ARB_USDT = 0x8B34f890d496Ff9FCdcDb113d3d464Ee54c35623;
    /** @notice Mock WXTZ token address on Arbitrum Sepolia testnet */
    address public ARB_WXTZ = 0x64D3ee701c5d649a8a1582f19812416c132c9700;
    /** @notice Mock WBTC token address on Arbitrum Sepolia testnet */
    address public ARB_WBTC = 0xa998cBD0798F827a5Ed40A5c461E5052c06ff7C6;
    /** @notice Mock WETH token address on Arbitrum Sepolia testnet */
    address public ARB_WETH = 0x9eCee5E6a7D23703Ae46bEA8c293Fa63954E8525;

    // ============ ETHERLINK TESTNET ADDRESSES ============
    /** @notice Mock USDC token address on Etherlink testnet */
    address public ETHERLINK_USDC = 0xB8DB4FcdD486a031a3B2CA27B588C015CB99F5F0;
    /** @notice Mock USDT token address on Etherlink testnet */
    address public ETHERLINK_USDT = 0x2761372682FE39A53A5b1576467a66b258C3fec2;
    /** @notice Mock WXTZ token address on Etherlink testnet */
    address public ETHERLINK_WXTZ = 0x0320aC8A299b3da6469bE3Da9ED6c84D09309418;
    /** @notice Mock WBTC token address on Etherlink testnet */
    address public ETHERLINK_WBTC = 0x50df5e25AB60e150f753B9444D160a80f0279559;
    /** @notice Mock WETH token address on Etherlink testnet */
    address public ETHERLINK_WETH = 0x0355360B7F943974404277936a5C7536B51B9A77;

    // ============ ORIGIN CHAIN ADDRESSES (CURRENTLY ETHERLINK) ============
    /** @notice Origin chain USDC address (currently Etherlink) */
    address public ORIGIN_USDC = ETHERLINK_USDC;
    /** @notice Origin chain USDT address (currently Etherlink) */
    address public ORIGIN_USDT = ETHERLINK_USDT;
    /** @notice Origin chain WXTZ address (currently Etherlink) */
    address public ORIGIN_WXTZ = ETHERLINK_WXTZ;
    /** @notice Origin chain WBTC address (currently Etherlink) */
    address public ORIGIN_WBTC = ETHERLINK_WBTC;
    /** @notice Origin chain WETH address (currently Etherlink) */
    address public ORIGIN_WETH = ETHERLINK_WETH;

    // ============ CORE PROTOCOL CONTRACTS ============
    /** @notice Main Protocol contract address */
    address public protocol = 0x0AF08ff73ED8C3666f54b9B8C7044De90Ef2b7cb;
    /** @notice IsHealthy contract address for health checks */
    address public isHealthy = 0x7234365A362e33C93C8E9eeAd107266368C57f0d;
    /** @notice LendingPoolDeployer contract address */
    address public ORIGIN_lendingPoolDeployer = 0xFaE7aC9665bd0F22A3b01C8C4F22B83581Ea4Ba9;
    /** @notice LendingPoolFactory contract address */
    address public ORIGIN_lendingPoolFactory = 0x6361193Eb93685c0218AD2c698809c99CF6d7e38;
    /** @notice LendingPool contract address */
    address public ORIGIN_lendingPool = 0xcE05d498fED4B72620b8D42954002bdEbe65Fb0e;
    /** @notice Position contract address */
    address public ORIGIN_position = 0x4aF0b3462411a18934318e7F17E905C77F078b5b;

    /** @notice User's wallet address for testing (from environment variable) */
    address public claimAddress = vm.envAddress("ADDRESS");

    // ============ CHAIN ID CONSTANTS ============
    /** @notice Ethereum Sepolia testnet chain ID */
    uint256 public ETH_Sepolia = 11155111;
    /** @notice Avalanche Fuji testnet chain ID */
    uint256 public Avalanche_Fuji = 43113;
    /** @notice Arbitrum Sepolia testnet chain ID */
    uint256 public Arb_Sepolia = 421614;
    /** @notice Base Sepolia testnet chain ID */
    uint256 public Base_Sepolia = 84532;
    /** @notice Etherlink testnet chain ID */
    uint256 public Etherlink_Testnet = 128123;
}

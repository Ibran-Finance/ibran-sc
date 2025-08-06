// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

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
 * @author Ibran Protocol
 * @notice A helper contract that provides network configuration and constants
 * @dev This contract contains network-specific configurations including chain IDs,
 * router addresses, and LINK token addresses for various supported networks.
 * 
 * The contract provides:
 * - Enum definitions for supported networks
 * - Chain ID constants for each network
 * - Router address constants for each network
 * - LINK token address constants for each network
 * - Helper function to get configuration for a specific network
 * 
 * @custom:security This contract contains only constants and should not be
 * modified after deployment to maintain consistency across the protocol.
 */
contract Helper {
    // ============ ENUMS ============
    /// @notice Enum representing supported networks
    enum SupportedNetworks {
        ETHEREUM_SEPOLIA, // 0
        AVALANCHE_FUJI, // 1
        ARBITRUM_SEPOLIA, // 2
        BASE_SEPOLIA // 6
    }

    /// @notice Enum representing fee payment options
    enum PayFeesIn {
        Native,
        LINK
    }

    // ============ STATE VARIABLES ============
    /// @notice Mapping from network enum to human-readable network names
    mapping(SupportedNetworks enumValue => string humanReadableName) public networks;

    // ============ CONSTANTS ============
    /// @notice Chain ID for Ethereum Sepolia testnet
    uint64 constant CHAIN_ID_ETHEREUM_SEPOLIA = 16015286601757825753;
    /// @notice Chain ID for Avalanche Fuji testnet
    uint64 constant CHAIN_ID_AVALANCHE_FUJI = 14767482510784806043;
    /// @notice Chain ID for Arbitrum Sepolia testnet
    uint64 constant CHAIN_ID_ARBITRUM_SEPOLIA = 3478487238524512106;
    /// @notice Chain ID for Base Sepolia testnet
    uint64 constant CHAIN_ID_BASE_SEPOLIA = 10344971235874465080;

    /// @notice Router address for Ethereum Sepolia testnet
    address constant ROUTER_ETHEREUM_SEPOLIA = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;
    /// @notice Router address for Avalanche Fuji testnet
    address constant ROUTER_AVALANCHE_FUJI = 0xF694E193200268f9a4868e4Aa017A0118C9a8177;
    /// @notice Router address for Arbitrum Sepolia testnet
    address constant ROUTER_ARBITRUM_SEPOLIA = 0x2a9C5afB0d0e4BAb2BCdaE109EC4b0c4Be15a165;
    /// @notice Router address for Base Sepolia testnet
    address constant ROUTER_BASE_SEPOLIA = 0xD3b06cEbF099CE7DA4AcCf578aaebFDBd6e88a93;

    /// @notice LINK token address for Ethereum Sepolia testnet
    address constant LINK_ETHEREUM_SEPOLIA = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    /// @notice LINK token address for Avalanche Fuji testnet
    address constant LINK_AVALANCHE_FUJI = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;
    /// @notice LINK token address for Arbitrum Sepolia testnet
    address constant LINK_ARBITRUM_SEPOLIA = 0xb1D4538B4571d411F07960EF2838Ce337FE1E80E;
    /// @notice LINK token address for Base Sepolia testnet
    address constant LINK_BASE_SEPOLIA = 0xE4aB69C077896252FAFBD49EFD26B5D171A32410;

    /**
     * @notice Constructor to initialize network name mappings
     * @dev Sets up human-readable names for each supported network
     */
    constructor() {
        networks[SupportedNetworks.ETHEREUM_SEPOLIA] = "Ethereum Sepolia";
        networks[SupportedNetworks.AVALANCHE_FUJI] = "Avalanche Fuji";
        networks[SupportedNetworks.ARBITRUM_SEPOLIA] = "Arbitrum Sepolia";
        networks[SupportedNetworks.BASE_SEPOLIA] = "Base Sepolia";
    }

    /**
     * @notice Gets configuration for a specific network
     * @param network The supported network to get configuration for
     * @return router The router address for the network
     * @return linkToken The LINK token address for the network
     * @return wrappedNative The wrapped native token address (currently always address(0))
     * @return chainId The chain ID for the network
     * @dev Returns the router address, LINK token address, wrapped native address, and chain ID
     * for the specified network. Currently, wrapped native is always address(0) as it's not used.
     */
    function getConfigFromNetwork(SupportedNetworks network)
        internal
        pure
        returns (address router, address linkToken, address wrappedNative, uint64 chainId)
    {
        if (network == SupportedNetworks.ETHEREUM_SEPOLIA) {
            return (ROUTER_ETHEREUM_SEPOLIA, LINK_ETHEREUM_SEPOLIA, address(0), CHAIN_ID_ETHEREUM_SEPOLIA);
        } else if (network == SupportedNetworks.ARBITRUM_SEPOLIA) {
            return (ROUTER_ARBITRUM_SEPOLIA, LINK_ARBITRUM_SEPOLIA, address(0), CHAIN_ID_ARBITRUM_SEPOLIA);
        } else if (network == SupportedNetworks.AVALANCHE_FUJI) {
            return (ROUTER_AVALANCHE_FUJI, LINK_AVALANCHE_FUJI, address(0), CHAIN_ID_AVALANCHE_FUJI);
        } else if (network == SupportedNetworks.BASE_SEPOLIA) {
            return (ROUTER_BASE_SEPOLIA, LINK_BASE_SEPOLIA, address(0), CHAIN_ID_BASE_SEPOLIA);
        }
    }
}

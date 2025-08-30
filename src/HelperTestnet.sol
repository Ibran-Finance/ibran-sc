// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title HelperTestnet
 * @dev Helper contract for managing testnet chain configurations and bridge settings
 * @notice This contract provides centralized configuration for testnet chains and bridge operations
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract HelperTestnet {
    // ============ Errors ============

    /**
     * @dev Error thrown when a non-owner tries to perform owner-only operations
     */
    error NotOwner();

    /**
     * @dev Error thrown when trying to add a chain that already exists
     */
    error ChainAlreadyExists();

    /**
     * @dev Error thrown when trying to add a token that already exists
     */
    error TokenAlreadyExists();

    /**
     * @dev Error thrown when trying to access a token that doesn't exist
     */
    error TokenNotExists();

    // ============ Structs ============

    /**
     * @dev Structure containing chain configuration information
     * @param mailbox Address of the Hyperlane mailbox contract
     * @param gasMaster Address of the gas master contract
     * @param domainId Domain ID for the chain
     */
    struct ChainInfo {
        address mailbox;
        address gasMaster;
        uint32 domainId;
    }

    // ============ State Variables ============

    /**
     * @dev Mapping from chain ID to chain configuration
     */
    mapping(uint256 => ChainInfo) public chains;

    /**
     * @dev Mapping from chain ID to receiver bridge address
     */
    mapping(uint256 => address) public receiverBridge;

    /**
     * @dev Address of the contract owner
     */
    address public owner;

    /**
     * @dev Current chain ID
     */
    uint256 public chainId;

    // ============ Modifiers ============

    /**
     * @dev Modifier to restrict access to owner only
     */
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    /**
     * @dev Internal function to check if caller is owner
     * @notice Reverts if caller is not the owner
     */
    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }

    /**
     * @dev Constructor for the HelperTestnet contract
     * @notice Initializes the contract with owner and pre-configures testnet chains
     */
    constructor() {
        owner = msg.sender;
        chainId = block.chainid;
        // ABSTRACT
        chains[11124] =
            ChainInfo(0x28f448885bEaaF662f8A9A6c9aF20fAd17A5a1DC, 0xbAaE1B4e953190b05C757F69B2F6C46b9548fa4f, 11124);

        // ALEPH_ZERO
        chains[2039] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0x867f2089D09903f208AeCac84E599B90E5a4A821, 2039);

        // ALFAJORES
        chains[44787] =
            ChainInfo(0xEf9F292fcEBC3848bF4bB92a96a04F9ECBb78E59, 0x44769B0f4a6F01339e131a691Cc2eEBBB519d297, 44787);

        // ARBITRUM_SEPOLIA
        chains[421614] =
            ChainInfo(0x598facE78a4302f11E3de0bee1894Da0b2Cb71F8, 0xc756cFc1b7d0d4646589EDf10eD54b201237F5e8, 421614);

        // BASE_SEPOLIA
        chains[84532] =
            ChainInfo(0x6966b0E55883d49BFB24539356a2f8A673E02039, 0x28B02B97a850872C4D33C3E024fab6499ad96564, 84532);

        // BSC_TESTNET
        chains[97] =
            ChainInfo(0xF9F6F5646F478d5ab4e20B0F910C92F1CCC9Cc6D, 0x0dD20e410bdB95404f71c5a4e7Fa67B892A5f949, 97);

        // AVALANCHE FUJI
        chains[43113] =
            ChainInfo(0x5b6CFf85442B851A8e6eaBd2A4E4507B5135B3B0, 0x6895d3916B94b386fAA6ec9276756e16dAe7480E, 43113);

        // HOLESKY
        chains[17000] =
            ChainInfo(0x46f7C5D896bbeC89bE1B19e4485e59b4Be49e9Cc, 0x5CBf4e70448Ed46c2616b04e9ebc72D29FF0cfA9, 17000);

        // OPTIMISM_SEPOLIA
        chains[11155420] =
            ChainInfo(0x6966b0E55883d49BFB24539356a2f8A673E02039, 0x28B02B97a850872C4D33C3E024fab6499ad96564, 11155420);

        // POLYGON_AMOY
        chains[80002] =
            ChainInfo(0x54148470292C24345fb828B003461a9444414517, 0x6c13643B3927C57DB92c790E4E3E7Ee81e13f78C, 80002);

        // SCROLL_SEPOLIA
        chains[534351] =
            ChainInfo(0x3C5154a193D6e2955650f9305c8d80c18C814A68, 0x86fb9F1c124fB20ff130C41a79a432F770f67AFD, 534351);

        // SEPOLIA
        chains[11155111] =
            ChainInfo(0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766, 0x6f2756380FD49228ae25Aa7F2817993cB74Ecc56, 11155111);

        // UNICHAIN
        chains[1301] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0xa3AB7E6cE24E6293bD5320A53329Ef2f4DE73fCA, 1301);

        // SUAVE_TOLIMAN
        chains[33626250] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0xA2cf52064c921C11adCd83588CbEa08cc3bfF5d8, 33626250);

        // ODYSSEY
        chains[911867] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0xD356C996277eFb7f75Ee8bd61b31cC781A12F54f, 911867);

        // MODE
        chains[919] =
            ChainInfo(0x589C201a07c26b4725A4A829d772f24423da480B, 0xB261C52241E133f957630AeeFEd48a82963AC33e, 919);

        // MEGAETH
        chains[6342] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0x867f2089D09903f208AeCac84E599B90E5a4A821, 6342);

        // ETHERLINK_TESTNET
        chains[128123] =
            ChainInfo(0xDDcFEcF17586D08A5740B7D91735fcCE3dfe3eeD, 0x867f2089D09903f208AeCac84E599B90E5a4A821, 128123);

        // CORE TESTNET
        chains[1114] =
            ChainInfo(0xd5b993dB69c2263086C88870b47eec787b5427B8, 0x4eAD9ce51e740277ac070ec84914dE614D20036c, 1114);
    }

    // ============ Public Functions ============

    /**
     * @dev Adds a new chain configuration
     * @param _mailbox Address of the mailbox contract
     * @param _gasMaster Address of the gas master contract
     * @param _domainId Domain ID for the chain
     * @param _chainId Chain ID to add
     * @notice This function allows the owner to add new chain configurations
     * @custom:security Only the owner can add new chains
     */
    function addChain(address _mailbox, address _gasMaster, uint32 _domainId, uint256 _chainId) external onlyOwner {
        chains[_chainId] = ChainInfo(_mailbox, _gasMaster, _domainId);
    }

    /**
     * @dev Adds a receiver bridge for a specific chain
     * @param _chainId Chain ID for the bridge
     * @param _receiverBridge Address of the receiver bridge contract
     * @notice This function allows the owner to add receiver bridge configurations
     * @custom:security Only the owner can add receiver bridges
     */
    function addReceiverBridge(uint256 _chainId, address _receiverBridge) external onlyOwner {
        receiverBridge[_chainId] = _receiverBridge;
    }
}

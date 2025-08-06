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
 * @title IHelperTestnet
 * @dev Interface for testnet helper functionality
 * @notice This interface defines the contract for managing cross-chain configurations in testnet environments
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
interface IHelperTestnet {
    /**
     * @dev Returns chain configuration for a specific chain ID
     * @param _chainId Chain ID to query
     * @return mailbox Address of the mailbox contract
     * @return gasMaster Address of the gas master contract
     * @return domainId Domain ID for the chain
     * @notice This function provides cross-chain configuration data
     */
    function chains(uint256 _chainId) external view returns (address, address, uint32);
    
    /**
     * @dev Returns the receiver bridge address for a specific chain
     * @param _chainId Chain ID to query
     * @return Address of the receiver bridge contract
     */
    function receiverBridge(uint256 _chainId) external view returns (address);
    
    /**
     * @dev Adds a new chain configuration
     * @param _mailbox Address of the mailbox contract
     * @param _gasMaster Address of the gas master contract
     * @param _domainId Domain ID for the chain
     * @param _chainId Chain ID to add
     * @notice This function registers a new chain for cross-chain operations
     * @custom:security Only authorized addresses should be able to add chains
     */
    function addChain(address _mailbox, address _gasMaster, uint32 _domainId, uint256 _chainId) external;
    
    /**
     * @dev Adds a receiver bridge for a specific chain
     * @param _chainId Chain ID for the bridge
     * @param _receiverBridge Address of the receiver bridge contract
     * @notice This function registers a new receiver bridge
     * @custom:security Only authorized addresses should be able to add receiver bridges
     */
    function addReceiverBridge(uint256 _chainId, address _receiverBridge) external;
}

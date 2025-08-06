// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import {IIbranBridgeTokenSender} from "../interfaces/IIbranBridgeTokenSender.sol";
import {ERC20} from "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title MockUSDT
 * @dev Mock USDT token contract for testing purposes
 * @notice This contract simulates USDT token functionality with 6 decimals and bridge capabilities
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract MockUSDT is ERC20 {
    // ============ Errors ============
    
    /**
     * @dev Error thrown when an invalid chain ID is provided
     */
    error InvalidChainId();
    
    /**
     * @dev Error thrown when a non-owner tries to perform an owner-only operation
     */
    error NotOwner();

    // ============ State Variables ============
    
    /**
     * @dev Address of the contract owner
     */
    address public owner;
    
    /**
     * @dev Address of the helper testnet contract
     */
    address public helperTestnet;
    
    /**
     * @dev Mapping from chain ID to array of bridge token sender addresses
     */
    mapping(uint256 => address[]) public bridgeTokenSenders;

    // ============ Events ============
    
    /**
     * @dev Emitted when a new bridge token sender is added
     * @param bridgeTokenSender Address of the bridge token sender
     * @param chainId Chain ID for the bridge
     */
    event BridgeTokenSenderAdded(address indexed bridgeTokenSender, uint256 indexed chainId);

    /**
     * @dev Constructor for the MockUSDT contract
     * @param _helperTestnet Address of the helper testnet contract
     * @notice Initializes the mock USDT token with 6 decimals
     */
    constructor(address _helperTestnet) ERC20("USD Tether", "USDT") {
        helperTestnet = _helperTestnet;
        owner = msg.sender;
    }

    // ============ Modifiers ============
    
    /**
     * @dev Modifier to restrict access to owner only
     */
    modifier _onlyOwner() {
        __onlyOwner();
        _;
    }

    /**
     * @dev Internal function to check if caller is owner
     * @notice Reverts if caller is not the owner
     */
    function __onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }

    // ============ Public Functions ============
    
    /**
     * @dev Mints new USDT tokens to a specified address
     * @param to Address to receive the minted tokens
     * @param amount Amount of tokens to mint
     * @notice This function is for hackathon purposes and allows anyone to mint
     * @custom:security This function should only be used in test environments
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @dev Burns tokens from the caller's balance
     * @param amount Amount of tokens to burn
     * @notice This function destroys tokens from the caller's balance
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Mints mock USDT tokens for testing purposes
     * @param to Address to receive the minted tokens
     * @param amount Amount of tokens to mint
     * @notice This function is specifically for testing and development
     * @custom:security This function should only be available in test environments
     */
    function mintMock(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @dev Burns mock USDT tokens for testing purposes
     * @param amount Amount of tokens to burn
     * @notice This function is specifically for testing and development
     * @custom:security This function should only be available in test environments
     */
    function burnMock(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Returns the number of decimals for USDT
     * @return The number of decimal places (6 for USDT)
     * @notice USDT uses 6 decimals unlike most ERC20 tokens which use 18
     */
    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /**
     * @dev Adds a new bridge token sender for cross-chain operations
     * @param _bridgeTokenSender Address of the bridge token sender to add
     * @notice This function registers a new bridge token sender for a specific chain
     * @custom:security Only the owner can add bridge token senders
     */
    function addBridgeTokenSender(address _bridgeTokenSender) public _onlyOwner {
        uint256 _chainId = IIbranBridgeTokenSender(_bridgeTokenSender).chainId();
        if (_chainId == 0) revert InvalidChainId();
        bridgeTokenSenders[_chainId].push(_bridgeTokenSender);
        emit BridgeTokenSenderAdded(_bridgeTokenSender, _chainId);
    }

    /**
     * @dev Returns the number of bridge token senders for a specific chain
     * @param _chainId Chain ID to query
     * @return Number of bridge token senders for the specified chain
     */
    function getBridgeTokenSendersLength(uint256 _chainId) external view returns (uint256) {
        return bridgeTokenSenders[_chainId].length;
    }
}

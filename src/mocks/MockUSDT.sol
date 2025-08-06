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
 * @dev Mock implementation of USDT token with bridge functionality for testing purposes
 * @notice This contract mimics USDT behavior with additional features for cross-chain bridge testing
 * @author IBRAN Team
 */
contract MockUSDT is ERC20 {
    /// @dev Thrown when chain ID is zero or invalid
    error InvalidChainId();
    
    /// @dev Thrown when caller is not the contract owner
    error NotOwner();

    /// @notice Address of the helper testnet contract
    address public helperTestnet;
    
    /// @notice Address of the contract owner
    address public owner;
    
    /// @notice Mapping of chain ID to array of bridge token sender addresses
    mapping(uint256 => address[]) public bridgeTokenSenders;

    /**
     * @dev Emitted when a new bridge token sender is added
     * @param bridgeTokenSender Address of the added bridge token sender
     * @param chainId Chain ID where the bridge operates
     */
    event BridgeTokenSenderAdded(address indexed bridgeTokenSender, uint256 indexed chainId);

    /**
     * @dev Constructor to initialize the MockUSDT contract
     * @param _helperTestnet Address of the helper testnet contract
     */
    constructor(address _helperTestnet) ERC20("USDT", "USDT") {
        helperTestnet = _helperTestnet;
        owner = msg.sender;
    }

    /**
     * @dev Modifier to restrict access to owner only
     */
    modifier _onlyOwner() {
        __onlyOwner();
        _;
    }

    /**
     * @dev Internal function to check if caller is owner
     */
    function __onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }

    /**
     * @notice Mint tokens to a specific address (for hackathon/testing purposes)
     * @dev This function is public and can be called by anyone for testing
     * @param to Address to mint tokens to
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @notice Burn tokens from caller's balance
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @notice Mock mint function for testing purposes
     * @dev Alternative mint function for testing scenarios
     * @param to Address to mint tokens to
     * @param amount Amount of tokens to mint
     */
    function mintMock(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @notice Mock burn function for testing purposes
     * @dev Alternative burn function for testing scenarios
     * @param amount Amount of tokens to burn from caller's balance
     */
    function burnMock(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @notice Returns the number of decimal places for the token
     * @dev USDT uses 6 decimal places
     * @return Number of decimal places (6)
     */
    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /**
     * @notice Add a bridge token sender for cross-chain operations
     * @dev Only owner can add bridge token senders, requires valid chain ID
     * @param _bridgeTokenSender Address of the bridge token sender contract
     * @custom:throws InvalidChainId if chain ID is zero
     * @custom:throws NotOwner if caller is not owner
     */
    function addBridgeTokenSender(address _bridgeTokenSender) public _onlyOwner {
        uint256 _chainId = IIbranBridgeTokenSender(_bridgeTokenSender).chainId();
        if (_chainId == 0) revert InvalidChainId();
        bridgeTokenSenders[_chainId].push(_bridgeTokenSender);
        emit BridgeTokenSenderAdded(_bridgeTokenSender, _chainId);
    }

    /**
     * @notice Get the number of bridge token senders for a specific chain
     * @param _chainId Chain ID to query
     * @return Length of bridge token senders array for the given chain ID
     */
    function getBridgeTokenSendersLength(uint256 _chainId) external view returns (uint256) {
        return bridgeTokenSenders[_chainId].length;
    }
}
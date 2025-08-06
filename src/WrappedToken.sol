// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
 * @title WrappedToken
 * @dev Wrapped token contract for cross-chain bridging
 * @notice This contract represents wrapped versions of tokens for cross-chain operations
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract WrappedToken is ERC20 {
    // ============ State Variables ============
    
    /**
     * @dev Address of the bridge contract that can mint tokens
     */
    address public bridge;

    /**
     * @dev Constructor for the WrappedToken contract
     * @param name Name of the wrapped token
     * @param symbol Symbol of the wrapped token
     * @notice Initializes the wrapped token with the deployer as the bridge
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        bridge = msg.sender;
    }

    /**
     * @dev Mints new wrapped tokens to a specified address
     * @param to Address to receive the minted tokens
     * @param amount Amount of tokens to mint
     * @notice This function allows the bridge to mint new wrapped tokens
     * @custom:security Only the bridge should be able to mint tokens
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

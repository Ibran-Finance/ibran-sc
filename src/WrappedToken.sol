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
 * @author Ibran Protocol
 * @notice A simple wrapped token implementation for cross-chain bridging
 * @dev This contract provides a basic wrapped token implementation that can be used
 * for cross-chain token bridging. It extends the standard ERC20 token with
 * minting functionality that is restricted to the bridge contract.
 * 
 * The contract allows the bridge contract to mint tokens when receiving
 * cross-chain transfers, enabling seamless token movement between chains.
 * 
 * @custom:security This contract should only be used in conjunction with
 * properly secured bridge contracts that control the minting functionality.
 */
contract WrappedToken is ERC20 {
    // ============ STATE VARIABLES ============
    /// @notice The address of the bridge contract that can mint tokens
    address public bridge;

    /**
     * @notice Constructor to initialize the wrapped token
     * @param name The name of the token
     * @param symbol The symbol of the token
     * @dev Sets the bridge address to msg.sender (the deployer)
     * @dev Initializes the ERC20 token with the provided name and symbol
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        bridge = msg.sender;
    }

    /**
     * @notice Mints new tokens to a specified address
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     * @dev Only the bridge contract can call this function
     * @dev Uses the internal _mint function from ERC20
     * 
     * @custom:security This function should only be called by the bridge contract
     * to prevent unauthorized minting of tokens.
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

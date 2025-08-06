// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title Protocol
 * @author Ibran Protocol
 * @notice A simple protocol contract for managing token withdrawals
 * @dev This contract provides basic protocol-level functionality for
 * withdrawing tokens from the protocol treasury. It includes reentrancy
 * protection and access controls to ensure secure operations.
 * 
 * The contract serves as a treasury management tool for the Ibran protocol,
 * allowing the owner to withdraw tokens that have accumulated in the protocol.
 * 
 * @custom:security This contract includes reentrancy protection and access controls
 * to prevent unauthorized withdrawals and ensure secure token transfers.
 */
contract Protocol is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    // ============ ERRORS ============
    /// @notice Error thrown when there are insufficient tokens for withdrawal
    /// @param token The address of the token that has insufficient balance
    /// @param amount The amount that was attempted to withdraw
    error InsufficientBalance(address token, uint256 amount);

    /**
     * @notice Constructor to initialize the protocol contract
     * @dev Sets the initial owner to msg.sender
     */
    constructor() Ownable(msg.sender) {}

    /**
     * @notice Withdraws tokens from the protocol treasury
     * @param token The address of the token to withdraw
     * @param amount The amount of tokens to withdraw
     * @dev Only the owner can call this function
     * @dev Includes reentrancy protection to prevent recursive calls
     * @dev Uses SafeERC20 for secure token transfers
     * 
     * @custom:error InsufficientBalance - If the protocol has insufficient tokens
     * @custom:error "Ownable: caller is not the owner" - If caller is not the owner
     */
    function withdraw(address token, uint256 amount) public nonReentrant onlyOwner {
        if (IERC20(token).balanceOf(address(this)) < amount) {
            revert InsufficientBalance(token, amount);
        }
        IERC20(token).safeTransfer(msg.sender, amount);
    }
}

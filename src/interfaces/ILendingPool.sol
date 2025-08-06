// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title ILendingPool
 * @dev Interface for lending pool functionality
 * @notice Defines the interface for lending pools that support collateralized borrowing and cross-chain operations
 * @author IBRAN Team
 */
interface ILendingPool {
    
    /**
     * @notice Returns the loan-to-value ratio for this lending pool
     * @dev LTV determines how much can be borrowed against collateral
     * @return The LTV ratio in basis points (e.g., 7500 = 75%)
     */
    function ltv() external view returns (uint256);
    
    /**
     * @notice Returns the address of the collateral token accepted by this pool
     * @dev Users must supply this token as collateral to borrow
     * @return The contract address of the collateral token
     */
    function collateralToken() external view returns (address);
    
    /**
     * @notice Returns the address of the token that can be borrowed from this pool
     * @dev This is the debt token that users can borrow against their collateral
     * @return The contract address of the borrow token
     */
    function borrowToken() external view returns (address);
    
    /**
     * @notice Supplies collateral tokens to the pool
     * @dev User must approve the pool to spend their collateral tokens before calling this
     * @param amount The amount of collateral tokens to supply
     * 
     * Requirements:
     * - `amount` must be greater than 0
     * - User must have sufficient token balance and approval
     */
    function supplyCollateral(uint256 amount) external;
    
    /**
     * @notice Supplies liquidity (borrow tokens) to the pool for lending
     * @dev Liquidity providers earn interest from borrowers
     * @param amount The amount of liquidity tokens to supply
     * 
     * Requirements:
     * - `amount` must be greater than 0
     * - User must have sufficient token balance and approval
     */
    function supplyLiquidity(uint256 amount) external;
    
    /**
     * @notice Borrows debt tokens from the pool, optionally bridging to another chain
     * @dev Requires sufficient collateral to maintain healthy position
     * @param amount The amount of debt tokens to borrow
     * @param _chainId The destination chain ID for cross-chain borrowing (0 for same chain)
     * @param _bridgeTokenSender The bridge contract address for cross-chain operations
     * 
     * Requirements:
     * - User must have sufficient collateral
     * - Position must remain healthy after borrow
     * - For cross-chain: must send bridge fees via msg.value
     */
    function borrowDebt(uint256 amount, uint256 _chainId, uint256 _bridgeTokenSender) external payable;
    
    /**
     * @notice Repays borrowed debt using a specified token
     * @dev Allows flexible repayment with different tokens through swapping
     * @param shares The amount of borrow shares to repay
     * @param _token The token address to use for repayment
     * @param _fromPosition Whether to use tokens from user's position balance
     * 
     * Requirements:
     * - User must have sufficient borrow shares
     * - If not `_fromPosition`, user must have token balance and approval
     */
    function repayWithSelectedToken(uint256 shares, address _token, bool _fromPosition) external;
    
    /**
     * @notice Returns the total amount of assets supplied as liquidity
     * @dev This represents the total available lending capital
     * @return The total supply assets in the pool
     */
    function totalSupplyAssets() external view returns (uint256);
    
    /**
     * @notice Returns the total number of supply shares issued
     * @dev Supply shares represent proportional ownership of the supply pool
     * @return The total supply shares in the pool
     */
    function totalSupplyShares() external view returns (uint256);
    
    /**
     * @notice Returns the total amount of assets borrowed from the pool
     * @dev This represents the total outstanding debt
     * @return The total borrow assets in the pool
     */
    function totalBorrowAssets() external view returns (uint256);
    
    /**
     * @notice Returns the total number of borrow shares issued
     * @dev Borrow shares represent proportional debt ownership
     * @return The total borrow shares in the pool
     */
    function totalBorrowShares() external view returns (uint256);
    
    /**
     * @notice Converts assets to shares for supply operations
     * @dev Used to calculate share amounts when supplying liquidity
     * @param assets Amount of assets to convert
     * @return shares Equivalent number of shares
     */
    function convertToShares(uint256 assets) external view returns (uint256 shares);
    
    /**
     * @notice Converts shares to assets for supply operations
     * @dev Used to calculate asset amounts when withdrawing liquidity
     * @param shares Amount of shares to convert
     * @return assets Equivalent amount of assets
     */
    function convertToAssets(uint256 shares) external view returns (uint256 assets);
    
    /**
     * @notice Converts assets to shares for borrow operations
     * @dev Used to calculate share amounts when borrowing
     * @param assets Amount of assets to convert
     * @return shares Equivalent number of shares
     */
    function convertToBorrowShares(uint256 assets) external view returns (uint256 shares);
    
    /**
     * @notice Converts shares to assets for borrow operations
     * @dev Used to calculate asset amounts when repaying debt
     * @param shares Amount of shares to convert
     * @return assets Equivalent amount of assets
     */
    function convertToBorrowAssets(uint256 shares) external view returns (uint256 assets);
}
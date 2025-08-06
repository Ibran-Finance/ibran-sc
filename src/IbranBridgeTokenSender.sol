// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IMailbox} from "./interfaces/IMailbox.sol";
import {IInterchainGasPaymaster} from "@hyperlane-xyz/interfaces/IInterchainGasPaymaster.sol";
import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IHelperTestnet} from "./interfaces/IHelperTestnet.sol";
import {ITokenSwap} from "./interfaces/ITokenSwap.sol";

/*
██╗██████╗░██████╗░░█████╗░███╗░░██╗
██║██╔══██╗██╔══██╗██╔══██╗████╗░██║
██║██████╦╝██████╔╝███████║██╔██╗██║
██║██╔══██╗██╔══██╗██╔══██║██║╚████║
██║██████╦╝██║░░██║██║░░██║██║░╚███║
╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝
*/

/**
 * @title IbranBridgeTokenSender
 * @dev Contract for sending tokens across chains via Hyperlane bridge
 * @notice This contract handles token bridging by burning tokens on source chain and sending messages to destination
 * @author Ibran Team
 * @custom:security-contact security@ibran.com
 * @custom:version 1.0.0
 */
contract IbranBridgeTokenSender {
    // ============ Errors ============
    
    /**
     * @dev Error thrown when trying to bridge to the same chain
     */
    error SameChain();
    
    /**
     * @dev Error thrown when token transfer fails
     */
    error TransferFailed();
    
    /**
     * @dev Error thrown when mailbox is not configured
     */
    error MailboxNotSet();
    
    /**
     * @dev Error thrown when interchain gas paymaster is not configured
     */
    error InterchainGasPaymasterNotSet();
    
    /**
     * @dev Error thrown when receiver bridge is not set
     */
    error ReceiverBridgeNotSet();

    // ============ State Variables ============
    
    /**
     * @dev Address of the helper testnet contract
     */
    address public helperTestnet;
    
    /**
     * @dev Address of the Hyperlane mailbox contract
     */
    address public mailbox;
    
    /**
     * @dev Address of the interchain gas paymaster contract
     */
    address public interchainGasPaymaster;
    
    /**
     * @dev Address of the token contract to bridge
     */
    address public token;
    
    /**
     * @dev Address of the receiver bridge on the destination chain
     */
    address public receiverBridge; // ** OTHER CHAIN
    
    /**
     * @dev Chain ID of the destination chain
     */
    uint256 public chainId; // ** OTHER CHAIN

    /**
     * @dev Constructor for the IbranBridgeTokenSender contract
     * @param _helperTestnet Address of the helper testnet contract
     * @param _token Address of the token contract to bridge
     * @param _receiverBridge Address of the receiver bridge on destination chain
     * @param _chainId Chain ID of the destination chain
     * @notice Initializes the bridge sender with all necessary addresses and validates configuration
     * @custom:security Ensure all addresses are valid and chain IDs are correct before deployment
     */
    constructor(address _helperTestnet, address _token, address _receiverBridge, uint256 _chainId) {
        helperTestnet = _helperTestnet;
        (address _mailbox, address _interchainGasPaymaster,) = IHelperTestnet(helperTestnet).chains(block.chainid);
        mailbox = _mailbox;
        interchainGasPaymaster = _interchainGasPaymaster;
        receiverBridge = _receiverBridge;
        chainId = _chainId;
        token = _token;

        _validateConstructorParams();
    }

    /**
     * @dev Validates all constructor parameters
     * @notice This function ensures all required addresses and chain configurations are valid
     * @custom:security This validation is critical for proper bridge functionality
     */
    function _validateConstructorParams() private view {
        _validateSameChain();
        _validateDifferentChain();
    }

    /**
     * @dev Validates same-chain configuration parameters
     * @notice Ensures mailbox and gas paymaster are properly configured for current chain
     */
    function _validateSameChain() private view {
        if (mailbox == address(0)) revert MailboxNotSet();
        if (interchainGasPaymaster == address(0)) revert InterchainGasPaymasterNotSet();
    }

    /**
     * @dev Validates cross-chain configuration parameters
     * @notice Ensures receiver bridge is set and destination chain is different from current chain
     */
    function _validateDifferentChain() private view {
        if (receiverBridge == address(0)) revert ReceiverBridgeNotSet();
        if (block.chainid == chainId) revert SameChain();
    }

    /**
     * @dev Bridges tokens to another chain via Hyperlane
     * @param _amount Amount of tokens to bridge
     * @param _recipient Address to receive tokens on destination chain
     * @param _token Address of the token to bridge
     * @return messageId The unique identifier of the bridge message
     * @notice This function burns tokens on source chain and sends message to destination chain
     * @custom:security Users must approve tokens before calling this function
     */
    function bridge(uint256 _amount, address _recipient, address _token) external payable returns (bytes32) {
        (,, uint32 destinationDomain) = IHelperTestnet(helperTestnet).chains(chainId); // ** OTHER CHAIN
        if (receiverBridge == address(0)) revert ReceiverBridgeNotSet();
        if (!IERC20(_token).transferFrom(msg.sender, address(this), _amount)) revert TransferFailed(); // TODO: BURN
        ITokenSwap(token).burn(_amount);
        // Encode payload
        bytes memory message = abi.encode(_recipient, _amount);
        // Send message to Chain B
        uint256 gasAmount = IInterchainGasPaymaster(interchainGasPaymaster).quoteGasPayment(destinationDomain, _amount);
        bytes32 recipientAddress = bytes32(uint256(uint160(receiverBridge)));
        bytes32 messageId = IMailbox(mailbox).dispatch{value: gasAmount}(destinationDomain, recipientAddress, message);
        return messageId;
    }
}

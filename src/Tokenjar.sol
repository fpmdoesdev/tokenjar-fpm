// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotOwner();
error ZeroTipAmount();
error WithdrawalFailed();

contract TokenJar {
    address public immutable owner;
    uint256 public totalTips;

    event TipReceived(
        address indexed senderAddress,
        uint256 amount,
        uint256 timestamp,
        string message
    );

    constructor() {
        owner = msg.sender;
    }

    function tip(string calldata message) external payable  {
        if(msg.value == 0) {
            revert ZeroTipAmount();
        }

        totalTips++;

        emit TipReceived(
            msg.sender,
            msg.value,
            block.timestamp,
            message
        );
    }

    function withdraw() external {
        if(msg.sender != owner) {
            revert NotOwner();
        }

        uint256 balance = address(this).balance;
        if(balance == 0) {
            revert ZeroTipAmount();
        }

        (bool success, ) = owner.call{value: balance}("");
        if(!success) {
            revert WithdrawalFailed();
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
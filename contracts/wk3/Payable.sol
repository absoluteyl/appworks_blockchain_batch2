// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    uint public counter = 0;
    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() public payable returns (uint) {
        require((msg.value >= 0.01 ether), "Amount should be greater than 0");
        return counter ++;
    }
}
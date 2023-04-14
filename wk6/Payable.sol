// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=A4VMhRIWSs0
contract Payable {
  address payable public owner;

  constructor() {
    owner = payable(msg.sender);
  }

  // Functions can receive Ether only when it's marked as payable.
  function deposit() external payable {}

  function getBalance() external view returns (uint) {
    return address(this).balance;
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=Q-wRG7pngn0

// Mapping
// How to declare a mapping (simple and nested)
// Set, get, delete

// ["alice", "bob", "charlie"]
// { "alice": true, "bob": true, "charlie": true }
contract Mapping {
  mapping(address => uint) public balances;
  mapping(address => mapping(address => bool)) public isFriend;

  function examples() external {
    balances[msg.sender] = 123;
    uint bal = balances[msg.sender];
    uint bal2 = balances[address(1)]; // will be 0

    balances[msg.sender] += 456; // will be 123 + 456 = 579

    delete balances[msg.sender]; // will be 0

    isFriend[msg.sender][address(this)] = true; // set this contract to be friend with sender
  }
}

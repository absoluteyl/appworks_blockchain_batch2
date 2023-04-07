// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=QEJYSuyYOfw

// state variables
// global variables
// function modifier
// function
// error handling

contract Ownable {
  address public owner;

  constructor () {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Permission Denied.");
    _;
  }

  function setOwner(address _newOwner) external onlyOwner {
    require(_newOwner != address(0), "Invalid Address.");
    owner = _newOwner;
  }

  function onlyOwnerCanCall() external onlyOwner {}
  function anyoneCanCall() external {}
}

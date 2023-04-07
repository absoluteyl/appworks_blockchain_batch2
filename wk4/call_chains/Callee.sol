// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Callee {
  address public sender;
  address public origin;

  function getData() external {
    sender = msg.sender;
    origin = tx.origin;
  }
}

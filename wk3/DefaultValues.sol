// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=TPnu-uqJiVI

// values when declare a variable but not assign value to it.
contract DefaultValues {
  bool public b; // false
  uint public u; // 0
  int  public i; // 0
  address public addr; // 0x000000000000000000000000000000
  bytes32 public b32; // 0x000000000000000000000000000000000000000000000000000000
}

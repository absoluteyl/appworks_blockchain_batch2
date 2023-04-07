// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=y5uiQ9IJhMc

// Constants use less gas when been exscuted
// execution cost	378 gas (Cost only applies when called by a contract)
contract Constants {
  address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  uint public constant MY_UINT = 506;
}

// Variables use more gas when been executed
// execution cost	2489 gas (Cost only applies when called by a contract)
contract Var {
  address public MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
}

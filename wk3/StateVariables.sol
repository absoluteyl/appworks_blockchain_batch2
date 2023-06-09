// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=hl692-xJPUQ

contract StateVariables {
  // State Variables are declare inside of contract but outside of function,
  // values assigned to state variable will be stored on the blockchain.
  uint public myUint = 123;

  function foo() external pure returns (uint) {
    // variables within a function is local variable,
    // local variables only exist while the function is been excuted.
    uint notStateVariable = 456;
    return notStateVariable;
  }
}

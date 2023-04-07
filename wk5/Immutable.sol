// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=nQi8lVi4xT4

contract Immutable {
    // make this variable as a constant, add immutable (will also save some gas)
    // consumed 50116 gas, will consume 52569 gas if we don't use immutable.
    address public immutable owner;
    
    constructor () {
        owner = msg.sender;
    }

    uint public x;

    function foo() external {
        require(msg.sender == owner);
        x += 1;
    }
}

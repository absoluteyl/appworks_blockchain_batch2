// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=7XwWBr4TAz4

contract Constructor {
    // constructor function only been executed once while contract is deployed
    address public owner;
    uint public x;

    constructor(uint _x) {
        owner = msg.sender;
        x = _x;
    }
}
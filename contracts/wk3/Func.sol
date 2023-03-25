// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FunctionIntro {
    // pure: read-only function
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }

    function sub(uint x, uint y) external pure returns (uint) {
        return x - y;
    }
}
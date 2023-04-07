// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=Ld8bFWXLSfs

contract IfElse {
    function exmaple(uint _x) external pure returns (uint) {
        if (_x < 10) {
            return 1;
        } else if (_x < 20) {
            return 2;
        } else {
            return 3;
        }
    }

    function ternary(uint _x) external pure returns (uint) {
        // if (_x < 10) {
        //     return 1;
        // }
        // return 2;
        // 👇 becomes
        return _x < 10 ? 1: 2;
    }
}
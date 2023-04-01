// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=ITxPOG9Djwc

// order of inheritance - most base-like to derived
/* 
Case1:
   X
 / |
Y  |
 \ |
   Z
*/
// order of most base-like to derived: X > Y > Z
contract X {
    function foo() public pure virtual returns (string memory) {
        return "X";
    }
    function bar() public pure virtual returns (string memory) {
        return "X";
    }
    function x() public pure returns (string memory) {
        return "X";
    }
}

contract Y is X {
    function foo() public pure virtual override returns (string memory) {
        return "Y";
    }
    function bar() public pure virtual override returns (string memory) {
        return "Y";
    }
    function y() public pure returns (string memory) {
        return "Y";
    }
}

contract Z is X, Y {
    function foo() public pure override(X, Y) returns (string memory) {
        return "Z";
    }
    function bar() public pure override(Y, X) returns (string memory) {
        return "Z";
    }
}

/* 
Case2:
   X
 /   \
Y     A
|     |
|     B
 \   /
   Z
*/
// order of most base-like to derived: X > Y = A > B > Z

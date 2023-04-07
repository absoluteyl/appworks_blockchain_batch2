// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
   A
 /   \
B     C
|     |
|     D
 \   /
   E
*/
// order of most base-like to derived: A > B = C > D > E
contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
    function bar() public pure virtual returns (string memory) {
        return "A";
    }
    function a() public pure returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
    function bar() public pure virtual override returns (string memory) {
        return "B";
    }
    function b() public pure returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
    function bar() public pure virtual override returns (string memory) {
        return "C";
    }
    function c() public pure returns (string memory) {
        return "C";
    }
}

contract D is A, C {
    function foo() public pure virtual override(A, C) returns (string memory) {
        return "D";
    }
    function bar() public pure virtual override(A, C) returns (string memory) {
        return "D";
    }
    function d() public pure returns (string memory) {
        return "D";
    }
}

contract E is A, B, C, D {
    function foo() public pure virtual override(A, B, C, D) returns (string memory) {
        return "E";
    }
    function bar() public pure virtual override(A, B, C, D) returns (string memory) {
        return "E";
    }
    function e() public pure returns (string memory) {
        return "E";
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=Ck5PUwL2D6I

contract A {
    // to define the function can be inherited and customized by child contract, we need to add "virtual"
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function bar() public pure virtual returns (string memory) {
        return "A";
    }

    // this function can be inheritad but cannot be customized
    function baz() public pure  returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure override returns (string memory) {
        return "B";
    }

    function bar() public pure virtual override returns (string memory) {
        return "B";
    }

    // If we add baz function in B, 
    // compile will fail because baz is not set to virtual
    // function baz() public pure override returns (string memory) {
    //     return "B";
    // }
}

contract C is B {
    function bar() public pure override returns (string memory) {
        return "C";
    }
}
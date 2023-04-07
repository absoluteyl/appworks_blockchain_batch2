// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=5Gxzwn0SQDU

contract LocalVariables {
    uint public i;
    bool public b;
    address public myAddr;

    function foo() external {
        uint x = 123;
        bool f = false;
        // more code
        x += 456;
        f = true;
        // after the function excuted, values of local variables will be gone.
        i = 123;
        b = true;
        myAddr = address(1);
    }
}
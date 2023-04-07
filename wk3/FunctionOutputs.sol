// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=je7dWT6bEZM

// Retrun multiple outputs
// Named outputs
// Destructuring Assignment

contract FunctionOutputs {
    // costs 479 gas
    function returnMany() public pure returns (uint, bool) {
        return (1, true);
    }

    // costs 457 gas
    function named() public pure returns (uint x, bool b) {
        return (1, true);
    }

    // costs 501 gas
    function assigned() public pure returns (uint x, bool b) {
        x = 1;
        b = true;
    }

    function destructingAssignments() public pure {
        // capturing outputs from a function
        (uint x, bool b) = returnMany();
        // ignore first output 
        (, bool _b) = returnMany();
        // ignore second output 
        (uint _x, ) = returnMany();
    }
}
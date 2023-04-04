// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=vOmXqJ4Qzbc

contract ViewAndPureFunctions {
    uint public num;
    // view function will only read data from blockchain
    function viewFunc() external view returns(uint) {
        return num;
    }

    // pure function will NOT read/write anything from blockchain
    function pureFund() external pure returns(uint) {
        return 506;
    }

    function addToNum(uint x) external view returns(uint) {
        return num + x;
    }

    function add(uint x, uint y) external pure returns(uint) {
        return x + y;
    }
}

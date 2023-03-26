// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=ryA86ZiSD-w

contract GlobalVariables {
    function globalVars() external view returns(address, uint, uint) {
        // view: read-only function, can read data from state variables or global variables.
        address sender = msg.sender;
        uint timestamp = block.timestamp;
        uint blockNum  = block.number;

        return (sender, timestamp, blockNum);
    }
}
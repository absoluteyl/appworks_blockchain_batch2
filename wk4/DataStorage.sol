// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataStorage {
    address public owner;
    uint public x;
    string public str;
    string public str2;

    constructor(uint _x) {
        owner = msg.sender;
        x = _x;
    }

    function takeCallData(string calldata _string) external {
        str = _string;
    }

    // if we call takeCallData first then takeMemory,
    // when variable - str is reuse in takeMemory, it would cost less gas since the storage slot is already
    // initiated in takeCallData. But if we use a new variable - str2, the gas cost of initiate storage slot
    // by data in memory is higher then initiate storage slot by calldata because there's an additional step
    // to copy calldata value into memory.

    function takeMemory(string memory _string) external {
        str = _string;
        // str2 = _string;
    }
}

// Test contract for storage slot
contract Slot {
    // This uint256 will be stored in slot0
    uint i = 10;
    function integer() public view returns(uint) {
        return i;
    }
    // we can use web3.js to retrive data from specific slot
    // web3.eth.getStorageAt("0xdf710e103510d4eb23cdf53ebcaf0aa8844a2bbd", 0, console.log)
}

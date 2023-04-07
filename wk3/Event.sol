// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=nopo9KwwRg4

// Event can stores data on the blockchain but not able to retrive
contract Event {
    event Log(string message, uint val);
    event IndexedLog(address indexed sender, uint val);
    // note: up to 3 index can be added in event

    // Transactional function
    function example() external {
        emit Log("foo", 506);
        emit IndexedLog(msg.sender, 579);
    }

    event Message(address indexed _from, address indexed _to, string message);
    function sendMessage(address _to, string calldata message) external {
        emit Message(msg.sender, _to, message);
    }
}
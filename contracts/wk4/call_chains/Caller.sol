// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ICallee {
    function getData() external;
}

contract Caller {
    address public sender;
    address public origin;

    function getDataFromCallee(address _callee) public {
        ICallee(_callee).getData();
        
        sender = msg.sender;
        origin = tx.origin;
    }
}

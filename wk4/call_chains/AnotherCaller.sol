// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ICaller {
    function getDataFromCallee(address _callee) external;
}

contract AnotherCaller {
    address public sender;
    address public origin;

    function getDataFromCaller(address _caller, address _callee) public {
        ICaller(_caller).getDataFromCallee(_callee);

        sender = msg.sender;
        origin = tx.origin;
    }
}
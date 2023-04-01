// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Callee {
    address public sender;
    address public origin;

    function getData() external {
        sender = msg.sender;
        origin = tx.origin;
    }
}

interface ICallee {
    function sender() external view returns(address);
    function origin() external view returns(address);
    function getData() external;
}

contract Caller {
    struct Addrs {
        address calleeSender;
        address calleeOrigin;
        address thisSender;
        address thisOrigin;
    }

    Addrs public addrs;

    function getDataFromCallee(address _callee) public {
        ICallee(_callee).getData();
        addrs.calleeSender = ICallee(_callee).sender();
        addrs.calleeOrigin = ICallee(_callee).origin();
        addrs.thisSender = msg.sender;
        addrs.thisOrigin = tx.origin;
    }
}
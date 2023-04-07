// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=ajCsPRl5S3Q

// selfdestruct
// - delete contract
// - force send Ether to any address
contract Kill {
    constructor () payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function test() external pure returns(uint) {
        return 506;
    }
}

contract Helper {
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
    
    function kill(Kill _kill) external {
        _kill.kill();
    }
}

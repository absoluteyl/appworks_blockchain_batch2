// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=b6FBWsz7VaI

// Function modifier - reuse code before and/or after function
// Basic, input, sandwich

contract FunctionModifier {
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    // Basic modifier
    modifier whenNotPaused() {
        require(!paused, "Paused");
        
        // let solidity to execute code in the function who calls this modifier
        _; 
    }

    function inc() external whenNotPaused {
        count += 1; 
    }

    function dec() external whenNotPaused {
        count -= 1; 
    }

    // Modifier takes input
    modifier cap(uint _x) {
        require(_x < 100, "x >= 100");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }

    // Modifier wraps the function
    modifier sandwich() {
        count += 10;
        _;
        count *= 2;
    }

    function foo() external sandwich {
        count +=1;
    }
}

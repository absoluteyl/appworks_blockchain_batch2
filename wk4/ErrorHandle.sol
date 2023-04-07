// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=59MRDldSItU

// require, revert, assert
// gas refund, state updates are reverted
// use custom error to save gas
contract ErrorHandle {
    function testRequire(uint _i) public pure {
        require( _i <= 10, "i is greater than 10");
    }

    // revert is better when want to revert all operations within function
    function testRevret(uint _i) public pure {
        if (_i > 10) {
            revert("i is greater than 10");
        }
    }

    uint public num = 123;

    // assert is use to check if the given condition is always true;
    function testAssert() public view {
        assert(num == 123);
    }

    // if input _i is greater than 10, addtion to num will be reverted and num still equals to 123.
    // so testAssert() will still be true.
    // but if _i is less or equal to 10, num will become 124.
    // testAssert() will fail
    function foo(uint _i) public {
        num += 1;
        require(_i < 10);
    }

    // custom error with longer error msg will cost more gas
    function testCustomError(uint _i) public pure {
        // using require, no error msg
        require(_i <= 10);
    }
    // consumed 470 gas

    function testCustomError2(uint _i) public pure {
        // using require, long error msg
        require(_i <= 10, "a very very very very very long error message.");
    }
    // consumed 737 gas

    error MyError();
    error MyError2(string str);

    function testCustomError3(uint _i) public pure {
        // using revert, so we could use customer error
        if (_i > 10) {
            revert MyError();
            // revert MyError2("a very very very very very long error message.");
        }
    }
    // consumed 510 gas with MyError
    // consumed 782 gas with MyError2
}
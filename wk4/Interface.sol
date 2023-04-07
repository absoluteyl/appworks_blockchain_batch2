// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=tbjyc-VQaQo

contract Counter {
    // 沒給起始值的 uint, 第一次呼叫時要 create storage slot 會花比較多 gas
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }

    // 有給起始值的 uint, 第一次呼叫時只要 update storage slot 會花比較少 gas
    uint public count2 = 1;

    function inc2() external {
        count2 += 1;
    }

    function dec2() external {
        count2 -= 1;
    }
}

interface ICounter {
    function count()  external view returns (uint);
    function count2() external view returns (uint);
    function inc()  external;
    function inc2() external;
    function dec()  external;
    function dec2() external;
}

contract CallInterface {
    uint public count;
    uint public count2;

    function examples(address _counter) external {
        ICounter(_counter).inc();
        count = ICounter(_counter).count();
    }
    // consumed 80789 gas for first call
    // consumed 41459 gas for later calls

    function examples2(address _counter) external {
        ICounter(_counter).inc2();
        count2 = ICounter(_counter).count2();
    }
    // consumed 61175 gas for first call
    // consumed 41510 gas for later calls 
}





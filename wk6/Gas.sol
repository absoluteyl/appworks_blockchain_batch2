// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SaveGas {
  // access memory is cheaper than access storage
  uint public someStorageData;
  uint public n = 5;

  function foo() public {
    // access data from storage
    someStorageData;

    // access data from memory
    uint someMemoryData = 123;

    // to reduce gas cost, we can store data in memory to avoid multiple access to storage
    uint cache = someStorageData;
  }

  function noCache() external view returns (uint) {
    uint s = 0;
    for (uint i = 0; i < n; i++) {
      s += i;
    }
    return s;
  }

  function withCache() external view returns (uint) {
    uint s = 0;
    uint cache = n;
    for (uint i = 0; i < cache; i++) {
      s += i;
    }
    return s;
  }

}

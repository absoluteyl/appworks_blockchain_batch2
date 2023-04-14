// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=Mn4e4w8h6n8
contract FunctionSelector {
  function getSelector(string calldata _func) external pure returns(bytes4) {
    return bytes4(keccak256(bytes(_func)));
  }
}

contract Receiver {
  event Log(bytes data);

  function transfer(address _to, uint _amount) external {
    emit Log(msg.data);
    // 0xa9059cbb - first 4 bytes are functino selector
    // 000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2
    // 000000000000000000000000000000000000000000000000000000000000007b
  }
  /*
  [
    {
      "from": "0x358AA13c52544ECCEF6B0ADD0f801012ADAD5eE3",
      "topic": "0xafabcf2dd47e06a477a89e49c03f8ebe8e0a7e94f775b25bbb24227c9d0110b2",
      "event": "Log",
      "args": {
        "0": "0xa9059cbb000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2000000000000000000000000000000000000000000000000000000000000007b",
        "data": "0xa9059cbb000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2000000000000000000000000000000000000000000000000000000000000007b"
      }
    }
  ]
  */
}

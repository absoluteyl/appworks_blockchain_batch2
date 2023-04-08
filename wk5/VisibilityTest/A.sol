// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
  // 部署後無法呼叫
  uint private  x = 111;
  uint internal y = 222;

  // 部署後可呼叫
  uint public   z = 333;

  // 部署後無法呼叫
  function privateFunc() private pure returns(uint) {
    return 0;
  }
  function internalFunc() internal pure returns(uint) {
    return 100;
  }

  // 部署後可呼叫
  function publicFunc() public pure returns(uint) {
    return 200;
  }
  function externalFunc() external pure returns(uint) {
    return 300;
  }
}

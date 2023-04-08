// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./A.sol";

contract B is A {
  // B 無法調用 x
  function getX() external view returns(uint) {
    // 嘗試 1:
    // return x;
    // Compile Error: undefined identifier

    // 嘗試 2:
    // return A.x;
    // Compile Error: Member "x" not found or not visible after argument-dependent lookup in type(contract A).
  }

  // B 本身可調用 y
  // 但若要從外部透過 B 取到 y 的值就必須多做一個 function 作為 interface
  function getY() external view returns(uint) {
    return y;
  }

  // 從外部可直接透過 contract B 呼叫 z，不需要透過 function
  function getZ() external view returns(uint) {
    return z;
  }

  // B 無法調用 privateFunc
  function getPrivateFunc() external pure returns(uint) {
    // 嘗試 1:
    // return privateFunc();
    // Compile Error: undefined identifier

    // 嘗試 2:
    // return A.privateFunc();
    // Compile Error: Member "privateFunc" not found or not visible after argument-dependent lookup in type(contract A).
  }

  // B 本身可調用 internalFunc
  // 但若要從外部透過 B 取到 internalFunc 的值就必須多做一個 function 作為 interface
  function getInternalFunc() external pure returns(uint) {
    return internalFunc();
  }

  // 從外部可直接透過 contract B 呼叫 publicFunc，不需要透過 function
  function getPublicFunc() external pure returns(uint) {
    return publicFunc();
  }


  // 從外部可直接透過 contract B 呼叫 externalFunc，不需要透過 function
  // 但 B 本身無法調用 externalFunc, 需要加上 this 讓呼叫從外部進來才能調用
  function getExternalFunc() external view returns(uint) {
    // 嘗試 1:
    // return externalFunc();
    // Compile Error: undefined identifier

    // 嘗試 2:
    // return A.externalFunc();
    // Compile Error: Cannot call function via contract type name.

    // 嘗試 3:
    return this.externalFunc();
  }
}

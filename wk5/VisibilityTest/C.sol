// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IA {
  function x() external view returns(uint);
  function y() external view returns(uint);
  function z() external view returns(uint);

  function privateFunc() external pure returns(uint);
  function internalFunc() external pure returns(uint);
  function publicFunc() external pure returns(uint);
  function externalFunc() external pure returns(uint);
}

interface IB {
  function y() external view returns(uint);
  function z() external view returns(uint);

  function internalFunc() external pure returns(uint);
  function publicFunc() external pure returns(uint);
  function externalFunc() external pure returns(uint);
}

contract C {
  // Interact with A
  // Failed Call
  function getXFromA(address _a) external view returns(uint) {
    return IA(_a).x();
  }
  // Failed Call
  function getYFromA(address _a) external view returns(uint) {
    return IA(_a).y();
  }
  // Success Call, consumed 6206 gas
  function getZFromA(address _a) external view returns(uint) {
    return IA(_a).z();
  }

  // Failed Call
  function getPrivateFuncFromA(address _a) external pure returns(uint) {
    return IA(_a).privateFunc();
  }
  // Failed Call
  function getInternalFuncFromA(address _a) external pure returns(uint) {
    return IA(_a).internalFunc();
  }
  // Success Call, consumed 4004 gas
  function getPublicFuncFromA(address _a) external pure returns(uint) {
    return IA(_a).publicFunc();
  }
  // Success Call, consumed 3961 gas
  function getExternalFuncFromA(address _a) external pure returns(uint) {
    return IA(_a).externalFunc();
  }

  // Interact with B
  // Failed Call
  function getYFromB(address _b) external view returns(uint) {
    return IB(_b).y();
  }
  // Success Call, consumed 6184 gas
  function getZFromB(address _b) external view returns(uint) {
    return IB(_b).z();
  }

  // Failed Call
  function getInternalFuncFromB(address _b) external pure returns(uint) {
    return IB(_b).internalFunc();
  }
  // Success Call, consumed 4116 gas
  function getPublicFuncFromB(address _b) external pure returns(uint) {
    return IB(_b).publicFunc();
  }
  // Success Call, consumed 4138 gas
  function getExternalFuncFromB(address _b) external pure returns(uint) {
    return IB(_b).externalFunc();
  }
}

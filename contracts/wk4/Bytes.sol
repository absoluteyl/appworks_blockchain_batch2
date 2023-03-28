// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Bytes {
    bytes public b;
    bytes32 public b32;
    bytes1 public b1;

    function setBytes(bytes memory _bytes) external {
        b = _bytes;
    }

    function setBytes32(bytes32 _bytes) external {
        b32 = bytes32(_bytes);
    }

    function setBytes1(bytes1 _bytes) external {
        b1 = bytes1(_bytes);
    } 
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=wCD3fOlsGc4

contract HashFunc {
    function hash(string memory text, uint num, address addr) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }

    // abi.encode: encode data into bytes
    // abi.encodePacked: encode data into bytes and compress it, output is smaller and reduce some information in it.
    function encode(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encode(text0, text1);
    }

    // for encodePacked, outputs like "aaa","bbb" compare to "aa","abbb" will be the same 
    // since the combination of these 2 strins are both "aaabbb"
    function encodePacked(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encodePacked(text0, text1);
    }

    function collision(string memory text0, string memory text1) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text0, text1));
    }

    // To avoid hash collision, use abi.encode instead
    function notCollision(string memory text0, string memory text1) external pure returns (bytes32) {
        return keccak256(abi.encode(text0, text1));
    }

    // Or just add a variable of another datatype in between
    function alsoNotCollision(string memory text0, uint x, string memory text1) external pure returns (bytes32) {
        return keccak256(abi.encode(text0, x, text1));
    }
}
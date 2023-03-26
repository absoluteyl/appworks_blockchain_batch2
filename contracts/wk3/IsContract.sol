//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// deplyed link: https://sepolia.etherscan.io/address/0xd3b2f99c8740eacae493aec3ddf1db93cc5e1a9a
contract IsContract {
    function isContract(address _address) public view returns (bool) {
        uint size;
        assembly { size := extcodesize(_address) }
        return size != 0;
    }
}

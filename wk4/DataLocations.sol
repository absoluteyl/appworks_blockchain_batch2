// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=wOCIhzAuhgs

// Data Locations - storage, memory, calldata
contract DataLocations {
    struct MyStruct {
        uint foo;
        string text;
    }

    mapping (address => MyStruct) public myStructs;

    function examples() external returns (MyStruct memory) {
        // value will be stored into storage directly when given
        myStructs[msg.sender] = MyStruct({foo: 123, text: "aloha"});

        // retrive myStruct object with value stored on blockchain from specific address
        // use storage when want to manipulate the value inside storage
        MyStruct storage myStruct = myStructs[msg.sender];
        // assign value to this variable will change value stored on blockchain
        myStruct.text = "hello";

        // retrive the same data again, but assign it to memory
        // use memory when just want to read the value inside storage
        MyStruct memory readOnly = myStructs[msg.sender];
        // assign value to this variable will NOT change value stored on blockchain
        readOnly.text = "bonjour";

        return readOnly;
    }

    // input variables from memory (which are copied from calldata)
    function examples2(uint[] memory y, string memory s) external returns (uint[] memory) {
        // Arrays which initialized in memory can only be a fixed-size array.
        uint[] memory memArr = new uint[](3);
        uint x = y[0];

        memArr[0] = x;
        return memArr;
    }
    // gas consumed: 29112

    // input variables from calldata
    function examples3(uint[] calldata y, string calldata s) external returns (uint[] memory) {
        // Arrays which initialized in memory can only be a fixed-size array.
        uint[] memory memArr = new uint[](3);
        uint x = y[0];

        memArr[0] = x;
        return memArr;
    }
    // gas consumed: 27835
}

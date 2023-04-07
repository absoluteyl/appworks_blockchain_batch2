// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=OH5mafV6jVE

library Math {
    // note: declare a state variable in library is not allowed
    
    // Function visibility of a library:
    // Public: will have to deploy library on blockchain seperately before a contract can call it.
    // Private: not an option because only the library can call this function.
    // External: when using library inside a contract, it's not an option.
    // Internal: will be embeded in the contract simultaneously while deploying the contract.
    function max(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x : y;
    }
}

contract Test {
    function testMax(uint x, uint y) external pure returns (uint) {
        return Math.max(x, y);
    }
}

library ArrayLib {
    function find(uint[] storage arr, uint x) internal view returns (uint) {
        for(uint i = 0; i < arr.length; i++) {
            if(arr[i] == x) {
                return i;
            }
        }
        revert("not found");
    }
}

contract TestArray {
    using ArrayLib for uint[];
    uint[] public arr = [3, 2, 1];

    function testFind(uint x) external view returns (uint i) {
        // return ArrayLib.find(arr, 2);
        return arr.find(x); // while declare using ArrayLib above, we can use syntax like this.
    }
}
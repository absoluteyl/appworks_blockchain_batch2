// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=vTxxCbwMPwo

// Array - dynamic or fixed size
contract Array {
    // Initialize dynamic array
    uint[]  public nums = [1, 2, 3];
    // Initialize fixed array
    uint[3] public fixedNums = [4, 5, 6]; // will show compile error if numbers of elements exceed array size

    function examples() external {
        // Insert (push), get, update, delete, pop, length

        // insert element to the last
        nums.push(4); // [1, 2, 3, 4]

        // get value of specific element from array
        uint x = nums[1]; // x is 2
        
        // update value of specific element in array
        nums[2] = 506; // [1, 2, 506, 4] 
        

        // delete value of specific element in array,
        // IMPORTANT: elements behind targeted element will not shift, instead the value targeted element becomes default value - 0
        delete nums[1]; // [1, 0, 506, 4]

        // remove last element of the array
        nums.pop(); // [1, 0, 506]

        // get length of array
        uint len = nums.length;

        // Creating array in memory (MUST be a fixed array)
        uint[] memory a = new uint[](5); // size of a is 5

        // pop/push of fixed array is not available
        // a.pop(); 
        // fixedNums.push();

        // we can only update values in fixed array
        a[1] = 234;

        // Retruning array from function
        // returning array is not recommanded since it will consume a lot of gas if the array is large
        function returnArray() external view returns (uint[] memory) {
            return nums;
        }
    }
}
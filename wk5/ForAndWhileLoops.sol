// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=SB705OK3bUg

contract ForAndWhileLoops {
  function loops() external pure {
    for (uint i = 0; i < 10; i++) {
      if (i == 3) {
        continue; // skip to the next loop
      }

      if (i == 5) {
        break; // completely break the loop
      }
    }

    uint j = 0;
    while (j < 10) {
      j++;
    }
  }

  function sum(uint _n) external pure returns(uint) {
    uint s;
    for (uint i = 1; i <= _n; i++) { // loop 次數會影響消耗的 gas, 因此 loop 次數越少越好
        s += i;
    }
    return s;
  }
}

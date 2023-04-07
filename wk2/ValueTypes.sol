// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=8Tj-Th_S7NU
// deployed link: https://goerli.etherscan.io/address/0x8f36bb1511424fe2032183834465c2153fc93299

// Data types - values and references
contract ValueTypes {
  bool public b = true;
  uint public u = 506; // uint = uint256 0 to (2**256 - 1)
                       //        uint8   0 to (2**8 - 1)
                       //        uint16  0 to (2**16 - 1)
  int public i = -506; // int  = int256  -2**255 to 2**255 -1
                       //        int128  -2**127 to 2**127 -1
  int public minInt = type(int).min;
  int public maxInt = type(int).max;
  address public addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  bytes32 public b32 = 0xaff305b17e972d8c8bc09a96e4b6d7471435dcb0e5e21a073b94192a67918733;
}

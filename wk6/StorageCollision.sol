// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract AnotherA {
  uint256 public a = 0;
  uint16 public b = 257;
  uint8 public c = 123;
  // slot0: 0x00000000000000000000000000000000
  // slot1: 0x00000000000000000000000000 7B 0101
  //                                    └─┘ └───┘
  //                                     c     b
  function setA(uint256 newA, uint16 newB, uint8 newC) external {
    a = newA;
    b = newB;
    c = newC;
  }
}

contract AnotherB {
  uint256 public amount;
  uint8 public bb;
  uint16 public cc;
  function callSetA(address a) external {
    bytes memory hash = abi.encodeWithSignature("setA(uint256,uint16,uint8)", 10, 20, 30);
    (bool success,) = a.delegatecall(hash);
    require(success);
  }
  // slot0: 0x0000000000000000000000000000000A
  // slot1: 0x00000000000000000000000000 1E00 14
  //                                    └───┘ └─┘
  //                                     cc   bb
  //                                     7680  20
  // 原本在 contract A 中的 b 跟 c 分別是 uint16 跟 uint8，
  // 但是在 contract B 中，bb 跟 cc 分別是 uint8 和 uint16，
  // 所以 bb 的前兩位會被覆蓋掉，變成 0x14，造成 cc 變成 0x1E00
}

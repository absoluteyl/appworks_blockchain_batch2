// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 課堂 Hands-on: https://docs.google.com/presentation/d/1SALwP1v5g8MVXZXRlDdNnTmPk2FwTO_NcgzoMLF0QWM/edit#slide=id.g212e2a85d9e_0_41
// abi.encode、abi.decode 的使用方法
// abi.encode 和 abi.encodePacked 的差異
// abi.encodeWithSignature 和 abi.encodeWithSelector 的差異和使用時機
contract Abi {
  uint8 i = 10;
  address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  uint[2] arr = [1, 257];
  string str = "Hello World";

  // 把每個參數編碼成 32bytes 長的 hex 後 join 在一起，通常用在跟其他 contract 互動時
  function encode() public view returns (bytes memory) {
    return abi.encode(i, addr, arr, str);
  }
  // Output: "0x
  // 000000000000000000000000000000000000000000000000000000000000000a  ← i (10)
  // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4  ← addr (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
  // 0000000000000000000000000000000000000000000000000000000000000001  ← arr[0] (1)
  // 0000000000000000000000000000000000000000000000000000000000000101  ← arr[1] (257)
  // 00000000000000000000000000000000000000000000000000000000000000a0  ← str offset (160)
  // 000000000000000000000000000000000000000000000000000000000000000b  ← str length (11)
  // 48656c6c6f20576f726c64000000000000000000000000000000000000000000" ← str (Hello World)

  // 很簡單，就是把 encode 的結果 decode 回來
  function decode(bytes memory _data) public pure returns (uint8, address, uint[2] memory, string memory) {
    return abi.decode(_data, (uint8, address, uint[2], string));
  }
  // Output: (10, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, [1, 257], "Hello World")

  // 將每個參數用最低限度的長度編碼後 join 在一起，通常用在 hash 的計算上
  function encodePacked() public view returns (bytes memory) {
    return abi.encodePacked(i, addr, arr, str);
  }
  // Output: "0x
  // 0a                                                               ← i (10)，只保留 uint 一開始被指定的大小 (8 bits)
  // 5b38da6a701c568545dcfcb03fcb875f56beddc4                         ← addr (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
  // 0000000000000000000000000000000000000000000000000000000000000001 ← arr[0] (1)
  // 0000000000000000000000000000000000000000000000000000000000000101 ← arr[1] (257)
  // 48656c6c6f20576f726c64"                                          ← str (Hello World)，string 省去了 offset 和 length

  // 和 encode 很類似，只是第一個參數是 function signature，通常用來 call 其他合約。
  function encodeWithSignature() public view returns (bytes memory) {
    return abi.encodeWithSignature("foo(uint8,address,uint256[2],string)", i, addr, arr, str);
  }
  // Output: "0x
  // 782625b8                                                          ← function signature (foo(uint8,string))
  // 000000000000000000000000000000000000000000000000000000000000000a  ← i (10)
  // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4  ← addr (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
  // 0000000000000000000000000000000000000000000000000000000000000001  ← arr[0] (1)
  // 0000000000000000000000000000000000000000000000000000000000000101  ← arr[1] (257)
  // 00000000000000000000000000000000000000000000000000000000000000a0  ← str offset (160)
  // 000000000000000000000000000000000000000000000000000000000000000b  ← str length (11)
  // 48656c6c6f20576f726c64000000000000000000000000000000000000000000" ← str (Hello World)


  // 和 encodeWithSignature 很類似，只是第一個參數就要先把 function signature 轉成 function selector 後再傳入
  // output 也和 encodeWithSignature 一樣。
  function encodeWithSelector() public view returns (bytes memory) {
    return abi.encodeWithSelector(bytes4(keccak256("foo(uint8,address,uint256[2],string)")), i, addr, arr, str);
  }
  // Output: "0x
  // 782625b8                                                         ← function selector (782625b8)
  // 000000000000000000000000000000000000000000000000000000000000000a ← i (10)
  // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4 ← addr (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
  // 0000000000000000000000000000000000000000000000000000000000000001 ← arr[0] (1)
  // 0000000000000000000000000000000000000000000000000000000000000101 ← arr[1] (257)
  // 00000000000000000000000000000000000000000000000000000000000000a0 ← str offset (160)
  // 000000000000000000000000000000000000000000000000000000000000000b ← str length (11)
  // 48656c6c6f20576f726c64000000000000000000000000000000000000000000 ← str (Hello World)
}

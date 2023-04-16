// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lupin{
  // 不想用 Ownable 因為叫 Lupin 比較屁
  address public lupin;
  address public target;

  string public passwordForEncode = "appworks.school.4/10.encode";

  struct Payment {
    address receiver;
    uint256 amount;
  }

  struct DecodePassword {
    uint256 a;
    bytes1  b;
    string  c;
    bytes32 d;
    uint128 e;
  }
  DecodePassword public passwordForDecode;

  constructor() {
    lupin = msg.sender;
    target = 0x4Ba9e675f6B21014B698A06Eb3E8f885513ff151;
  }

  // 鎖定下手目標
  function setTargetContract(address _target) external {
    require(msg.sender == lupin, "Only Lupin can decide who's target");
    target = _target;
  }

  // 試組 reqData 用
  function composeEncodePassword() public view returns (bytes memory reqData){
    // ❌ bytes32 encodePassword = keccak256(abi.encodePacked(passwordForEncode));
    // 0x
    // 000000000000000000000000d9145cce52d386f254917e481eb44e9943f39138
    // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    // 00000000000000000000000000000000000000000000000003782dace9d90000
    // 0b03fc196d8adb815dacdfcfb341086695487dedda09b9d15357630ad78f99d6

    // ❌ bytes32 encodePassword = keccak256(abi.encode(passwordForEncode));
    // 0x
    // 000000000000000000000000d8b934580fce35a11b58c6d73adee468a2833fa8
    // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    // 00000000000000000000000000000000000000000000000003782dace9d90000
    // 70f8b2d988dc77b1a3c5374fa4253b0749b300d483e0aba69897818d4113bae4
    bytes32 encodePassword = bytes32(abi.encodePacked(passwordForEncode));
    // 0x
    // 0000000000000000000000007ef2e0048f5baede046f6bf797943daf4ed8cb47
    // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    // 00000000000000000000000000000000000000000000000003782dace9d90000
    // 617070776f726b732e7363686f6f6c2e342f31302e656e636f64650000000000
    reqData = abi.encode(
      address(this),
      Payment(msg.sender, 0.25 ether),
      encodePassword
    );
  }

  function stealWithEncodePassword() external {
    // 準備一下 Data
    bytes32 encodePassword = bytes32(abi.encodePacked(passwordForEncode));
    bytes memory reqData = abi.encode(
      address(this),
      Payment(msg.sender, 0.25 ether),
      encodePassword
    );
    // 下手了！
    (bool success,) = target.call(
      abi.encodeWithSignature("submitEncodeData(bytes)", reqData)
    );
    // 確認是否有偷到
    require(success, "You failed to encode, Lupin!");
  }

  // Target 被偷到後會給我們下一把鑰匙
  function revealDecodePassword(bytes calldata data) external {
    (
      passwordForDecode.a,
      passwordForDecode.b,
      passwordForDecode.c,
      passwordForDecode.d,
      passwordForDecode.e
    ) = abi.decode(data, (uint256, bytes1, string, bytes32, uint128));
    stealWithDecodePassword();
  }

  // 試組 reqData 用
  function composeDecodePassword() public view returns (bytes32 reqData){
    // ❌ keccak256(abi.encodePacked(
    //   passwordForDecode.a,
    //   passwordForDecode.b,
    //   passwordForDecode.c,
    //   passwordForDecode.d,
    //   passwordForDecode.e
    // ));
    // 0x3086579da3e483b029bfb43477b5a299ed718ce377383078c5ce860495b50ad8

    // ❌ keccak256(abi.encode(
    //   passwordForDecode.a,
    //   passwordForDecode.b,
    //   passwordForDecode.c,
    //   passwordForDecode.d,
    //   passwordForDecode.e
    // ));
    // 0xb2153c37cf0d3c450f805fe8327ab2ff6fcbfe6aef49389b70d32de6068d428a

    // 發現 passwordForDecode.d 是 hex 過後的字串
    reqData = bytes32(abi.encodePacked(passwordForDecode.d));
    // 0x617070776f726b732e7363686f6f6c2e342f31302e6465636f64650000000000
  }

  // 用剛剛拿到的鑰匙再偷一次
  function stealWithDecodePassword() public {
    // 準備一下 Data
    bytes32 reqData = bytes32(abi.encodePacked(passwordForDecode.d));
    // 下手了！
    (bool success,) = target.call(
      abi.encodeWithSignature("submitDecodeData(bytes32)", reqData)
    );
    // 確認是否有偷到
    require(success, "You failed to decode, Lupin!");
  }

  function kill() external {
    require(msg.sender == lupin);
    selfdestruct(payable(msg.sender));
  }

  receive() external payable {}
}

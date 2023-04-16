// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

////////////////////////
// 下手前先觀察 Target  //
////////////////////////

import { Ownable } from "openzeppelin-contracts/access/Ownable.sol";
import { Address } from "openzeppelin-contracts/utils/Address.sol";
import "forge-std/console.sol";

contract AbiEncodeDecode is Ownable {

  using Address for address;

  struct Payment {
    address receiver;
    uint256 amount;
  }

  // 測試用
  // struct DecodePassword {
  //   uint256 a;
  //   bytes1 b;
  //   string c;
  //   bytes32 d;
  //   uint128 e;
  // }
  // DecodePassword public dpass;

  // constructor() {
  //   dpass.a = 1681658184;
  //   dpass.b = 0x10;
  //   dpass.c = "YOU ARE A HUGE SUCCESS";
  //   dpass.d = 0x617070776f726b732e7363686f6f6c2e342f31302e6465636f64650000000000; // appworks.school.4/10.decode
  //   dpass.e = 3735928559;
  // }

  uint256 constant public REWARD = 0.25 ether;

  address private password;

  function setPasswordContract(address _password) external onlyOwner {
    password = _password;
  }

  function submitEncodeData(bytes calldata data) external {
    // 把 data decode 成 (address, Payment, bytes32) 三個參數，所以 Lupin 也要把 data encode 成這樣
    (address sender, Payment memory payment, bytes32 _password) = abi.decode(data, (address, Payment, bytes32));

    // 從 password contract 拉 EncodePassword 來比對是否正確
    (, bytes memory rawPassword) = password.call(abi.encodeWithSignature("getEncodePassword()"));
    // 依據 rawPassword 要用 bytes32 decode，猜測 password contract 在做的事可能是：
    // ❌ encodePassword = keccak256(abi.encodePacked("appworks.school.4/10.encode"));
    // ❌ encodePassword = keccak256(abi.encode("appworks.school.4/10.encode"));
    // ⭕️ encodePassword = bytes32(abi.encodePacked("appworks.school.4/10.encode"));
    bytes32 encodePassword = abi.decode(rawPassword, (bytes32));

    require(sender == msg.sender); // sender 要是 Lupin address
    require(encodePassword == _password); // 密碼當然也要對
    require(payment.amount <= REWARD);  // 不能一次偷太多

    // 再從 password contract 拿 decodePassword
    (, bytes memory decodePassword) = password.call(abi.encodeWithSignature("getMaskedDecodePassword()"));
    // decodePassword 是 bytes 格式，這邊還要讓 Lupin 解開，所以一定只有做 encode
    // bytes memory decodePassword = abi.encode(dpass.a, dpass.b, dpass.c, dpass.d, dpass.e);
    decodePassword = abi.decode(decodePassword, (bytes));
    bool success;
    if (sender.isContract()) {
      // the format of decodePassword is uint256, bytes1, string, bytes32, uint128
      (success, ) = sender.call(abi.encodeWithSignature("revealDecodePassword(bytes)", decodePassword));
      require(success);
    }
    (success, ) = payment.receiver.call{ value: payment.amount }("");
    require(success);
  }

  // 這邊的 hint 只有要傳 bytes32 的 data 而已
  function submitDecodeData(bytes32 data) external {
    (, bytes memory rawPassword) = password.call(abi.encodeWithSignature("getDecodePassword()"));
    // 依據 rawPassword 要用 bytes32 decode，猜測 password contract 在做的事可能是：
    // ❌ rawPassword = keccak256(abi.encodePacked(dpass.a, dpass.b, dpass.c, dpass.d, dpass.e));
    // ❌ rawPassword = keccak256(abi.encode(dpass.a, dpass.b, dpass.c, dpass.d, dpass.e));
    // ⭕️ bytes32(abi.encodePacked(dpass.d))
    bytes32 decodePassword = abi.decode(rawPassword, (bytes32));
    require(data == decodePassword, "wrong decode password");
    (bool success, ) = msg.sender.call{ value: REWARD }("");
    require(success);
  }

  function kill() external onlyOwner {
    selfdestruct(payable(msg.sender));
  }

  receive() external payable {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 驗證簽章的流程
// 0. 產生要 sign 的資料
// 1. 對資料做 keccak256 hash： hash(message)
// 2. 在鏈下簽署 hash 過的資料： sign(hash(message), private key)
// 3. 鏈上收到 signature 的結點驗證簽章跟資料內容：ecrecover(hash(message), signature) == signer
contract VerifySig {

  function verify(
    address _signer,
    string memory _message,
    bytes memory _sig
  ) external pure returns (bool) {
    // 對資料做 keccak256 hash： hash(message)
    bytes32 messageHash = getMessageHash(_message);
    // 在鏈下簽署 hash 過的資料： sign(hash(message), private key)
    bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

    // 鏈上收到 signature 的結點驗證簽章跟資料內容：ecrecover(hash(message), signature) == signer
    return recover(ethSignedMessageHash, _sig) == _signer;
  }

  function getMessageHash(string memory _message) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(_message));
  }

  function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(
      "\x19Ethereum Signed Message:\n32",
      _messageHash
    ));
  }

  function recover(
    bytes32 _ethSignedMessageHash,
    bytes memory _sig
  ) public pure returns (address) {
    (bytes32 r, bytes32 s, uint8 v) = _splitSignature(_sig);
    return ecrecover(_ethSignedMessageHash, v, r, s);
  }

  function _splitSignature(bytes memory _sig) internal pure returns (
    bytes32 r, bytes32 s, uint8 v
  ) {
    require(_sig.length == 65, "invalid signature length");

    // _sig 只是 pointer，所以要用 mload 來取值
    // _sig 的前 32 bytes 是 signature 本身的 length，所以要從 32 bytes 後開始取值
    assembly {
      r := mload(add(_sig, 32))
      s := mload(add(_sig, 64))
      v := byte(0, mload(add(_sig, 96)))
    }
    // return (r, s, v); // 不用真的寫 return，因為 assembly 已經把值放到 r, s, v 了
  }
}

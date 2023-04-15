// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CallerContractInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EthPriceOracle is Ownable {
  // 用來產 request ID 的 nonce
  uint private randNonce = 0;
  uint private modulus = 1000;

  mapping(uint256=>bool) pendingRequests;

  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);

  function getLatestEthPrice() public returns (uint256) {
    randNonce++;
    // 產生一個隨機的 request ID
    // 注意原本 cryptozombies 是用 now 來產生，但是 now 已經被棄用了，要改用 block.timestamp
    uint id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    // 將 request ID 加入 pendingRequests
    pendingRequests[id] = true;
    // 留個 Log
    emit GetLatestEthPriceEvent(msg.sender, id);
    // 回傳 request ID
    return id;
  }

  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public onlyOwner {
    // 檢查 request ID 是否存在
    require(pendingRequests[_id], "This request is not in my pending list.");
    // 將請求從 mapping 中移除
    delete pendingRequests[_id];

    // 因為要打 Caller Contract 的 callback(), 要先 init 一個 CallerContractInstance
    CallerContractInterface callerContractInstance;
    callerContractInstance = CallerContractInterface(_callerAddress);

    // 將 ETH 價格傳給 caller contract
    callerContractInstance.callback(_ethPrice, _id);

    // 留個 Log
    emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
  }
}

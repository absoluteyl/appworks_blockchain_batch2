// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Fallback function is executed when:
//   - the function been called doesn't exist inside contract
//   - enable direct sending Ether

// Receive, Fallback
// 假設一個有 Receive 跟 Payable Fallback 的合約中：
// 交易的 msg.data 非空值且 value == 0的話，Receive or Fallback ? Fallback
// 交易的 msg.data 非空值且 value != 0的話，Receive or Fallback ? Fallback
// 交易的 msg.data 是空值且 value == 0的話，Receive or Fallback ? Receive
// 交易的 msg.data 是空值且 value != 0的話，Receive or Fallback ? Receive
contract ReceiveFallback {
  event Received(address, uint);
  event Fallback(address, uint);

  receive() external payable {
    emit Received(msg.sender, msg.value);
  }

  fallback() external payable {
    emit Fallback(msg.sender, msg.value);
  }
}

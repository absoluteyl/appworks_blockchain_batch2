// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 課堂 hands-on: https://docs.google.com/presentation/d/1SALwP1v5g8MVXZXRlDdNnTmPk2FwTO_NcgzoMLF0QWM/edit#slide=id.g221f3041ee5_0_198
// Receive, Fallback
// 假設一個有 Receive 跟 Payable Fallback 的合約中：
// Receive or Fallback ?
//   1. 交易的 msg.data 非空值且 value == 0的話，Fallback
//   2. 交易的 msg.data 非空值且 value != 0的話，Fallback
//   3. 交易的 msg.data 是空值且 value == 0的話，Receive
//   4. 交易的 msg.data 是空值且 value != 0的話，Receive
// 結論：有 msg.data 就去 fallback(), 沒有的話：有定義 reveice()，就去 receive()。沒有就去 fallback()。

// ref: https://www.youtube.com/watch?v=CMVC6Tp9gq4
// Fallback function is executed when:
//   - the function been called doesn't exist inside contract
//   - enable direct sending Ether
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

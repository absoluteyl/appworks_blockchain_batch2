// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ways to send ETH "out" of a contract
// 1. transfer - forward 2300 gas, will revert on failure
// 2. send - forward 2300 gas, return boolean of sending results
// 3. call - can forward all gas, return boolean of sending results and data
contract SendEther {
  // ways to receive ETH of a contract
  constructor() payable {}
  receive() external payable {} // fallback function is also available.


  function sendViaTransfer(address payable _to) external payable {
    _to.transfer(msg.value);
  }
  // gasleft after receiver contract executed: 2260

  // send() 在以太坊主網的主流 contract 很少用，多半都用 transfer() 或 call().
  function sendViaSend(address payable _to) external payable {
    bool success = _to.send(msg.value);
    require(success, "send failed");
  }
  // gasleft after receiver contract executed: 2260

  // call() 可以 forward 所有 gas，但是要注意的是，如果 receiver contract 的 gas 不夠用，會 revert 掉。
  function sendViaCall(address payable _to) external payable {
    (bool success,) = _to.call{value: msg.value}("");
    require(success, "call failed");
  }
  // gasleft after receiver contract executed: 6521
}

contract EthReceiver {
  event Log(uint amount, uint gas);
  receive() external payable {
    emit Log(msg.value, gasleft());
  }
}

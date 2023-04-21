// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { MyWeth } from "../src/MyWeth.sol";

contract MyWethTest is Test {
  MyWeth instance;
  address user1;
  address user2;

  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed owner, address indexed spender, uint amount);

  function setUp() public {
    user1 = address(0x01);
    user2 = address(0x02);
    instance = new MyWeth();

    vm.label(user1, "user1");
    vm.label(user2, "user2");
  }

  // Deposit: 當 user1 呼叫 deposit 並發送 ether 時，應：
  // 1：contract emit Deposit event
  // 2：contract 將與 msg.value 等值的 ERC20 token mint 給 user1
  // 3：user1 發送的 ether 存入合約
  // 4：user1 帳戶的 ether 減少與 msg.value 相等的值
  // 5：totalSupply 增加 msg.value 的 ERC20 token

  // Withdraw： 當 user1 呼叫 withdraw 時，應：
  // 1: 金額不能超過 user1 的 ERC20 token 餘額
  // 2: contract emit Withdraw event
  // 3: user1 的 ERC20 token 餘額減少與 _amount 相等的值
  // 4: 要 burn 掉與 _amount 相等的 ERC20 token (totalSupply 減少)
  // 5: 將與 msg.value 等值的 ether 轉給 user1
  // 6: contract 餘額減少與 _amount 相等的 ether
  function testDepositWithdraw() public {
    vm.deal(user1, 1 ether);
    vm.startPrank(user1);
    // Deposit
    vm.expectEmit();
    emit Deposit(address(instance), user1, 0.5 ether);
    instance.deposit{value: 0.5 ether}();
    assertEq(instance.balanceOf(user1),  0.5 * 10**18);
    assertEq(address(instance).balance, 0.5 ether);
    assertEq(address(user1).balance, 0.5 ether);
    assertEq(instance.totalSupply(), 0.5 * 10**18);

    // Withdraw
    vm.expectRevert("Insufficient balance");
    instance.withdraw(1 * 10**18);
    vm.expectEmit();
    emit Withdraw(user1, address(instance), 0.3 ether);
    instance.withdraw(0.3 * 10**18);
    assertEq(instance.balanceOf(user1), 0.2 * 10**18);
    assertEq(address(instance).balance, 0.2 ether);
    assertEq(address(user1).balance, 0.8 ether);
    assertEq(instance.totalSupply(), 0.2 * 10**18);
    vm.stopPrank();
  }
}

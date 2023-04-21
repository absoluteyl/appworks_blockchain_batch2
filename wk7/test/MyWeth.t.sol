// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { MyWeth } from "../src/MyWeth.sol";

contract MyWethTest is Test {
  MyWeth instance;
  address user1;
  address user2;
  address user3;

  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed owner, address indexed spender, uint amount);

  function setUp() public {
    user1 = address(0x01);
    user2 = address(0x02);
    user3 = address(0x03);
    instance = new MyWeth();

    vm.label(user1, "user1");
    vm.label(user2, "user2");
    vm.label(user3, "user3");
  }

  // Deposit: 當 user1 呼叫 deposit 並發送 ether 時，應：
  // 1：contract emit Transfer event
  // 2：contract 將與 msg.value 等值的 ERC20 token mint 給 user1
  // 3：user1 發送的 ether 存入合約
  // 4：user1 帳戶的 ether 減少與 msg.value 相等的值
  // 5：totalSupply 增加 msg.value 的 ERC20 token

  // Withdraw： 當 user1 呼叫 withdraw 時，應：
  // 1: 金額不能超過 user1 的 ERC20 token 餘額
  // 2: contract emit Transfer event
  // 3: user1 的 ERC20 token 餘額減少與 _amount 相等的值
  // 4: 要 burn 掉與 _amount 相等的 ERC20 token (totalSupply 減少)
  // 5: 將與 msg.value 等值的 ether 轉給 user1
  // 6: contract 餘額減少與 _amount 相等的 ether
  function testDepositWithdraw() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);
    // Deposit Steps
    vm.expectEmit();
    emit Transfer(address(instance), user1, 0.5 * 10**18);
    instance.deposit{value: 0.5 ether}();

    assertEq(instance.balanceOf(user1), 0.5 * 10**18);
    assertEq(address(instance).balance, 0.5 ether);
    assertEq(address(user1).balance, 0.5 ether);
    assertEq(instance.totalSupply(), 0.5 * 10**18);

    // Withdraw Steps
    vm.expectRevert("Insufficient balance");
    instance.withdraw(1 * 10**18);

    vm.expectEmit();
    emit Transfer(user1, address(instance), 0.3 ether);
    instance.withdraw(0.3 * 10**18);

    assertEq(instance.balanceOf(user1), 0.2 * 10**18);
    assertEq(address(instance).balance, 0.2 ether);
    assertEq(address(user1).balance, 0.8 ether);
    assertEq(instance.totalSupply(), 0.2 * 10**18);

    vm.stopPrank();
  }

  // Transfer: 當 user1 欲將 ERC20 Token 轉給 user2 時，應：
  // 1: 金額不能超過 user1 的 ERC20 token 餘額
  // 2: contract emit Transfer event
  // 3: user1 的 ERC20 token 餘額減少與 _amount 相等的值
  // 4: user2 的 ERC20 token 餘額增加與 _amount 相等的值
  // 5: contract 餘額不變
  // 6: user1 帳戶的 ether 不變
  // 7: user2 帳戶的 ether 不變
  // 8: totalSupply 不變
  function testTransfer() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);

    vm.expectEmit();
    emit Transfer(address(instance), user1, 0.9 ether);
    instance.deposit{value: 0.9 ether}();

    assertEq(instance.balanceOf(user1), 0.9 * 10**18);
    assertEq(address(instance).balance, 0.9 ether);
    assertEq(address(user1).balance, 0.1 ether);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    // Transfer steps
    vm.expectRevert("Insufficient balance");
    instance.transfer(user2, 1 * 10**18);

    vm.expectEmit();
    emit Transfer(user1, user2, 0.3 * 10**18);
    instance.transfer(user2, 0.3 * 10**18);

    assertEq(instance.balanceOf(user1), 0.6 * 10**18);
    assertEq(instance.balanceOf(user2), 0.3 * 10**18);
    assertEq(address(instance).balance, 0.9 * 10**18);
    assertEq(address(user1).balance, 0.1 * 10**18);
    assertEq(address(user2).balance, 0);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    vm.stopPrank();
  }

  // Approve: user1 將自己的 ERC20 token 授權給 user2 並指定授權金額時，應：
  // 1. 授權的金額不能超過 user1 的 ERC20 token 餘額
  // 2. contract emit Approval event
  // 3. user1 授權給 user2 的 allowance 增加與 _amount 相等的值
  // 4. user1 的 ERC20 token 餘額不變
  // 5. user2 的 ERC20 token 餘額不變
  // 6. contract 餘額不變
  // 7. user1 帳戶的 ether 不變
  // 8. user2 帳戶的 ether 不變
  // 9. totalSupply 不變
  // Transfer: user2 將 user1 的 ERC20 token 轉給 user3 時，應：
  // 1. 金額不能超過 user1 所授權給 user2 的金額
  // 2. contract emit Transfer event
  // 3. user1 授權給 user2 的 allowance 減少與 _amount 相等的值
  // 4. user1 的 ERC20 token 餘額減少與 _amount 相等的值
  // 5. user2 的 ERC20 token 餘額不變
  // 6. user3 的 ERC20 token 餘額增加與 _amount 相等的值
  // 7. contract 餘額不變
  // 8. user1 帳戶的 ether 不變
  // 9. user2 帳戶的 ether 不變
  // 10. user3 帳戶的 ether 不變
  // 11. totalSupply 不變
  function testApproveTransferFrom() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);

    vm.expectEmit();
    emit Transfer(address(instance), user1, 0.9 ether);
    instance.deposit{value: 0.9 ether}();

    assertEq(instance.balanceOf(user1), 0.9 * 10**18);
    assertEq(address(instance).balance, 0.9 ether);
    assertEq(address(user1).balance, 0.1 ether);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    // Approve steps
    vm.expectRevert("Insufficient balance");
    instance.approve(user2, 1 * 10**18);

    vm.expectEmit();
    emit Approval(user1, user2, 0.7 * 10**18);
    instance.approve(user2, 0.7 * 10**18);

    assertEq(instance.allowance(user1, user2), 0.7 * 10**18);
    assertEq(instance.balanceOf(user1), 0.9 * 10**18);
    assertEq(instance.balanceOf(user2), 0);
    assertEq(address(instance).balance, 0.9 ether);
    assertEq(address(user1).balance, 0.1 ether);
    assertEq(address(user2).balance, 0 ether);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    vm.stopPrank();

    // TransferFrom steps
    vm.startPrank(user2);

    vm.expectRevert("Insufficient allowance");
    instance.transferFrom(user1, user3, 0.9 * 10**18);

    vm.expectEmit();
    emit Transfer(user1, user3, 0.3 * 10**18);
    instance.transferFrom(user1, user3, 0.3 * 10**18);

    assertEq(instance.allowance(user1, user2), 0.4 * 10**18);
    assertEq(instance.balanceOf(user1), 0.6 * 10**18);
    assertEq(instance.balanceOf(user2), 0);
    assertEq(instance.balanceOf(user3), 0.3 * 10**18);
    assertEq(address(instance).balance, 0.9 ether);
    assertEq(address(user1).balance, 0.1 ether);
    assertEq(address(user2).balance, 0);
    assertEq(address(user3).balance, 0);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    vm.stopPrank();
  }
}

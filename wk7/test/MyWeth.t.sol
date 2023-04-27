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

  // Deposit: 當 user1 透過 deposit() 發送 0.5 ETH 時，應：
  // 1. contract 發出 Transfer event，內容為 `from: contract, to: user1, 0.5 WETH`
  // 2. user1 在 contract 中有 0.5 WETH 的餘額
  // 3. contract 帳戶餘額為 0.5ETH
  // 4. user1 帳戶餘額為 0.5ETH
  // 5. contract totalSupply 為 0.5 WETH

  // Withdraw: 承 Deposit，當 user1 呼叫 withdraw()：
  // 1. 欲提領 1 WETH（超過 user1 在 contract 中的 WETH 餘額）時，revert 並回覆 `Insufficient balance` 錯誤
  // 2. 欲提領 0.3 WETH 時：
  //     1. contract 發出 Transfer event，內容為 `from: user1, to: contract, 0.3 WETH`
  //     2. user1 在 contract 中餘額變為 0.2 WETH
  //     3. contract 帳戶餘額為 0.2 ETH
  //     4. user1 帳戶餘額增加為 0.8 ETH
  //     5. contract totalSupply 減少為 0.2 WETH
  function testDepositWithdraw() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);
    // Deposit Steps
    vm.expectEmit();
    emit Transfer(address(0), user1, 0.5 * 10**18);
    instance.deposit{value: 0.5 ether}();

    assertEq(instance.balanceOf(user1), 0.5 * 10**18);
    assertEq(address(instance).balance, 0.5 ether);
    assertEq(address(user1).balance, 0.5 ether);
    assertEq(instance.totalSupply(), 0.5 * 10**18);

    // Withdraw Steps
    vm.expectRevert("Insufficient balance");
    instance.withdraw(1 * 10**18);

    vm.expectEmit();
    emit Transfer(user1, address(0), 0.3 ether);
    instance.withdraw(0.3 * 10**18);

    assertEq(instance.balanceOf(user1), 0.2 * 10**18);
    assertEq(address(instance).balance, 0.2 ether);
    assertEq(address(user1).balance, 0.8 ether);
    assertEq(instance.totalSupply(), 0.2 * 10**18);

    vm.stopPrank();
  }

  // Transfer: 當 user1 已有 1ETH 並將其中 0.9 換為 WETH，且欲轉帳給 user2 時：
  //   1. 欲轉 1 WETH （超過 user1 在 contract 中的 WETH 餘額）給 user2 時，revert 並回覆 `Insufficient balance` 錯誤
  //   2. 欲轉 0.3 WETH 給 user2 時：
  //     1. contract 發出 Transfer event，內容為 `from: user1, to: user2, 0.3 WETH`
  //     2. user1 在 contract 中餘額變為 0.6 WETH
  //     3. user2 在 contract 中餘額變為 0.3 WETH
  //     4. contract 帳戶餘額仍為 0.9 ETH
  //     5. user1 帳戶餘額仍為 0.1 ETH
  //     6. user1 帳戶餘額仍為 0 ETH
  //     7. contract totalSupply 仍為 0.9 WETH
  function testTransfer() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);

    vm.expectEmit();
    emit Transfer(address(0), user1, 0.9 ether);
    instance.deposit{value: 0.9 ether}();

    // Check prepare result
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
    assertEq(address(instance).balance, 0.9 ether);
    assertEq(address(user1).balance, 0.1 ether);
    assertEq(address(user2).balance, 0);
    assertEq(instance.totalSupply(), 0.9 * 10**18);

    vm.stopPrank();
  }

  // Approve: 當 user1 已有 1ETH 並將其中 0.9 換為 WETH，且欲授權 user2 轉帳給 user3 時：
  //   1. 欲授權 1 WETH （超過 user1 在 contract 中的 WETH 餘額）給 user2 時，revert 並回覆 `Insufficient balance` 錯誤
  //   2. 欲授權 0.7 WETH 給 user2 時：
  //     1. contract 發出 Approval event，內容為 `from: user1, to: user2, 0.7 WETH`
  //     2. user1 授權給 user2 的 allowance 為 0.7 WETH
  //     3. user1 在 contract 中餘額仍為 0.9 WETH
  //     4. user2 在 contract 中餘額仍為 0 WETH
  //     5. contract 帳戶餘額仍為 0.9 ETH
  //     6. user1 帳戶餘額仍為 0.1 ETH
  //     7. user2 帳戶餘額仍為 0 ETH
  //     8. contract totalSupply 仍為 0.9 WETH

  // TransferFrom: 承 Approve，user2 欲將 user1 的 WETH 轉帳給 user3 時：
  //   1. 欲轉 0.9 WETH （超過 user1 授權給 use2 的 WETH 金額）給 user3 時，revert 並回覆 `Insufficient allowance` 錯誤
  //   2. 欲轉 0.3 WETH 給 user3 時：
  //     1. contract emit Transfer event
  //     2. user1 授權給 user2 的 allowance 減少為 0.4 WETH
  //     3. user1 在 contract 中餘額減少為 0.6 WETH
  //     4. user2 在 contract 中餘額仍為 0 WETH
  //     5. userˇ 在 contract 中餘額增加為 0.3 WETH
  //     6. contract 帳戶餘額仍為 0.9 ETH
  //     7. user1 帳戶餘額仍為 0.1 ETH
  //     8. user2 帳戶餘額仍為 0 ETH
  //     9. user3 帳戶餘額仍為 0 ETH
  //     10. contract totalSupply 仍為 0.9 WETH
  function testApproveTransferFrom() public {
    // Prepare
    vm.deal(user1, 1 ether);

    vm.startPrank(user1);

    vm.expectEmit();
    emit Transfer(address(0), user1, 0.9 ether);
    instance.deposit{value: 0.9 ether}();

    // Check prepare result
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

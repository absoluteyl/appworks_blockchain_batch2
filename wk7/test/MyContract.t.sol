// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import { MyContract } from "../src/MyContract.sol";

contract MyContractTest is Test {

  MyContract instance;
  address user1;
  address user2;
  address user3;

  event Receive(address from, uint256 amount);
  event Send(address to, uint256 amount);

  function setUp() public {
    // TODO:
    // 1. Set user1, user2, user3
    user1 = address(0x01);
    user2 = address(0x02);
    user3 = address(0x03);
    // 2. Create a new instance of MyContract
    instance = new MyContract(user1, user2);
    // 3. (optional) label user1 as bob, user2 as alice
    vm.label(user1, "bob");
    vm.label(user2, "alice");
    vm.label(user3, "john");
  }

  function testConstructor() public {
    // TODO:
    // 1. Assert instance.user1() is user1
    assertEq(instance.user1(), user1);
    // 2. Assert instance.user2() is user2
    assertEq(instance.user2(), user2);
  }

  function testReceiveEther() public {
    // TODO:
    // 1. let user1 have 1 ether
    vm.deal(user1, 1 ether);
    // 2. pretending you are user1
    vm.startPrank(user1);
    // 3. send 1 ether to instance
    vm.expectEmit();
    emit Receive(user1, 1 ether);
    (bool success, ) = address(instance).call{value: 1 ether}("");
    // 4.1. Assert call result is true
    assertEq(success, true);
    // 4.2. Assert instance has 1 ether in balance
    assertEq(address(instance).balance, 1 ether);
    // 4.3. Assert user1 has 0 ether in balance
    assertEq(address(user1).balance, 0 ether);
    // 5. stop pretending
    vm.stopPrank();
  }

  // 只有 user1 和 user2 才能 send
  // Amount 應該小於這個合約的 balance
  // 合約應該正確的轉錢給 user
  // 合約應該 emit Send event
  function testSend() public {
    // 先給 user3 1E
    vm.deal(user3, 1 ether);
    vm.startPrank(user3);
    vm.expectRevert("only user1 or user2 can send");
    instance.sendEther(user3, 0.5 ether);
    // 發 1E 給後面測項用
    (bool success, ) = address(instance).call{value: 1 ether}("");
    assertEq(success, true);
    assertEq(address(instance).balance, 1 ether);
    vm.stopPrank();
    // switch to user1
    vm.startPrank(user1);
    vm.expectRevert("insufficient balance");
    instance.sendEther(user1, 1.1 * 10**18);
    vm.expectEmit();
    emit Send(user1, 0.5 * 10**18);
    instance.sendEther(user1, 0.5 * 10**18);
    vm.stopPrank();
  }
}

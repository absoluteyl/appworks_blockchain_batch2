// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import { MyContract } from "../src/MyContract.sol";

contract MyContractTest is Test {

  MyContract instance;
  address user1;
  address user2;

  event Receive(address from, uint256 amount);

  function setUp() public {
    // TODO:
    // 1. Set user1, user2
    user1 = address(0x01);
    user2 = address(0x02);
    // 2. Create a new instance of MyContract
    instance = new MyContract(user1, user2);
    // 3. (optional) label user1 as bob, user2 as alice
    vm.label(user1, "bob");
    vm.label(user2, "alice");
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
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { MyWeth } from "../src/MyWeth.sol";

contract MyWethTest is Test {
  MyWeth instance;
  address user;

  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed owner, address indexed spender, uint amount);

  function setUp() public {
    user = address(0x01);
    instance = new MyWeth();
  }

  // 測項 1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
  function testDeposit1() public {
    vm.deal(user, 1 ether);
    vm.startPrank(user);
    vm.expectEmit();
    emit Transfer(address(instance), user, 0.5 ether);
    instance.deposit{value: 0.5 ether}();
    vm.stopPrank();
    assertEq(instance.balanceOf(user),  500000000000000000);
    assertEq(address(instance).balance, 0.5 ether);
    assertEq(address(user).balance, 0.5 ether);
  }

}

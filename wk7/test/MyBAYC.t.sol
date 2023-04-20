// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";

interface IBAYC {
  function mintApe(uint256 _apeId) external payable;
  function balanceOf(address _owner) external view returns (uint256);
}

// 請到 alchemy 或 infura 申請一組 endpoint rpc url
// 請在 test case 中使用 createFork 和 selectFork
// Fork ethereum mainnet
// Block number => 12299047
// 使用 mintApe function 從 BAYC 中 mint 出 100 個 BAYC
// 每 mint 一顆需要 0.08 ETH
// 請用 assertEq 檢查是否 mint 了 100 顆
// 請用 assertEq 檢查 mint ape function 是否收到 8 ether
contract MyBAYCTest is Test {

  uint256 public forkId;
  address public user;
  IBAYC public bayc;

  function setUp() public {
    // Fork ethereum mainnet
    forkId = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/RWTA1ioafATxmbndegq3qIKdDDoK48qO", 12299047);
    vm.selectFork(forkId);
    assertEq(block.number, 12299047);
    user = address(0x01);
    bayc = IBAYC(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
  }

  function testMintApe() public {
    vm.deal(user, 8 ether);
    vm.startPrank(user);
    for (uint i = 0; i < 5; i++) {
      bayc.mintApe{value: 1.6 ether}(20);
    }
    assertEq(bayc.balanceOf(user), 100);
    assertEq(address(bayc).balance, 8.08 ether); // 因為目前是在 mint 出第一顆 bayc 的 block，所以 contract balance 總共應該是 8.08E
    vm.stopPrank();
  }
}

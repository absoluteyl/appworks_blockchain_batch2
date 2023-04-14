// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

// 課堂 Hands-on: https://docs.google.com/presentation/d/1SALwP1v5g8MVXZXRlDdNnTmPk2FwTO_NcgzoMLF0QWM/edit#slide=id.g22d6fa7a0b9_16_45
contract Caller {
    event Log(bool b, bytes d);

    function calls(address addr, uint256 s) public {
      // To Do: Call setA()
      // (bool success, bytes memory data) = ...
      // We need to use call here since we want modify the state of contract A
      (bool success,) = addr.call(
         abi.encodeWithSignature("setA(uint256)", s)
      );
      require(success, "Call Failed!");
      // To Do: Call getA()
      // (bool success, bytes memory data) = ...
      // Use staticcall here since we don't modify the state of contract A
      (, bytes memory data) = addr.staticcall(
         abi.encodeWithSignature("getA()")
      );
      uint256 a = abi.decode(data, (uint256));
      require(a == s);
   }
}

contract Callee {
   uint public a;

   function setA(uint256 _a) public {
      a = _a;
   }

   function getA() public view returns (uint256) {
      return a;
   }
}

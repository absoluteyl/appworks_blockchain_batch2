// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

// 課堂 Hands-on: https://docs.google.com/presentation/d/1SALwP1v5g8MVXZXRlDdNnTmPk2FwTO_NcgzoMLF0QWM/edit#slide=id.g22d6fa7a0b9_16_71
// Delegate call (A, B or msg.sender)
// User call A 合約，A call B合約，B 中的 msg.sender 是誰？
//  → A 的 msg.sender = User, B 的 msg.sender = A

// User call A 合約，A delegatecall B 合約，在 B 中的 msg.sender 是誰？
//  → A 的 msg.sender = User, B 的 msg.sender = User

// User call A 合約，A delegatecall B 合約，B 合約又 call C 合約，這時在 C 合約中的 msg.sender 是誰呢？
//  → A 的 msg.sender = User, B 的 msg.sender = User, C 的 msg.sender = A

// User 在 A 合約中 call B合約，B 合約又 delegatecall C 合約，這時在 C 合約中的 msg.sender 是誰呢？
//  → A 的 msg.sender = User, B 的 msg.sender = A, C 的 msg.sender = A
contract A {
  event ALog(address);

  function callB(address _baddr) external {
    (bool success,) = _baddr.call(
        abi.encodeWithSignature("b()")
    );
    require(success);
    emit ALog(msg.sender);
  }

  function delegatecallB(address _baddr) external {
    (bool success,) = _baddr.delegatecall(
        abi.encodeWithSignature("b()")
    );
    require(success);
    emit ALog(msg.sender);
  }

  function delegatecallC(address _baddr, address _caddr) external {
    (bool success,) = _baddr.call(
        abi.encodeWithSignature("delegatecallC(address)", _caddr)
    );
    require(success);
    emit ALog(msg.sender);
  }

  function callC(address _baddr, address _caddr) external {
    (bool success,) = _baddr.delegatecall(
        abi.encodeWithSignature("callC(address)", _caddr)
    );
    require(success);
    emit ALog(msg.sender);
  }
}

contract B {
  event BLog(address);

  function b() external {
    emit BLog(msg.sender);
  }

  function callC(address _addr) external {
    (bool success,) = _addr.call(
        abi.encodeWithSignature("c()")
    );
    require(success);
    emit BLog(msg.sender);
  }

  function delegatecallC(address _addr) external {
    (bool success,) = _addr.delegatecall(
        abi.encodeWithSignature("c()")
    );
    require(success);
    emit BLog(msg.sender);
  }
}

contract C {
  event CLog(address);

  function c() external {
    emit CLog(msg.sender);
  }
}

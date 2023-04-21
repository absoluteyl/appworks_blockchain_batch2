// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 課堂練習： https://docs.google.com/presentation/d/1SALwP1v5g8MVXZXRlDdNnTmPk2FwTO_NcgzoMLF0QWM/edit#slide=id.g209c50ae161_0_17

// 請撰寫一份 ERC20 合約：
// 繼承以下此 interface:
interface IWETH9 {
  function deposit() external payable;
  function withdraw(uint256 _amount) external;
}
// Deposit => 將與 msg.value 量相同的 erc20 token 轉給 user
// Withdraw => 將與 _amount 數量的 ethers 從合約中轉給 user，並 burn 掉對應數量的 token
// Receive => 將與 msg.value 量的 erc20 token 轉給 user
contract MyWeth is IWETH9 {
  event Deposit(address indexed from, address indexed to, uint amount);
  event Withdraw(address indexed from, address indexed to, uint amount);
  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed owner, address indexed spender, uint amount);

  // 目前的 token 供應量
  uint public totalSupply;

  // 紀錄每個地址持有的 token 餘額
  mapping(address => uint) public balanceOf;

  // 紀錄每個地址允許哪個 spender 地址操作多少 token
  mapping(address => mapping(address => uint)) public allowance;

  // ERC20 token 的參數
  string public name     = "AbsoluToken";
  string public symbol   = "ABT";
  uint8  public decimals = 18; // token 是多少進制

  // token holder 將指定數量的 token 轉給其他地址
  function transfer(
    address recipient,
    uint amount
  ) public returns (bool) {
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient]  += amount;
    emit Transfer(msg.sender, recipient, amount);

    return true;
  }

  // Token holder 可允許 spender 將 holder 持有的 token 轉出，
  // 並設定 spender 可動用的 token 數量上限
  function approve(
    address spender,
    uint amount
  ) public returns (bool) {
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);

    return true;
  }

  // spender 進行 token 轉移用
  function transferFrom(
    address sender,
    address recipient,
    uint amount
  ) public returns (bool) {
    // 先確認 allowance 金額
    allowance[sender][msg.sender] -= amount;
    // 實際轉帳
    balanceOf[sender]    -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(sender, recipient, amount);

    return true;
  }
  // ↑↑↑ 實作 ERC20 的部份 ↑↑↑

  // NOT ERC20 Standard functions
  // Mint new tokens
  function mint(uint amount) public {
    balanceOf[msg.sender] += amount;
    totalSupply += amount;
    emit Transfer(address(0), msg.sender, amount);
  }

  // Burn some tokens
  function burn(uint amount) public {
    balanceOf[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

  // ↓↓↓ 課堂練習的部份 ↓↓↓
  // Deposit => 將與 msg.value 量相同的 erc20 token 轉給 user
  function deposit() external payable override {
    balanceOf[msg.sender] += msg.value;
    totalSupply += msg.value;
    emit Deposit(address(this), msg.sender, msg.value);
  }

  // Withdraw => 將與 _amount 數量的 ethers 從合約中轉給 user，並 burn 掉對應數量的 token
  function withdraw(uint256 _amount) external override {
    require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
    balanceOf[msg.sender] -= _amount;
    totalSupply -= _amount;
    // payable(msg.sender).transfer(_amount);
    (bool result,) = payable(msg.sender).call{value: _amount}("");
    if (result) {
      emit Withdraw(msg.sender, address(this), _amount);
    } else {
      revert("Transfer failed");
    }
  }

  // Receive => 將與 msg.value 量的 erc20 token 轉給 user
  receive() external payable {
    balanceOf[msg.sender] += msg.value;
    totalSupply += msg.value;
    emit Transfer(address(0), msg.sender, msg.value);
  }
}

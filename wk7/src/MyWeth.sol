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
  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed owner, address indexed spender, uint amount);

  // 目前的 token 供應量
  uint public totalSupply;

  // 紀錄每個地址持有的 token 餘額
  mapping(address => uint) public balanceOf;

  // 紀錄每個地址允許哪個 spender 地址操作多少 token
  mapping(address => mapping(address => uint)) public allowance;

  // ERC20 token 的參數
  string public name     = "Wrap Ether";
  string public symbol   = "WETH";
  uint8  public decimals = 18; // token 是多少進制

  modifier checkBalance(uint amount) {
    require(balanceOf[msg.sender] >= amount, "Insufficient balance");
    _;
  }

  // token holder 將指定數量的 token 轉給其他地址
  function transfer(
    address recipient,
    uint amount
  ) public checkBalance(amount) returns (bool) {
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
  ) public checkBalance(amount) returns (bool) {
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
    require(allowance[sender][msg.sender] >= amount, "Insufficient allowance");
    require(balanceOf[sender] >= amount, "Insufficient balance");
    // 扣除 allowance
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
  function _mint(uint amount) internal {
    balanceOf[msg.sender] += amount;
    totalSupply += amount;
    emit Transfer(address(0), msg.sender, amount);
  }

  // Burn some tokens
  function _burn(uint amount) internal checkBalance(amount) {
    balanceOf[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

  // ↓↓↓ 課堂練習的部份 ↓↓↓
  // Deposit => 將與 msg.value 量相同的 erc20 token 轉給 user
  function deposit() external payable override {
    _mint(msg.value);
  }

  // Withdraw => 將與 _amount 數量的 ethers 從合約中轉給 user，並 burn 掉對應數量的 token
  function withdraw(uint256 _amount) external checkBalance(_amount) override {
    _burn(_amount);
    (bool result,) = payable(msg.sender).call{value: _amount}("");
    require(result, "Transfer failed");
  }

  // Receive => 將與 msg.value 量的 erc20 token 轉給 user
  receive() external payable {
    _mint(msg.value);
  }
}

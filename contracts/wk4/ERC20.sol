// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=gwn1rVDuGL0

interface IERC20 {
    // 此 token 的總供應量
    function totalSupply() external view returns (uint);

    // 查詢指定帳號的 token 餘額
    function balanceOf(address account) external view returns (uint);

    // token holder 將指定數量的 token 轉給其他地址
    function transfer(
        address recipient, 
        uint amount
    ) external returns (bool);

    // Token holder 可允許 spender 將 holder 持有的 token 轉出，
    // 並設定 spender 可動用的 token 數量上限
    function approve(
        address spender, 
        uint amount
    ) external returns (bool);

    // 查詢 spender 可以操作多少 token holder 的 token
    function allowance(
        address owner, 
        address spender
    ) external view returns (uint);

    // spender 進行 token 轉移用
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

contract ERC20 is IERC20 {
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
    ) external returns (bool) {
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
    ) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    // spender 進行 token 轉移用
    function transferFrom(
        address sender, 
        address recipient,
        uint amount
    ) external returns (bool) {
        // 先確認 allowance 金額
        allowance[sender][msg.sender] -= amount;
        // 實際轉帳
        balanceOf[sender]    -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);

        return true;
    }

    // NOT ERC20 Standard functions
    // Mint new tokens
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // Burn some tokens
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

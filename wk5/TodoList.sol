// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
  // 定義此 contract 的 owner
  address public owner;

  // 在合約部署時, 將 owner 設為 msg.sender
  constructor() {
    owner = msg.sender;
  }

  // 定義一個 modifier, 只有 owner 才能呼叫
  modifier onlyOwner() {
    require(msg.sender == owner, "Permission Denied.");
    _;
  }

  // 簡單定義一個 struct, 有 name 跟 isCompleted
  struct Task {
    string name;
    bool isCompleted;
  }
  // 定義一個 tasks 的 Task 陣列, 用來存所有的 task
  // 後面還會定義 get tasks 的方法, 所以這邊宣告為 internal 即可
  Task[] internal tasks;

  // 建立新的 task, 並將它 push 到 tasks 陣列中
  function create(string memory _name) external onlyOwner {
    // 實際產生 task object 並存到 tasks 中
    tasks.push(Task(_name, false));
  }

  // 更新指定 idx 的 task 的 isCompleted 狀態
  function update(uint _idx) external onlyOwner {
    // 透過 index 找到指定 id 的 task
    Task storage _task = tasks[_idx];

    // 更新 task 的 isCompleted 狀態
    _task.isCompleted = !_task.isCompleted;
  }

  // 取得指定 idx 的 task detail
  function get(uint _idx) external view onlyOwner returns (Task memory) {
    return tasks[_idx];
  }

  // 自我毀滅
  function kill() external onlyOwner {
    selfdestruct(payable(msg.sender));
  }
}

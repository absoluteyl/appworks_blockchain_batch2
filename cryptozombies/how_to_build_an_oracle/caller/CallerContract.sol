// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 用來跟 Oracle Contract 互動的 Interface
import "./EthPriceOracleInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CallerContract is Ownable {
  uint256 private ethPrice;
  address private oracleAddress;
  EthPriceOracleInterface private oracleInstance;

  // 因為向 Oracle Contract 發送請求是非同步的，所以我們需要一個 mapping 來記錄每個請求的狀態
  mapping(uint256 => bool) private myRequests;

  event newOracleAddressEvent(address oracleAddress);
  event ReceivedNewRequestIdEvent(uint256 id);
  event PriceUpdatedEvent(uint256 ethPrice, uint256 id);

  // 因為合約部署後就不能再修改，我們需要一個方式可以更新 Oracle Contract 的地址
  function setOracleInstanceAddress(address _oracleInstanceAddress) public onlyOwner {
    oracleAddress = _oracleInstanceAddress;
    oracleInstance = EthPriceOracleInterface(oracleAddress);

    emit newOracleAddressEvent(oracleAddress);
  }

  // 向 Oracle Instance 取得 ETH 的最新價格
  function updateEthPrice() public {
    uint256 id = oracleInstance.getLatestEthPrice();
    myRequests[id] = true;

    emit ReceivedNewRequestIdEvent(id);
  }

  // Callback 只允許 Oracle Contract 呼叫
  modifier onlyOracle() {
    require(msg.sender == oracleAddress, "You are not authorized to call this function.");
    _;
  }

  // Oracle Contract 拿到價格後會透過這個 function 回傳最新的 ETH 價格
  function callback(uint256 _ethPrice, uint256 _id) public onlyOracle {
    // 檢查 request ID 是否存在
    require(myRequests[_id], "This request is not in my pending list.");
    // 更新 ETH 價格
    ethPrice = _ethPrice;
    // 將請求從 mapping 中移除
    delete myRequests[_id];
    // 留個 Log
    emit PriceUpdatedEvent(ethPrice, _id);
  }
}

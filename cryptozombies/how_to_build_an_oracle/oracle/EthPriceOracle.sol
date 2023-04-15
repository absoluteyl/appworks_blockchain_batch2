// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CallerContractInterface.sol";
import "@openzeppelin/contracts/access/AccessControl.sol"; // 用來做權限管理
import "@openzeppelin/contracts/utils/math/SafeMath.sol";  // 可用來避免 overflow 或 underflow

contract EthPriceOracle is AccessControl {
  bytes32 private constant OWNER  = keccak256("OWNER");
  bytes32 private constant ORACLE = keccak256("ORACLE");

  using SafeMath for uint256;

  // 用來產 request ID 的 nonce
  uint private randNonce = 0;
  uint private modulus = 1000;

  // 用來記錄 oracle 的數量
  uint private numOracles = 0;
  uint private THRESHOLD  = 0;

  mapping(uint256=>bool) pendingRequests;

  // 當 Oracle 有多個時，用來紀錄每個 Oracle 的回應
  struct Response {
    address oracleAddress;
    address callerAddress;
    uint256 ethPrice;
  }
  mapping (uint256=>Response[]) public requestIdToResponse;

  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  event AddOracleEvent(address oracleAddress);
  event RemoveOracleEvent(address oracleAddress);

  constructor (address _owner) {
    _grantRole(OWNER, _owner);
  }

  function addOracle(address _oracle) public onlyRole(OWNER) {
    // 檢查 _oracle 是否已經是 oracle
    require(!hasRole(ORACLE, _oracle), "Already an oracle!");

    _grantRole(ORACLE, _oracle);
    numOracles++;

    emit AddOracleEvent(_oracle);
  }

  function removeOracle (address _oracle) public onlyRole(OWNER) {
    // 檢查 _oracle 是否是 oracle
    require(hasRole(ORACLE, _oracle), "Not an oracle!");
    // 檢查 oracle 的數量是否大於 1
    require(numOracles > 1, "Do not remove the last oracle!");

    _revokeRole(ORACLE, _oracle);
    numOracles--;

    emit RemoveOracleEvent(_oracle);
  }

  function getLatestEthPrice() public returns (uint256) {
    randNonce++;
    // 產生一個隨機的 request ID
    // 注意原本 cryptozombies 是用 now 來產生，但是 now 已經被棄用了，要改用 block.timestamp
    uint id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    // 將 request ID 加入 pendingRequests
    pendingRequests[id] = true;
    // 留個 Log
    emit GetLatestEthPriceEvent(msg.sender, id);
    // 回傳 request ID
    return id;
  }

  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public onlyRole(OWNER) {
    // 檢查 request ID 是否存在
    require(pendingRequests[_id], "This request is not in my pending list.");

    // 初始化 Response
    Response memory resp = Response(msg.sender, _callerAddress, _ethPrice);
    // 將 Response 加入 requestIdToResponse
    requestIdToResponse[_id].push(resp);

    uint numResponses = requestIdToResponse[_id].length;
    if (numResponses == THRESHOLD) {
      // 在此處簡單用求平均值的方式來計算 ETH 價格，但在真實應用上，應該要用更複雜的方式來確保價格不會被惡意操作。
      // 例如去除極端值，或是用加權平均值。可參考：https://www.mathsisfun.com/data/quartiles.html
      uint computedEthPrice = 0;
      for (uint f = 0; f < numResponses; f++) {
        computedEthPrice = computedEthPrice.add(requestIdToResponse[_id][f].ethPrice); // 用 SafeMath 的 add()
      }
      computedEthPrice = computedEthPrice.div(numResponses); // 用 SafeMath 的 div()

      // 將處理完的 Request 從 mapping 中移除
      delete pendingRequests[_id];
      delete requestIdToResponse[_id];

      // 因為要打 Caller Contract 的 callback(), 要先 init 一個 CallerContractInstance
      CallerContractInterface callerContractInstance;
      callerContractInstance = CallerContractInterface(_callerAddress);

      // 將最後算出的 ETH 價格傳給 caller contract
      callerContractInstance.callback(computedEthPrice, _id);
      // 留個 Log
      emit SetLatestEthPriceEvent(computedEthPrice, _callerAddress);
    }
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 這邊用的版本要跟 solidity 互相對應 ↓
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract PriceConsumerV3 {
  AggregatorV3Interface internal priceFeed;

  constructor() {
    /*
    * Network: Sepolia Testnet
    * Aggregator: ETH/USD
    * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    */
    priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  }

  function getLatestPrice() public view returns (int) {
    // lastRoundData() will return:
    //   uint80 roundId,
    //   int answer,     --> 這個就是我們要的 price，但因為是 integer，所以還要搭配 decimals 才知道小數點要點在哪
    //   uint startedAt,
    //   uint timeStamp,
    //   uint80 answeredInRound
    (,int price,,,) = priceFeed.latestRoundData();
    return price;
  }

  function getDecimals() public view returns (uint8) {
    return priceFeed.decimals();
  }
}

contract ZombieFactory is VRFConsumerBase {

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  // Chainlink VRF 要用的參數
  bytes32 public keyHash;
  uint256 public fee;
  uint256 public randomResult;

  struct Zombie {
    string name;
    uint dna;
  }

  Zombie[] public zombies;

  constructor() VRFConsumerBase(
    // 因為 VRFConsumerBase 的 constructor 吃這些參數，所以要傳值進去：
    //   constructor(address _vrfCoordinator, address _link) {
    //   vrfCoordinator = _vrfCoordinator;
    //   LINK = LinkTokenInterface(_link);
    // }
    0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625, // VRF Coordinator on Sepolia Testnet
    0x779877A7B0D9E8603169DdbD7836e478b4624789  // LINK Token on Sepolia Testnet
  ) public{
    keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; // keyHash on Sepolia Testnet
    fee = 0.25 * 10 ** 18; // 0.25 LINK on Sepolia Testnet
  }

  function _createZombie(string memory _name, uint _dna) private {
    zombies.push(Zombie(_name, _dna));
  }

  // 向 Chainlink Node 發出取得隨機數的請求
  function getRandomNumber() public returns (bytes32 requestId) {
    return requestRandomness(keyHash, fee);
  }

  // VRF Coordinator 驗證了 Chainlin Node 提供的隨機數後，會呼叫這個 function（所以才設為 internal）
  function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
      randomResult = randomness;
  }

  // 這個 function 可以刪了
  // function _generatePseudoRandomDna(string memory _str) private view returns (uint) {
  //   uint rand = uint(keccak256(abi.encodePacked(_str)));
  //   return rand % dnaModulus;
  // }
}

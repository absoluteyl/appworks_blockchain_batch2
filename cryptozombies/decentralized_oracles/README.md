# CryptoZombies - Decentralized Oracles

## Introduction

因為智能合約是封閉的狀態機，它無法直接存取外部的資訊例如：1 ETH 值多少錢、現在時間等真實世界中的資訊。並且基於「去中心化」的理念我們也無法讓智能合約直接去抓某個網路上伺服器的相關資訊。因此就出現了預言機（Oracle）這樣的角色。我們會透過 **DON (Decentralized Oracle Network)** 來取得 **去中心化的資料來源 (decentralized data sources)** 。

## Chainlink

Chainlink 是 DON 的框架之一，是從多個預言機中獲取數據的一種方法。它以去中心化的方式將數據整合，並將其放在區塊鏈上的智能合約中（通常稱為 price reference feed 或 data feed）供我們讀取。因此我們所要做的就是從 Chainlink 不斷更新的智能合約中讀取數據。

使用 Chainlink data feed 可以在去中心化的前提下用更便宜、更準確、更安全的方式取得真時世界的數據。由於數據來自多個來源讓許多人可以參與這個生態系統，它甚至比運行一個集中化的預言機還要便宜。Chainlink 使用一種稱為 [Off-Chain Reporting](https://docs.chain.link/docs/off-chain-reporting/) 的系統，在鏈外達成數據共識，並將數據透過加密後的單一 transaction 上鏈以便讓用戶使用。

[常用的 Chainlink Data Feeds](https://data.chain.link/)

### 在專案中導入 Chainlink

透過 npm 將 [Chainlink 的官方 Github Repository](https://github.com/smartcontractkit/chainlink) 安裝到智能合約所在的目錄底下。

```bash
$npm install @chainlink/contracts --save
```

在開發階段也可以直接透過 `git clone` 下載整個 chainlink repo。

## 如何使用 Chainlink Data Feed？

1. import Aggregator Interface 到智能合約中。

```solidity
// 這邊用的版本要跟 solidity 互相對應 ↓
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

```

2. `AggregatorV3Interface.sol` 的檔案中定義的是 Interface，要使用這個 interface 我們還需要取得實際的 contract address。可以透過以下兩種方式來取得：

   - [Feed Registry](https://docs.chain.link/data-feeds/feed-registry)，會在鏈上維護各個 Data Feed 跟它們的 contract address 的 mapping。我們只需要拉這個 Registry 的資料就可以拿到對應的 contract 地址。
   - [Price Feed Contract Addresses](https://docs.chain.link/data-feeds/price-feeds/addresses)，實際各家 Data Source 的 contract 地址（就是不透過 registry，直接寫死某個 contract 地址的意思）

### 如何部署使用了 Chainlink Data Feed 的 Smart Contract?

可參考 [Chainlink 官方文件](https://docs.chain.link/getting-started/conceptual-overview)

### 進階開發工具

- [Truffle Starter Kit](https://github.com/smartcontractkit/truffle-starter-kit)
- [Hardhat Starter Kit](https://github.com/smartcontractkit/hardhat-starter-kit)
- [Brownie Starter Kit (Chainlink Mix)](https://github.com/smartcontractkit/chainlink-mix)

## 如何使用 Chainlink VRF (Verifiable Randomness Function)？

就和 Price Data Feed 一樣，VRF 是我們可以用去中心化的方式在鏈下取得隨機性的方式。（其實也一樣可以透過呼叫鏈下 API 來取得隨機性，但一樣會有 API 爛掉就影響到 contract 的風險）。

[Chainlink VRF 官方文件](https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number)

### 運作原理（Basic Request Model）

1. Callee contract makes a request in a transaction
2. Callee contract or oracle contract emits an event
3. Chainlink node (Off-chain) is listening for the event, where the details of the request are logged in the event
4. In a second transaction created by the Chainlink node, it returns the data on-chain by calling a function described by the callee contract
5. In the case of the Chainlink VRF, a randomness proof is done to ensure the number is truly random by **VRF Coordinator**

需注意的是：為了取得隨機數，我們的智能合約會真的送一個交易給 Chainlink 的合約，因此需要支付 `LINK (Chainlink Token)` 作為 Oracle Gas，`LINK` 會用來確保 Chainlink Oracle Network 的安全性。也因此我們需要存一點 `LINK` 在我們的智能合約中。

#### 為什麼 Data Feeds 不用 Oracle Gas?

由於 Data Feeds 的資料是放在 DON 上由一群 Chainlink 節點所維護，只要其中一個節點發出取得數據的 transaction 後，其他所有的節點都可以取得同樣的數據，也因此 Oracle Gas 會被稀釋掉。而這些一開始支付 Oracle Gas 的節點通常是由大型的項目所維護，例如：Aave, Compoud 等。因此其餘的節點和一般的合約開發者都可因此受惠。

相對的，Chainlink VRF 使用的是 Basic Request Model，只需要一個 Chainlink 節點就可以產生足夠的隨機性。所以 Oracle Gas 就要由呼叫取得隨機數的 Contract 來支付了。

### 實作方式

[Chainlink VRF Contract Source Code](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/VRFCoordinator.sol)

1. import VRFConsumerBase 到智能合約中。

    ```solidity
    // 這邊用的版本要跟 solidity 互相對應 ↓
    import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
    ```

2. 要使用 VRF 我們還需要下面這些資訊，這些都可以在 [Chainlink 官方文件](https://docs.chain.link/docs/vrf-contracts/) 中找到：
   1. Chainlink Token Contract Address，讓我們的 contract 可以確認是否有足夠的 `LINK` 用來支付 Oracle Gas。
   2. VRF Coordinator Contract Address，用來驗證我們拿到的隨機數是否真的隨機。
   3. Chainlink 節點的 Key Hash，就是我們要送交易讓它產生隨機數的節點。
   4. Chainlink 節點的 fee，表示節點要收取的 Oracle Gas（`LINK`)。

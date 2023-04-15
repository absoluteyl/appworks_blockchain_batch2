# How to Build an Oracle

## First things first

- 初始化 NPM

    ```bash
    $npm init -y
    ```

- 安裝需要的 package 們 (Crypto Zombies 教學中裝的 package 有的蠻老舊了，不用照著裝)

    ```bash
    $npm install @openzeppelin/contracts bn.js axios fs web3
    ```

## 檔案目錄

```bash
.
├── Client.js
├── EthPriceOracle.js
├── README.md
├── caller
│   ├── CallerContract.sol
│   ├── EthPriceOracleInterface.sol
│   ├── artifacts
│   └── caller_private_key
├── oracle
│   ├── CallerContractInterface.sol
│   ├── EthPriceOracle.sol
│   ├── artifacts
│   └── oracle_private_key
├── package-lock.json
├── package.json
├── scripts
│   └── gen-key.js
└── utils
    └── common.js

```

## 角色與流程

```mermaid
sequenceDiagram

participant Client

participant CallerContract
participant OracleContract

participant EthPriceOracle
participant 3rdPartyPriceSource

Client->>CallerContract: setOracleInstanceAddress()
Client->>CallerContract: updateEthPrice()
activate CallerContract
CallerContract->>+OracleContract: getLatestEthPrice()
OracleContract->>-CallerContract: return requestId
deactivate CallerContract

Note over OracleContract,EthPriceOracle: emit GetLatestEthPriceEvent

EthPriceOracle->>+EthPriceOracle: Keep Listen Oracle Events
EthPriceOracle->>-EthPriceOracle: addRequestToQueue()

loop
 EthPriceOracle->>+EthPriceOracle: processQueue()
 EthPriceOracle->>+3rdPartyPriceSource: retrieveLatestEthPrice()
 3rdPartyPriceSource->>-EthPriceOracle: return price
 EthPriceOracle->>-OracleContract: setLatestEthPrice()
 activate OracleContract
 OracleContract->>+CallerContract: callback()
 deactivate OracleContract
 Note over OracleContract,EthPriceOracle: emit SetLatestEthPriceEvent
 CallerContract->>-CallerContract: update price
 Note over CallerContract,Client: emit PriceUpdatedEvent
end

Client->>Client: Keep Listen Caller Events
```

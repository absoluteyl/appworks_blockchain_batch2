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
│   │   ├── CallerContractInterface.json
│   │   ├── CallerContractInterface_metadata.json
│   │   ├── EthPriceOracle.json
│   │   └── EthPriceOracle_metadata.json
│   │  
│   └── oracle_private_key
├── package-lock.json
├── package.json
├── scripts
│   └── gen-key.js
└── utils
    └── common.js

```

## 和 Oracle 互動的 Contract - Caller Contract

Caller Contract 需要有這些資訊才能夠和 Oracle Contract 互動：

- The address of the oracle smart contract
- The signature of the function you want to call

# How to Build an Oracle

## First things first

- 初始化 NPM

    ```bash
    $npm init -y
    ```

- 安裝需要的 package 們 (Crypto Zombies 教學中裝的 package 有的蠻老舊了，不用照著裝)

    ```bash
    $npm install @openzeppelin/contracts
    ```

## 檔案目錄

```
.
├── README.md
├── caller
│   ├── CallerContract.sol
│   └── EthPriceOracleInterface.sol
├── oracle
│   ├── CallerContractInterface.sol
│   └── EthPriceOracle.sol
├── package-lock.json
└── package.json

```

## 和 Oracle 互動的 Contract - Caller Contract

Caller Contract 需要有這些資訊才能夠和 Oracle Contract 互動：

- The address of the oracle smart contract
- The signature of the function you want to call

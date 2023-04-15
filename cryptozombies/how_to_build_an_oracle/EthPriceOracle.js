const axios = require('axios') // for sending HTTP requests
const BN = require('bn.js') // for dealing with large numbers
const common = require('./utils/common.js')

const SLEEP_INTERVAL = process.env.SLEEP_INTERVAL || 2000
const PRIVATE_KEY_FILE_NAME = process.env.PRIVATE_KEY_FILE || './oracle/oracle_private_key'
const CHUNK_SIZE = process.env.CHUNK_SIZE || 3
const MAX_RETRIES = process.env.MAX_RETRIES || 5

// 用來拉 EthPriceOracle contract 的 ABI
const OracleJSON = require('./oracle/artifacts/EthPriceOracle.json')
var pendingRequests = []

async function getOracleContract (web3js) {
  const networkId = await web3js.eth.net.getId()
  return new web3js.eth.Contract(OracleJSON.abi, OracleJSON.networks[networkId].address)
}

// 監聽 Oracle Contract 發過來的 Event, 並依據不同的 Event 做不同的處理
async function filterEvents (oracleContract, web3js) {
  // GetLatestEthPriceEvent - 將 request 加進待處理的 queue
  oracleContract.events.GetLatestEthPriceEvent(async (err, event) => {
    if (err) {
      console.error('Error on event', err)
      return
    }
    await addRequestToQueue(event)
  })
  // SetLatestEthPriceEvent - 回傳 ETH 價格後將 request 從待處理的 queue 移除
  oracleContract.events.SetLatestEthPriceEvent(async (err, event) => {
    if (err) {
      console.error('Error on event', err)
      return
    }
  })
}

// 將 request 加進待處理的 queue
async function addRequestToQueue(event) {
  // event.returnValues 是一個 object, 裡面欄位會跟 Oracle contract 定義的相同
  const callerAddress = event.returnValues.callerAddress
  const id = event.returnValues.id
  pendingRequests.push({ callerAddress, id })
}

async function processQueue(oracleContract, ownerAddress) {
  let processedRequests = 0
  while (pendingRequests.length > 0 && processedRequests < CHUNK_SIZE) {
    const req = pendingRequests.shift()
    await processRequest(oracleContract, ownerAddress, req.id, req.callerAddress)
    processedRequests++
  }
}

async function processRequest(oracleContract, ownerAddress, id, callerAddress) {
  let retries = 0
  while (retries < MAX_RETRIES) {
    try {
      // 從 Binance API 拉取 ETH 價格，這邊不太重要所以沒有特別定義
      const ethPrice = await client.retrieveLatestEthPrice()
      // 從 Binance 拉回的價格是浮點數，因為 EVM 不支援符點數所以需要對資料格式做處理後回傳給 Oracle Contract
      await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, ethPrice, id)
      return
    } catch (err) {
      // 如果 retry 次數達到 MAX_RETRIES, 就將 ETH 價格設為 0 後直接回傳給 Oracle Contract
      if (retries === MAX_RETRIES - 1) {
        await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, '0', id)
        return
      }
      retries++
    }
  }
}

// 對資料格式做處理（Float -> Integer）後回傳給 Oracle Contract
async function setLatestEthPrice (oracleContract, callerAddress, ownerAddress, ethPrice, id) {
  // 把小數點用 replace 去掉
  ethPrice = ethPrice.replace('.', '')
  const multiplier = new BN(10**10, 10)
  const ethPriceInt = (new BN(parseInt(ethPrice), 10)).mul(multiplier)
  const idInt = new BN(parseInt(id))
  try {
    await oracleContract.methods.setLatestEthPrice(ethPriceInt.toString(), callerAddress, idInt.toString()).send({ from: ownerAddress })
  } catch (error) {
    console.log('Error encountered while calling setLatestEthPrice.')
    // Do some error handling
  }
}

async function init() {
  // 連到指定的區塊鏈節點
  const { ownerAddress, web3js, client } = common.loadAccount(PRIVATE_KEY_FILE_NAME)
  // 取得 Oracle Contract 的 instance
  const oracleContract = await getOracleContract(web3js)
  // 監聽 Oracle Contract 發過來的 Event
  filterEvents(oracleContract, web3js)
  return { oracleContract, ownerAddress, client }
}

// 每隔一段時間處理一次 queue，若接到 SIGINT 就中斷 client 連線後退出 process
(async () => {
  const { oracleContract, ownerAddress, client } = await init()
  process.on( 'SIGINT', () => {
    console.log('Calling client.disconnect()')
    client.disconnect()
    process.exit( )
  })
  setInterval(async () => {
    await processQueue(oracleContract, ownerAddress)
  }, SLEEP_INTERVAL)
})()

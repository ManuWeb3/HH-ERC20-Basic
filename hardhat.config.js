// copied from Raffle

// all below are the plug-ins that we import, that were actually downloaded and installed by yarn / npm, present inside node_modules

require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
//require("hardhat-contract-sizer")
require("dotenv").config()

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
//const GAS_REPORT = process.env.GAS_REPORT     // does NOT work this way ??

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",                    //  1st kind of HH n/w = Hardhat Newtowrk. ALSO, you can change it to rinkeby and then no need to write "--network rinkeby"
                                                //  You can customize which network is used by default when running Hardhat by setting the config's defaultNetwork field. 
                                                //  If you omit this config, its default value is "hardhat".
  networks: {                                   //  The networks config field is an optional object where network names map to their configuration.
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,      // less is ok as it's a local network
    },
    localhost: {                  //  Default networks object = "localhost at the url"
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
      blockConfirmations: 1,      // less is ok as it's a local network
    },
    rinkeby: {                    // 2nd kind of HH n/w = JSON-RPC based networks (external nodes incl. dummy Ganache)
      chainId: 4,
      blockConfirmations: 6,      // more needed as it's a testnet
      url: RINKEBY_RPC_URL,
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],    // it's always an array + // undefined is a keyword here
      //saveDeployments: true,      // details later ??
    },
  },
  etherscan: {                    // we bring it up here for "verify"
    // yarn hardhhat (hh should work) verify --network <NETWORK_NAME> <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
    apiKey: {
      rinkeby: ETHERSCAN_API_KEY,
    },
  },
  contractSizer: {
    runOnCompile: false,
    only: ["Raffle"],
  },
  gasReporter: {
    enabled: true,                              // turned false for 'Testnet demo' section @ 10:55:46. Before this, it was set to true
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,       // needed for Gas Output
    token: "ETH",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.7",
      },
      {
        version: "0.4.24",
      },
    ],
  },
  namedAccounts: {            // namedAccounts is used to give a name to an account[0] (deployer), account[1] (player), I believe
    deployer:{
      default: 0,             // here this will by default take the first account as deployer
      1: 0,                   // similarly on mainnet it will take the first account as deployer. 
                              // Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
    player:{
      default: 1,             
    },
  },
  mocha: {
    timeout: 500000,           //  "timeout" keyword is set to 500,000 ms = 500 s max. Esle, default value is 40,000 ms = 40 s
                              //  more time needed for Rinkeby network, hence 200 ms => 300 ms
                              //  why we want to allocate so much of time, why not just 40s?
                              //  bcz our Promise takes time to resolve / reject.
                              //  Promise: inside unit test - ffRW() where we set up the Listener
  },
}

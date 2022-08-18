// copied from Raffle

const { ethers } = require("hardhat")

const networkConfig = {
    4: {
        name: "rinkeby",
        initialSupply: "50000000000000000000"         // 50 OT tokens like 50 ETH
        
    },
    31337: {
        name: "hardhat",
        initialSupply: "50000000000000000000"        // 50 OT tokens like 50 ETH
    }
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig, 
    developmentChains,
}
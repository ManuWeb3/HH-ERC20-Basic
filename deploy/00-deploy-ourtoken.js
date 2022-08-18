const {network, ethers, deployments} = require("hardhat")
const {developmentChains, networkConfig} = require("../helper-hardhat-config")
const {verify} = require("../utils/verify")

module.exports = async function ({getNamedAccounts, deployments}) {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()
    const chainId = network.config.chainId
    
    //  const decimals = 18                                              // hard-coded 50 ETH in wei below
    
    //  put BigNumber in quotes and then pass it on as an arg
    //  Reason - JS does not recognize numbers this big, so you have to pass such a no. as a string
    //  const initialSupply = "50000000000000000000"                        // more static approach = 50 ETH
    const initialSupply = networkConfig[chainId]["initialSupply"]     // lesser static approach, not hard-coded in the deploy script itself
    log(`Initial Supply has been set to: ${initialSupply}`)             // outputs that string BigNumber as a regular integer no.
    
    // args for the Constructor of OurToken.sol
    const args = [initialSupply]

    // deploy part
    log("Deploying OurToken.sol...")
    const ourToken = await deploy("OurToken", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations,
    })

    log("OurToken.sol deployed!!")
    log("---------------------------------------------------")

    if(!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying on Rinkeby.Etehrscan...")
        await verify(ourToken.address, args)
    }
}

module.exports.tags = ["all"]          // needed for running test scripts, deployed beforehand, but altogether not needed here bcz no Mocks
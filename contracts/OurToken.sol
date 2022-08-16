//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20  {                       // error - "abstract": 1. ERC20 has a constructor wit 2 args - must be supplied, if it's inherited (not just imported)
                                                    // 2. Second reason would have been "Interface-functions are not defined:, BUT now are defined in ERC20.sol itself
    constructor (uint256 initialSupply) ERC20 ("OurToken", "OT") {
        //  give initialSupply a run time value, set with decimals(), called internally here
        // initialSupply = initialSupply*10**decimals(); - set statically in the deploy script / config file
        _mint(msg.sender, initialSupply);           
        // The variables totalSupply and balances are now private implementation details of ERC20, 
        // and you can’t directly write to them. 
        // Instead, there is an internal _mint function that will do exactly this:
        // Encapsulating state like this makes it safer to extend contracts.

        // event Transfer is also included in _mint() as some clients rely on it. No chance to Forget this.
    }
}

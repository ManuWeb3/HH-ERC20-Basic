//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {                        // error - "abstract": 1. ERC20 has a constructor wit 2 args - must be supplied, if it's inherited (not just imported)
                                                    // 2. Second reason would have been "Interface-functions are not defined:, BUT now are defined in ERC20.sol itself
    constructor () ERC20("OurToken", "OT") {

    }

}

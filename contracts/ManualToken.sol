// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

error ManualToken__NotAllowedThisAmount();

//  Skipping the interface { } and approveAndCall() { }

contract ManualToken {

    //  All 'amount' is actually 'VALUE' in wei with 18 decimals in functions below

    //  public variables of the token - but we can make these private + getters to save Gas
    string public name;
    string public symbol;
    uint8 public decimals = 18;                                        //   strongly suggested default value
    uint256 public totalSupply;

    //  These create arrays for all data reg. Balances
    mapping (address => uint256) public balanceOf;                      // In reality, keep these private and make getter functions
    mapping (address => mapping(address => uint256)) public allowance;  //  we'd need an approve function to approve this transfer (_transferFrom)
    //  address1: Manu allowed address2: Priyanka to take uint256: amount from my balance  
    //  address1: Manu allowed address3: PC to take uint256: amount from my balance     
    //  address1: Manu allowed address4: Harsimran to take uint256: amount from my balance  

    //  events to notify clients on the Blockchain - state change upon Transfers, Approvals, and Burns.
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, uint256 _amount);

    //  All Functions, starting with the Constructor
    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) {    
        //  initial_supply duing contract creation, may change / be added to later
        //  This initial_supply is the count of tokens but we're dealing with the "_value" everywhere, that's why converetd to 18 decimals
        totalSupply = initialSupply * 10**uint256(decimals);
        name = tokenName;
        symbol = tokenSymbol;
        //  Give all initial supply to the owner only
        balanceOf[msg.sender] = totalSupply;        //  += also works but redundant bcz constructor won't ever be called again
    }

    //  Any transfer function will BASICALLY / minimalistically subtract "amount" from sender's balance and add it to the Rx's balance
    //  Only works when 1 person is sending money to another
    function _transfer (address from, address to, uint256 amount) internal {                    // only this Contract (any function here) can call it
        //  cutting short, and using require instead of Custom_error+revert
        
        //  use burn() intead
        require(to != address(0x0));
        //  check balances
        require(balanceOf[from] > amount);
        // check for overflows, not needed I believe in ^0.8.0, rather unchecked si used somewhere to save Gas when we're sure that no over/underflow is happening
        require((balanceOf[to] + amount) > balanceOf[to]);

        // For a future assertion, to check totalBalances(from + to) remaiend same
        uint256 previousBalance = balanceOf[from] + balanceOf[to];

        //  actual revisions of the balances (transfer)
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        // emit event upon Transfer
        emit Transfer(from, to, amount);
        // Assert
        assert((balanceOf[from]+balanceOf[to]) == previousBalance);

    }

    //  Additional functionalities - 
    //  some contract wants to interact with our token, we want to deposit tokens to a protocol, etc. 
    function _transferFrom(address _from, address _to, uint256 _amount) public returns (bool success){
        //  implements taking funds from a user: 2nd mapping
        //  Did address1: Patrick allow address 4: xyz to take uint256: amount from him ?
        //  Yes - then _transferFrom Patrick to you, you: msg.msg.sender will call the function by him(her)self
        if(_amount > allowance[_from][msg.sender]) {
            revert("ManualToken__NotAllowedThisAmount()");
        }
        //  update / revise the allowance after this transfer of funds
        allowance[_from][msg.sender] -= _amount;
        //  call transfer() func to update balances
        _transfer(_from, msg.sender, _amount);      //  _transfer(_from, _to, _amount); bcz _to has to enter his address during calling func.

        return true;
    }

    //  msg.sender will send tokens from his balance to '_to' address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;                                // return will be in the dead end of the function
    }

    //  Allowance set by address1: Patrick that address4: xyz can spend amount on address1's behalf (refer above)
    //  then anytime, actual transfer can take place by address2 by invoking _transferFrom() - mapping 2
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //  Burn? Destroy tokens irrevokably from the system, from own account (not others'), hence only param = self-value
    //  subtract tokens
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender]>= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;                      // this ensures that token _value is destroyed from system altogether, irreversibly
        emit Burn(msg.sender, _value);              // notify when burnt - 3rd (notification) event
        return true;
    }

    //  Burn - tokens from others' accounts
    //  Destroy tokens on behalf of _from but your allowance will also be destroyed / reduced by the same amount
    //  Must update system's totalSupply as well - irreversible destroy = burn
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        // _from should have at least that balance
        require(balanceOf[_from] >= _value);
        //  msg.sender's allowance from '_from' should be more than the _value
        require(allowance[_from][msg.sender] >= _value);

        //  Now, sub. from '_from'
        balanceOf[_from] -= _value;
        //  Also, sub. allowance of msg.sender approved by '_from', from '_from'
        allowance[_from][msg.sender] -= _value;
        //  Update Total Supply
        totalSupply -= _value;

        // Emit Burn event
        emit Burn(_from, _value);

        return true;
    }
}
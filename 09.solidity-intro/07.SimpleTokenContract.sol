pragma solidity ^0.4.18;

contract SimpleTokenContract {
    mapping(address => uint) balances;
    
    function SimpleTokenContract(uint initialAmount) public {
        balances[msg.sender] = initialAmount;
    }
    
    function balanceOf(address addr) public view returns(uint) {
        return balances[addr];
    }
    
    function transfer(address to, uint value) public {
        require(balances[msg.sender] >= value);
        require(balances[to] + value > balances[to]);
        
        balances[msg.sender] -= value;
        balances[to] += value;
    }
}
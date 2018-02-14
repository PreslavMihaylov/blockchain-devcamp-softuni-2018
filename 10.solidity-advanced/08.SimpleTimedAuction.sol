pragma solidity ^0.4.18;

contract TimedAuctionContract {
    mapping(address => uint) balances;
    uint duration = 1 minutes;
    uint start;
    address owner;
    
    
    function TimedAuctionContract(uint initialSupply) public {
        start = now;
        owner = msg.sender;
        balances[owner] = initialSupply;
    }
    
    function buyTokens(uint amount) public payable {
        require(now < start + duration);
        require(balances[msg.sender] + amount >= balances[msg.sender]);
        require(balances[owner] >= amount);
        
        balances[msg.sender] += amount;
        balances[owner] -= amount;
    } 
}

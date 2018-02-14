pragma solidity ^0.4.18;

contract TimedBlockAuctionContract {
    mapping(address => uint) balances;
    uint duration = 1;
    uint blockStart;
    address owner;
    
    function TimedBlockAuctionContract(uint initialSupply) public {
        blockStart = block.number;
        owner = msg.sender;
        balances[owner] = initialSupply;
    }
    
    function buyTokens(uint amount) public payable {
        require(block.number <= blockStart + duration);
        require(balances[msg.sender] + amount >= balances[msg.sender]);
        require(balances[owner] >= amount);
        
        balances[msg.sender] += amount;
        balances[owner] -= amount;
    } 
}

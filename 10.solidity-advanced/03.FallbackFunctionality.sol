pragma solidity ^0.4.18;

contract SenderContract {
    address owner;
    
    function SenderContract() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function getBalance() public view onlyOwner returns (uint) {
        return this.balance;
    }
    
    function deposit() public payable {
    }
    
    function transfer(address addr, uint amount) public onlyOwner {
        require(amount <= this.balance);
        
        addr.transfer(amount);
    }
}

contract RecipientContract {
    address owner;
    
    function RecipientContract() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function getBalance() public view onlyOwner returns (uint) {
        return this.balance;
    }
    
    function() public payable {
    }
}

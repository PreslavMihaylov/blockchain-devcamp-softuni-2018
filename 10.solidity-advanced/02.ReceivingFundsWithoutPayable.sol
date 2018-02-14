pragma solidity ^0.4.18;

contract CallableDeposit {
    address owner;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function CallableDeposit() public {
        owner = msg.sender;
    }
    
    function deposit() public payable {
    }
    
    function sendBalance(address addr) public onlyOwner {
        selfdestruct(addr);
    }
    
    function getBalance() public view onlyOwner returns (uint) {
        return this.balance;
    }
}

contract NoPayable {
    address owner;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function NoPayable() public {
        owner = msg.sender;
    }
    
    function getBalance() public view onlyOwner returns (uint) {
        return this.balance;
    } 
}

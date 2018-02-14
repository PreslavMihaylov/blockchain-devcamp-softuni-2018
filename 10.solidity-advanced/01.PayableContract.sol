pragma solidity ^0.4.18;

contract PayableContract {
    address owner;
    
    function PayableContract() public {
        owner = msg.sender;
    }
    
    function deposit() public payable {
    }
    
    function getBalance() public view returns(uint) {
        require(owner == msg.sender);
        
        return this.balance;
    }
}

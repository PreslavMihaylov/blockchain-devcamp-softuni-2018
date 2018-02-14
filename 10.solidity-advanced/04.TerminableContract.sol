pragma solidity ^0.4.18;

contract MainContract {
    address owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function MainContract() public {
        owner = msg.sender;
    }
    
    function deposit() public payable {
    }
    
    function getBalance() public view returns (uint) {
        return this.balance;
    }
}

contract TerminableContract is MainContract {
    function terminate() public onlyOwner {
        selfdestruct(owner);
    }
}

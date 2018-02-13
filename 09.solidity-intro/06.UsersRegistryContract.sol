pragma solidity ^0.4.18;

contract UsersRegistryContract {
    struct Account {
        string user;
        string email;
        address addr;
    }
    
    address owner;
    Account[] accounts;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    modifier isProperUser(address addr) {
        require(msg.sender == addr);
        _;
    }
    
    function UsersRegistryContract() public {
        owner = msg.sender;
    }
    
    function showEntry(uint index) public view onlyOwner returns (string user, string email, address addr) {
        require(accounts.length >= index);
        Account memory entry = accounts[index];
        
        return (entry.user, entry.email, entry.addr);
    }
    
    function addRegistry(string user, string email, address addr) public isProperUser(addr) {
        Account memory person;
        person.user = user;
        person.email = email;
        person.addr = addr;
        
        accounts.push(person);
    }
}
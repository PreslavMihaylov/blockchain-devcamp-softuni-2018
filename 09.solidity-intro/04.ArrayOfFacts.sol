pragma solidity ^0.4.18;

contract ArrayOfFactsContract {
    string[] facts;
    address owner;
    
    function ArrayOfFactsContract() public {
        owner = msg.sender;
    }
    
    function addFact(string _fact) public {
        require(owner == msg.sender);
        
        facts.push(_fact);
    }
    
    function showFact(uint _factIndex) public view returns (string) {
        require(facts.length > _factIndex);
        
        return facts[_factIndex];
    }
}
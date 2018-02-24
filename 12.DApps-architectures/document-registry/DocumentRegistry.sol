pragma solidity ^0.4.18;

contract DocumentRegistry {
    mapping(string => uint) documents;
    address contractOwner;

    function DocumentRegistry() public {
        contractOwner = msg.sender;
    }

    function add(string hash) public returns (uint) {
        require(msg.sender == contractOwner);

        uint dateAdded = block.timestamp;
        documents[hash] = dateAdded;

        return dateAdded;
    }

    function verify(string hash) public view returns (uint) {
        return documents[hash];
    }
}

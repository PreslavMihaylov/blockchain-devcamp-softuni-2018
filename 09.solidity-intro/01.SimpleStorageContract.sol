pragma solidity ^0.4.18;

contract SimpleStorageContract {
    uint256 storedData;
    
    function SimpleStorageContract() public {
        storedData = 0;
    }
    
    function set(uint256 _value) public {
        storedData = _value;
    }
    
    function get() constant public returns (uint256) {
        return storedData;
    }
}
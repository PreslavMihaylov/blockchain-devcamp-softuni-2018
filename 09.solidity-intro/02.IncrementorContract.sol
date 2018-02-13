pragma solidity ^0.4.18;

contract IncrementorContract {
    uint256 value;
    
    function IncrementorContract() public {
        value = 0;
    }
    
    function increment(uint256 _delta) public {
        value += _delta;
    }
    
    function get() constant public returns (uint256) {
        return value;
    }
}
pragma solidity ^0.4.18;

contract ShowInfoIndexedContract {
    event showInfoIndexedEvent(uint indexed price, uint indexed amount);
    
    function showInfoIndexed(uint price, uint amount) public {
        showInfoIndexedEvent(price, amount);
    }
}

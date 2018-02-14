pragma solidity ^0.4.18;

contract ShowInfoContract {
    event showInfoEvent(string, address);
    
    function showInfo(string text, address addr) public {
        showInfoEvent(text, addr);
    }
}

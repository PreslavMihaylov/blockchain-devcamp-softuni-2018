pragma solidity ^0.4.18;

contract ShowAddressContract {
    address owner;
    event showAddressEvent(address);
    
    function ShowAddressContract() public {
        owner = msg.sender;
    }
    
    function showAddress() public {
        showAddressEvent(owner);
    }
}

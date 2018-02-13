pragma solidity ^0.4.18;

contract PreviousInvokerContract {
    address previousInvoker;
    
    function PreviousInvokerContract() public {
        previousInvoker = 0;
    }
    
    function getPreviousInvoker() public returns (address) {
        address result = previousInvoker;
        previousInvoker = msg.sender;
        
        return result;
    }
}
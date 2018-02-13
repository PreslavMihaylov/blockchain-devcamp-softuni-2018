pragma solidity ^0.4.18;

contract RegistryOfCertificatesContract {
    mapping(string => uint) certificateHashes;
    address owner;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function RegistryOfCertificatesContract() public {
        owner = msg.sender;
    }
    
    function register(string _certHash) public onlyOwner {
        certificateHashes[_certHash] = 1;
    }
    
    function verify(string _certHash) public view returns (bool) {
        return certificateHashes[_certHash] == 1;
    }
}
pragma solidity ^0.4.18;

contract TokenShares {
    address owner;
    uint price;
    uint dividend;
    mapping(address => uint) sharesPerAddress;
    mapping(address => bool) addressesAllowedToWithdraw;
    address[] shareHolders;
    
    function TokenShares(uint initialSupply, uint _price, uint _dividend) public {
        owner = msg.sender;
        sharesPerAddress[owner] = initialSupply;
        price = _price * 1 ether;
        dividend = _dividend * 1 ether;
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function buyShares(uint amount) public payable {
        require(sharesPerAddress[owner] >= amount);
        require(sharesPerAddress[msg.sender] + amount >= sharesPerAddress[msg.sender]);
        require(msg.value == price * amount);
        
        sharesPerAddress[msg.sender] += amount;
        sharesPerAddress[owner] -= amount;
        shareHolders.push(msg.sender);
    }
    
    function withdraw() public {
        require(sharesPerAddress[msg.sender] > 0);
        require(this.balance >= sharesPerAddress[msg.sender] * price);
        require(addressesAllowedToWithdraw[msg.sender] == true);
        
        msg.sender.transfer(sharesPerAddress[msg.sender] * price);
        sharesPerAddress[msg.sender] = 0;
    }
    
    function allowWithdraw(address addr) public onlyOwner {
        addressesAllowedToWithdraw[addr] = true;   
    }
    
    function depositEarnings() public payable onlyOwner {
    }
    
    function pricePerShare() public view returns (uint) {
        return price / 1 ether;
    }
    
    function calculateTransactionWorth(uint amount) public view returns (uint) {
        return (amount * price) / 1 ether;
    }
    
    function getShareholders() public view onlyOwner returns (address[]) {
        return shareHolders;
    }
    
    function getBalance() public view onlyOwner returns (uint) {
        return this.balance / 1 ether;
    }
    
    function getNumberOfShares() public view returns (uint) {
        return sharesPerAddress[msg.sender];
    }
}

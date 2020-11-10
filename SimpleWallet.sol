pragma solidity >=0.4.22 <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract SimpleWallet is Ownable {
    
    mapping(address => uint) public allowance;
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }
    
    modifier isAllowed(uint _amount) {
        require(allowance[msg.sender] >= _amount, "You're not allowed");
        _;
    }

    function withdrawMoney(address payable _to, uint _amount) public isAllowed(_amount) {
        _to.transfer(_amount);
    }
    
    receive () external payable {
        
    }
}

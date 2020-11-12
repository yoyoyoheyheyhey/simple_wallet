pragma solidity >=0.4.22 <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Allowance is Ownable {

    using SafeMath for uint;

    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    mapping(address => uint) public allowance;
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You're not allowed");
        _;
    }
    
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(msg.sender, _who, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
}


contract SimpleWallet is Allowance {
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    function withdrawMoneyTo(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "You don't have enough funds stored in the smart contract");
        if(owner() != msg.sender) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("Can't renounce ownership here");
    }
    
    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}

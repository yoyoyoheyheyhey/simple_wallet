pragma solidity >=0.4.22 <0.7.0;

contract SimpleWallet {
    
    function withdrawMoney(address payable _to, uint _amount) public {
        _to.transfer(_amount);
    }
    
    function () external payable {
        
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken {
    mapping(address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }
    
    function decimals() public pure returns (uint8) {
        return 18;
    }
    
    function totalSupply() public pure returns (uint) {
        return 100 ether;
    }
    
    function balanceOf(address _owner) public view returns (uint) {
        return s_balances[_owner];
    }
    
    function transfer(address _to, uint _value) public returns (bool) {
        require(s_balances[msg.sender] >= _value);
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        return true;
    }
}
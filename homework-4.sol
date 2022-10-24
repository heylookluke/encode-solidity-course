// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {
    uint public totalSupply = 10000;
    Payment[] public records;

    address owner;    
    
    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    event TotalSupplyIncreased(uint newTotalSupply);
    event TransferActivity(uint amount, address receivingAddress);

    struct Payment {
        uint amount;
        address recipient;
    }

    mapping (address => uint) public balances;
    mapping (address => Payment[]) internal transactions;

    modifier onlyOwner() {
        if(msg.sender == owner){
            _;
        }
    }

    function increaseTotalSupply() public onlyOwner {
        totalSupply = totalSupply + 1000;
        emit TotalSupplyIncreased(totalSupply);
    }

    function addTransaction(uint _amount, address _recipient) public {
        records.push(Payment({amount:_amount,recipient:_recipient}));
    }

    function getRecords(address walletId) public view returns(Payment[] memory){
        return transactions[walletId];
    }

    function transferTokens(uint amount, address receivingAddress) public {
        require (balances[msg.sender] > amount);
        
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receivingAddress] = balances[receivingAddress] + amount;
        addTransaction(amount, receivingAddress);
        transactions[msg.sender] = records;
        
        emit TransferActivity(amount, receivingAddress);
    }
}

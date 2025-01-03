// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "foundry-fund-me/FundMe.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function setUp() public {}

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentlyDeployed);
    }

    function fundFundMe(address mostRecentlyDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployment)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function setUp() public {}

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed);
    }

    function withdrawFundMe(address mostRecentlyDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployment)).withdraw();
        vm.stopBroadcast();
    }
}

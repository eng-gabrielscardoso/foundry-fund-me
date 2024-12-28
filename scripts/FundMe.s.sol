// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from 'forge-std/Script.sol';
import {FundMe} from "foundry-fund-me/FundMe.sol";

contract FundMeScript is Script {
    FundMe public fundMe;

    function setUp() public {}

    function run() external returns (FundMe) {
        vm.startBroadcast();

        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        vm.stopBroadcast();

        return fundMe;
    }
}

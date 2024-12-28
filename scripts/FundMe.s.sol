// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from 'forge-std/Script.sol';
import {FundMe} from "foundry-fund-me/FundMe.sol";

contract FundMeScript is Script {
    FundMe public fundMe;

    function setUp() public {}

    function run() external returns (FundMe) {
        vm.startBroadcast();

        fundMe = new FundMe();

        vm.stopBroadcast();

        return fundMe;
    }
}

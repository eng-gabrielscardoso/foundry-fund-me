// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from 'forge-std/Script.sol';
import {FundMe} from "foundry-fund-me/FundMe.sol";
import {HelperConfig} from './HelperConfig.s.sol';

contract FundMeScript is Script {
    FundMe public fundMe;
    HelperConfig public helperConfig = new HelperConfig();

    function setUp() public {}

    function run() external returns (FundMe) {
        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();

        fundMe = new FundMe(ethUsdPriceFeed);

        vm.stopBroadcast();

        return fundMe;
    }
}

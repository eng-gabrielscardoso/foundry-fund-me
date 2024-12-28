// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from 'forge-std/Test.sol';

import { FundMe } from 'foundry-fund-me/FundMe.sol';

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() public {
        fundMe = new FundMe();
    }
}

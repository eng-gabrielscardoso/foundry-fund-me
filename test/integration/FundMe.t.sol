// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {FundFundMe, WithdrawFundMe} from "../../scripts/Interactions.s.sol";
import {FundMeScript} from "../../scripts/FundMe.s.sol";
import {FundMe} from "foundry-fund-me/FundMe.sol";

contract FundMeIntegrationTest is Test {
    FundMe public fundMe;

    uint256 constant GAS_PRICE = 1;
    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("Makise Kurisu");
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        fundMe = new FundMeScript().run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}

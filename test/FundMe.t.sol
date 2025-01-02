// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {FundMeScript} from "../scripts/FundMe.s.sol";
import {FundMe} from "foundry-fund-me/FundMe.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("Okabe Rintarou");
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        fundMe = new FundMeScript().run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    /**
     * What can we do to work with addresses outside our system?
     *
     * 1. Unit
     *   - Testing a specific part of our code
     * 2. Integration
     *   - Testing how our code works with other parts of our code
     * 3. Forked
     *   - Testing our code on a simulated real environment
     * 4. Staging
     *   - Testing our code in a real environment that is not prod
     */
    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);

        assertEq(amountFunded, SEND_VALUE);
    }
}

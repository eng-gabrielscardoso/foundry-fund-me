// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMeScript} from "../scripts/FundMe.s.sol";
import {FundMe} from "foundry-fund-me/FundMe.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("Okabe Rintarou");
    uint256 constant STARTING_BALANCE = 100 ether;

    modifier funded() {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();

        _;
    }

    function setUp() public {
        fundMe = new FundMeScript().run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
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

    function testFundUpdatesFundedDataStructure() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);

        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address address_funder = fundMe.getFunder(0);

        assertEq(address_funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);

        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        console.log("Owner Balance: ", fundMe.getOwner().balance);
        console.log("FundMe Balance: ", address(fundMe).balance);
        console.log("Starting Owner Balance: ", startingOwnerBalance);
        console.log("Starting FundMe Balance: ", startingFundMeBalance);

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }
}

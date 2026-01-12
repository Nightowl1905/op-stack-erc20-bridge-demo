// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "../lib/forge-std/src/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/Deploy_MyToken.s.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint256 public constant STARTING_BLANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(bob, STARTING_BLANCE);
    }

    function testBobBalance() public view {
        uint256 bobBalance = myToken.balanceOf(bob);
        assertEq(bobBalance, STARTING_BLANCE);
    }

    function testAllowanceSuccess() public {
        uint256 bobAllows = 50 ether;

        vm.prank(bob);
        myToken.approve(alice, bobAllows);

        uint256 aliceGets = 20 ether;
        vm.prank(alice);
        myToken.transferFrom(bob, alice, aliceGets);

        assertEq(myToken.balanceOf(alice), aliceGets);
        assertEq(myToken.balanceOf(bob), STARTING_BLANCE - aliceGets);
    }

    function testTransferExceedsAllowance() public {
        uint256 bobAllows = 50 ether;

        vm.prank(bob);
        myToken.approve(alice, bobAllows);

        uint256 aliceGetsMore = 200 ether;
        vm.expectRevert();
        vm.prank(alice);
        myToken.transferFrom(bob, alice, aliceGetsMore);
        assertEq(myToken.balanceOf(bob), STARTING_BLANCE);
    }
}

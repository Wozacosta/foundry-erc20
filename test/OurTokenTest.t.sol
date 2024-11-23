// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ot;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ot = deployer.run();

        vm.prank(address(msg.sender));
        ot.transfer(bob, STARTING_BALANCE);
    }

    function testInitialSupply() public {
        // Validate the total supply is as expected
        assert(ot.totalSupply() == deployer.INITIAL_SUPPLY());
    }

    function testBobBalance() public {
        assertEq(ot.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend token on his behalf
        vm.prank(bob);
        ot.approve(alice, initialAllowance);

        assertEq(ot.allowance(address(bob), address(alice)), initialAllowance);
        uint256 transferAmount = 500;
        vm.prank(alice);
        ot.transferFrom(bob, alice, transferAmount);

        assertEq(ot.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ot.balanceOf(alice), transferAmount);
    }

    function testCannotTransferMoreThanBalance() public {
        // Bob attempts to transfer more than his balance
        uint256 excessiveAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        vm.expectRevert();
        ot.transfer(alice, excessiveAmount);
    }

    function testTransferRevertsWhenNoAllowance() public {
        // Alice attempts to transfer tokens from Bob without allowance
        vm.prank(alice);
        vm.expectRevert();
        ot.transferFrom(bob, alice, 1 ether);
    }
}

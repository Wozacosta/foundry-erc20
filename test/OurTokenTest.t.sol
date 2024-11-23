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
    
    function testBobBalance() public {
        assertEq(ot.balanceOf(bob), STARTING_BALANCE);
    }
    
}
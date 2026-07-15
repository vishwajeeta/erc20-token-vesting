// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MockToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TokenVestingEscrow} from "../src/TokenVestingEscrow.sol";

contract TokenVestingEscrowTest is Test {
    MyToken token;
    TokenVestingEscrow vesting;

    address owner = address(this);
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    uint256 constant INITIAL_SUPPLY = 1_000_000 ether;

    uint256 constant ALLOCATION = 1200 ether;

    uint256 constant CLIFF = 90 days;

    uint256 constant DURATION = 365 days;

    function setUp() public {
        token = new MyToken(owner);
        token.mint(owner, INITIAL_SUPPLY);
        vesting = new TokenVestingEscrow(owner, IERC20(address(token)), block.timestamp, CLIFF, DURATION);
        token.transfer(address(vesting), 50000 ether);
    }

    function testAllocateBeneficiary() public {
        vesting.allocateBeneficiary(alice, ALLOCATION);
        (uint256 allocation, uint256 claimed) = vesting.beneficiaries(alice);
        assertEq(allocation, ALLOCATION);

        assertEq(claimed, 0);

        assertEq(vesting.totalAllocated(), ALLOCATION);
    }

    function testNonOwnerCannotAllocate() public {
        vm.prank(alice);

        vm.expectRevert();

        vesting.allocateBeneficiary(bob, ALLOCATION);
    }
}

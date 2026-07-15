// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MockToken.sol";

contract MockTokenTest is Test {
    MyToken public mockToken;

    function setUp() public {
        mockToken = new MyToken(msg.sender);
        mockToken.mint(msg.sender,10000000);
    }

    function test_balanceof() public {
        mockToken.balanceOf(msg.sender);
    }
}

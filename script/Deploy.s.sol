// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script, console2} from "forge-std/Script.sol";

import {MyToken} from "../src/MockToken.sol";
import {TokenVestingEscrow} from "../src/TokenVestingEscrow.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Deploy is Script {
    // Token configuration
    uint256 constant INITIAL_SUPPLY = 1_000_000 ether;
    uint256 constant VESTING_FUND = 50_000 ether;

    // Vesting configuration
    uint256 constant CLIFF = 90 days;
    uint256 constant DURATION = 365 days;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address owner = vm.addr(deployerPrivateKey);

        // ---------------------------------------------------------
        // Deploy ERC20 Token
        // ---------------------------------------------------------

        MyToken token = new MyToken(owner);

        token.mint(owner, INITIAL_SUPPLY);

        console2.log("Token deployed:");
        console2.log(address(token));

        // ---------------------------------------------------------
        // Deploy Vesting Contract
        // ---------------------------------------------------------

        TokenVestingEscrow vesting = new TokenVestingEscrow(
            owner,
            IERC20(address(token)),
            block.timestamp,
            CLIFF,
            DURATION
        );

        console2.log("Vesting deployed:");
        console2.log(address(vesting));

        // ---------------------------------------------------------
        // Fund Vesting Contract
        // ---------------------------------------------------------

        token.transfer(address(vesting), VESTING_FUND);

        console2.log("Transferred tokens to vesting contract:");
        console2.log(VESTING_FUND);

        console2.log("-----------------------------------");
        console2.log("Deployment Successful");
        console2.log("-----------------------------------");
        console2.log("Owner:");
        console2.log(owner);

        console2.log("Token:");
        console2.log(address(token));

        console2.log("Vesting:");
        console2.log(address(vesting));

        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenVestingEscrow is Ownable, Pausable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    error ZeroAddress();
    error ZeroAmount();
    error InvalidCliffDuration();
    error BeneficiaryAlreadyAllocated();
    error NothingToClaim();
    error InsufficientTokenBalance();
    error InsufficientContractBalance();

    event BeneficiaryAllocated(address indexed beneficiary, uint256 amount);
    event TokensClaimed(address indexed beneficiary, uint256 amount);
    event UnallocatedTokensWithdrawn(address indexed to, uint256 amount);
    event VestingScheduleConfigured(uint256 vestingStart, uint256 cliffDuration, uint256 vestingDuration);

    // @notice Token address given to the constructor with the alloted amount
    IERC20 public immutable token;

    uint256 public immutable vestingStart;
    uint256 public immutable cliffDuration;
    uint256 public immutable vestingDuration;

    uint256 public totalAllocated;
    uint256 public totalClaimed;

    // @notice Stores vesting information for a beneficiary.
    struct Beneficiary {
        uint256 allocation;
        uint256 claimed;
    }


    // mapping(address => Beneficiary) public beneficiaries;
    mapping(address beneficiary => Beneficiary vesting) public beneficiaries;


    constructor(
        address initialOwner,
        IERC20 token_,
        uint256 vestingStart_,
        uint256 cliffDuration_,
        uint256 vestingDuration_
    ) Ownable(initialOwner) {
        if (address(token_) == address(0)) revert ZeroAddress();

        if (vestingStart_ == 0) revert ZeroAmount();

        if (cliffDuration_ > vestingDuration_) revert InvalidCliffDuration();

        if (vestingDuration_ == 0) revert ZeroAmount();

        token = token_;
        vestingStart = vestingStart_;
        cliffDuration = cliffDuration_;
        vestingDuration = vestingDuration_;

        emit VestingScheduleConfigured(vestingStart_, cliffDuration_, vestingDuration_);
    }

    function allocateBeneficiary(address beneficiary, uint256 amount) public onlyOwner {
        if (beneficiary == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        if (token.balanceOf(address(this)) < totalAllocated + amount) revert InsufficientContractBalance();
        if (beneficiaries[beneficiary].allocation != 0) revert BeneficiaryAlreadyAllocated();
        beneficiaries[beneficiary].allocation = amount;
        totalAllocated += amount;
        emit BeneficiaryAllocated(beneficiary, amount);
    }

    function vestedAmount(address beneficiary) public view returns (uint256) {
        Beneficiary memory user = beneficiaries[beneficiary];

        if (user.allocation == 0) {
            return 0;
        }

        if (block.timestamp < vestingStart + cliffDuration) {
            return 0;
        }

        if (block.timestamp >= vestingStart + vestingDuration) {
            return user.allocation;
        }

        uint256 elapsed = block.timestamp - vestingStart;

        return (user.allocation * elapsed) / vestingDuration;
    }

    function claimableAmount(address beneficiary) public view returns (uint256) {
        Beneficiary memory user = beneficiaries[beneficiary];

        if (user.allocation == 0) {
            return 0;
        }
        uint256 vested = vestedAmount(beneficiary);
        if (vested <= user.claimed){
            return 0;
        }

        return vested - user.claimed;
    }

    function remainingAmount(address beneficiary) public view returns (uint256) {
        Beneficiary memory user = beneficiaries[beneficiary];

        if (user.allocation == 0) {
            return 0;
        }

        return user.allocation - user.claimed;
    }

    //@dev Uses Checks-Effects-Interactions pattern
    function claim() external nonReentrant whenNotPaused {
        uint256 amount = claimableAmount(msg.sender);

        if (amount == 0) {
            revert NothingToClaim();
        }

        Beneficiary storage beneficiary = beneficiaries[msg.sender];

        beneficiary.claimed += amount;
        totalClaimed += amount;

        token.safeTransfer(msg.sender, amount);

        emit TokensClaimed(msg.sender, amount);
    }

    function withdrawUnallocated(address to, uint256 amount) external onlyOwner whenNotPaused {
        if (to == address(0)) {
            revert ZeroAddress();
        }

        if (amount == 0) {
            revert ZeroAmount();
        }

        uint256 reserved = totalAllocated - totalClaimed;
        uint256 balance = token.balanceOf(address(this));
        uint256 available = balance - reserved;

        if (amount > available) {
            revert InsufficientTokenBalance();
        }

        token.safeTransfer(to, amount);

        emit UnallocatedTokensWithdrawn(to, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}

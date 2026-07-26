set the environment variable for CMD
export PATH="$PATH:/home/codespace/.foundry/bin"








As the next step in the Web3 recruitment process, complete the following practical assignment independently using Solidity and Foundry.

Web3 Recruitment Test
ERC-20 Token Vesting and Claim Escrow

Build, test, deploy, and verify a token vesting system on BNB Smart Chain Testnet.
No frontend is required. The focus is on smart-contract architecture, Foundry testing, deployment, security, and your ability to explain the complete implementation.
1. Required contracts
Create:
A mock ERC-20 token
A token vesting and claim escrow contract
The vesting contract should hold tokens and release them gradually to approved beneficiaries.
2. Required functionality
The vesting contract must support:
Owner-controlled beneficiary allocation
Individual token allocation for each beneficiary
Vesting start time
Cliff period
Linear vesting after the cliff
Beneficiary claim function
Tracking of total allocated, vested, claimed, and remaining tokens
Prevention of double claiming
Pause and unpause
Reentrancy protection
Owner withdrawal of unallocated tokens
Input validation
Events for allocation, claims, withdrawals, pause, and configuration updates
Use OpenZeppelin contracts wherever appropriate.
3. Vesting behaviour
Example:
Allocation: 1,200 tokens
Vesting duration: 12 months
Cliff: 3 months
Expected behaviour:
Before the cliff: no tokens claimable
At the cliff: vested amount should reflect elapsed vesting time
During vesting: tokens unlock linearly
At completion: full allocation becomes claimable
Already claimed tokens must not be claimable again
4. Minimum Foundry tests
The test suite must include:
Successful beneficiary allocation
Non-owner allocation must fail
Claim before cliff must fail
Partial claim after cliff must succeed
Multiple claims must calculate correctly
Double claiming must be prevented
Full vesting must release the complete allocation
Paused contract must reject claims
Non-owner pause/unpause must fail
Owner withdrawal of unallocated tokens must succeed
Withdrawal of allocated beneficiary tokens must fail
Zero-address beneficiary must fail
Zero allocation must fail
Insufficient contract inventory must fail
Relevant events must be emitted correctly
Fuzz test for allocation or claim calculations
Invariant or state-consistency test where practical
Use Foundry time manipulation for vesting-period tests.
5. Deployment requirements
Deploy on:
BNB Smart Chain Testnet
Please:
Use a Foundry deployment script
Verify both contracts on BscScan Testnet
Fund the vesting contract with mock tokens
Add at least two beneficiary wallets
Execute at least one successful claim
Demonstrate one failed early claim
Keep ownership active
Use testnet assets only
6. GitHub repository
The public repository should contain:
Solidity source files
Foundry configuration
Unit tests
Fuzz or invariant tests
Deployment scripts
Verification instructions
.env.example
.gitignore
README
Do not upload:
Private keys
Seed phrases
RPC secrets
Real .env files
7. Submission requirements
Please share:
GitHub repository
Mock-token contract address
Vesting-contract address
BscScan verification links
Deployment transaction hashes
Beneficiary-allocation transaction hashes
Successful claim transaction hash
Failed early-claim evidence
Wallet addresses used
Forge test output
Gas report
Brief architecture explanation
8. Technical interview
After submission, the interview will be based on this project and the non-confidential aspects of your earlier work.
You will be required to:
Give a 10-minute live walkthrough
Run the Foundry tests live
Explain vesting calculations
Explain cliff and linear-release logic
Explain access control and withdrawal safety
Explain reentrancy protection
Show deployed contracts on BscScan
Make one small live code modification
Test the modification during the interview
You may use official documentation and standard libraries, but you must understand and be able to explain every part of the submission.


Deadline
14 July 2026, 8:00 PM IST

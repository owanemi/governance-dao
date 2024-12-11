// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Box} from "../src/Box.sol";
import {GovToken} from "../src/GovToken.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {TimeLock} from "../src/TimeLock.sol";

contract MyGovernorTest is Test {
    MyGovernor governor;
    Box box;
    GovToken govToken;
    TimeLock timelock;

    address USER = makeAddr("user");
    uint256 constant AMOUNT_TO_MINT = 1000 ether;

    uint256 public constant MIN_DELAY = 3600; //1 hour
    uint256 public constant VOTING_DELAY = 1; // how many blocks till a vote is active
    uint256 public constant VOTING_PERIOD = 50400;

    address[] proposers;
    address[] executors;

    uint256[] values;
    bytes[] calldatas;
    address[] targets;

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, AMOUNT_TO_MINT);

        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors, USER);

        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.TIMELOCK_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock));
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    // function testGovernanceUpdatesBox() public {
    //     uint256 valueToStore = 10;
    //     string memory description = "proposal to store 5 in box";
    //     bytes memory encodedFuntionCall = abi.encodeWithSignature("store(uint256)", valueToStore);

    //     values.push(0);
    //     calldatas.push(encodedFuntionCall);
    //     targets.push(address(box));

    //     // 1) we first propose to the DAO\u{1F624}
    //     uint256 proposalId = governor.propose(targets, values, calldatas, description);

    //     // view the state
    //     console.log("Proposal state: ", uint256(governor.state(proposalId)));

    //     vm.warp(block.timestamp + VOTING_DELAY + 1);
    //     vm.roll(block.number + VOTING_DELAY + 1);

    //     console.log("Proposal state: ", uint256(governor.state(proposalId)));

    //     // 2) vote
    //     string memory reason = "cuz i wanna increase the number duh";
    //     uint8 voteWay = 1; //means im voting yes

    //     vm.prank(USER);
    //     governor.castVoteWithReason(proposalId, voteWay, reason);

    //     vm.warp(block.timestamp + VOTING_PERIOD + 1);
    //     vm.roll(block.number + VOTING_PERIOD + 1);

    //     // 3) queue the txn
    //     bytes32 descriptionHash = keccak256(abi.encodePacked(description));
    //     governor.queue(targets, values, calldatas, descriptionHash);

    //     vm.warp(block.timestamp + VOTING_DELAY + 1);
    //     // vm.roll(block.number + VOTING_DELAY + 1);

    //     // 4) execute the txn
    //     governor.execute(targets, values, calldatas, descriptionHash);

    //     console.log("box number: ", box.getNumber());
    //     // assert(box.getNumber() == valueToStore);
    // }
}

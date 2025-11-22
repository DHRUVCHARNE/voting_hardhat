// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Voting.sol";
import {Test} from "forge-std/Test.sol";


contract VotingTest is Test {
    Voting voting;
    
    function setUp() public {
        // address owner=address(this);
        voting = new Voting();
    }

    modifier addSomeCandidates(){
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");
        voting.addCandidate("Carl");
        _;
    }

    function testOnlyOwnerCanAddCandidates() public {
        address user1 = makeAddr("USER1");
        vm.prank(user1);
        vm.expectRevert(Voting.RestrictedToOwner.selector);
        voting.addCandidate("Mark");
    }

    function testInvalidCandidateIndex() public {
        vm.expectRevert(Voting.InvalidCandidateIndex.selector);
        voting.vote(0);
    }

    function testNoCandidates() public {
        vm.expectRevert(Voting.NoCandidates.selector);
        string memory winner_name= voting.getWinner();
    }

    function testInitialCandidates() public addSomeCandidates() {
        
        // Fetch all candidates
        Voting.Candidate[] memory candidates = voting.getCandidates();

        require(candidates.length == 3, "Should have 2 candidates");

        // Candidate 0
        require(
            keccak256(bytes(candidates[0].name)) == keccak256("Alice"),
            "Candidate 0 name incorrect"
        );
        require(
            candidates[0].votes == 0,
            "Candidate 0 vote count incorrect"
        );

        // Candidate 1
        require(
            keccak256(bytes(candidates[1].name)) == keccak256("Bob"),
            "Candidate 1 name incorrect"
        );
        require(
            candidates[1].votes == 0,
            "Candidate 1 vote count incorrect"
        );
        require(
            keccak256(bytes(candidates[2].name)) == keccak256("Carl"),
            "Candidate 1 name incorrect"
        );
        require(
            candidates[2].votes == 0,
            "Candidate 1 vote count incorrect"
        );
    }
    function testVoteOnce() public addSomeCandidates() {
        voting.vote(0);
        Voting.Candidate[] memory candidates = voting.getCandidates();
        uint256 votes = candidates[0].votes;
        require(votes == 1,"Vote Count Should be 1");
    }
    function testCannotVoteTwice() public addSomeCandidates() {
        voting.vote(0);
        vm.expectRevert(Voting.YouHaveAlreadyVoted.selector);
        voting.vote(1);
    }

    function testGetWinnerSimple() public addSomeCandidates() {
    // Alice gets 2 votes, Bob gets 1, Carl gets 0
    voting.vote(0);
    vm.prank(makeAddr("USER1"));
    voting.vote(0);

    vm.prank(makeAddr("USER2"));
    voting.vote(1);

    string memory winner = voting.getWinner();

    require(
        keccak256(bytes(winner)) == keccak256(bytes("Alice")),
        "Winner should be Alice"
    );
}

function testGetWinnerTieReturnsFirst() public addSomeCandidates() {
    // Alice = 1 vote
    voting.vote(0);

    vm.prank(makeAddr("USER1"));
    voting.vote(1); // Bob also = 1 vote

    // In a tie, first max index wins (0 => Alice)
    string memory winner = voting.getWinner();

    require(
        keccak256(bytes(winner)) == keccak256(bytes("Alice")),
        "Tie should select first candidate"
    );
}

}

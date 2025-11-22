//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;


contract Voting {

    //Error
    error RestrictedToOwner();
    error YouHaveAlreadyVoted();
    error InvalidCandidateIndex();
    error NoCandidates();


    //Candidate struct
    struct Candidate {
        string name;
        uint votes;
    }
    //State Variables
    //immutable variables
    address private immutable i_owner;
    //regular state variables
    Candidate[] private candidates;
    mapping(address => bool) private hasVoted;

       //Events
      event CandidateAdded(string indexed c_name, uint indexed c_index);
      event VoteCastTo(uint indexed v_index);

       //Modifiers
    modifier onlyOwner() {
        require(msg.sender==i_owner,RestrictedToOwner());
        _;
    }

    //Constructor
    constructor() {
        i_owner = msg.sender;
    
    }
    //External functions
    //Add Candidate
    function addCandidate(string memory _name) external onlyOwner() {
    require(bytes(_name).length > 0, "Candidate name cannot be empty");
    candidates.push(Candidate(_name,0));
    uint256 candidate_index=candidates.length-1;
    emit CandidateAdded(_name,candidate_index);
    }
    //Vote for Candidate
    function vote(uint _index) external {
      require(_index<candidates.length,InvalidCandidateIndex());
      require(!hasVoted[msg.sender],YouHaveAlreadyVoted());
      candidates[_index].votes++;
      hasVoted[msg.sender]=true;
      emit VoteCastTo(_index);
    }
    //Get Candidate
    function getCandidates() external view returns (Candidate[] memory){
    return candidates;
    }
    // Current behavior: returns the first candidate in case of tie
    function getWinner() external view returns (string memory){
        require(candidates.length>0,NoCandidates());
        uint256 highestVotes=0;
        uint256 winnerIndex=0;
        for(uint i=0;i<candidates.length;i++){
            if(candidates[i].votes>highestVotes){
                highestVotes=candidates[i].votes;
                winnerIndex=i;
            }
            }
            return candidates[winnerIndex].name;
        }
        
        
    }

    
    

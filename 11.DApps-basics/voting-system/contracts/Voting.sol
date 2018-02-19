pragma solidity ^0.4.18;

contract Voting {
    mapping(bytes32 => uint) public votesCnt;
    bytes32[] candidates;

    function addCandidate(bytes32 candidate) public {
        votesCnt[candidate] = 0;
        candidates.push(candidate);
    }

    function voteFor(bytes32 candidate) public {
        require(isValidCandidate(candidate));

        votesCnt[candidate] += 1;
    }

    function totalVotesFor(bytes32 candidate) public view returns (uint) {
        require(isValidCandidate(candidate));

        return votesCnt[candidate];
    }

    function isValidCandidate(bytes32 candidate)
        public view returns (bool) {

        for (uint i = 0; i < candidates.length; ++i) {
            if (candidates[i] == candidate) {
                return true;
            }
        }

        return false;
    }
}

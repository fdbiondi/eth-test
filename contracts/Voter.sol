pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract Voter {

    uint256[] public votes;
    string[] public options;

    mapping(address => bool) hasVoted;

    constructor(string[] _options) public {
        options = _options;
        votes.length = _options.length;
    }

    function vote(uint256 option) public {
        require(option >= 0 && options.length > option, "Invalid option");
        require(!hasVoted[msg.sender]);

        votes[option] = votes[option] + 1;
        hasVoted[msg.sender] = true;
    }

    function getOptions() public view returns (string[]) {
        return options;
    }

    function getVotes() public view returns (uint256[]) {
        return votes;
    }
}

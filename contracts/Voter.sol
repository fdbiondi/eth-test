pragma solidity >=0.4.21 < 0.7.0;
pragma experimental ABIEncoderV2;

contract Voter {
    struct OptionPos {
        uint256 position;
        bool exists;
    }

    uint256[] public votes;
    string[] public options;

    mapping(address => bool) hasVoted;
    mapping(string => OptionPos) posOfOption;

    /**
     * Struct
     *   - Collection of fields
     *   - Like a class without methods
     *   - Can be nested
     *
     * mapping(string => Option) posOfOption;
     *
     * Memory in SC
     *   - Storage
     *     -- Contract state
     *     -- Persistent between calls
     *     -- SSTORE command -> up to 20000 gas (Expensive to use)
     *   - Memory
     *     -- Temporary variables
     *     -- Exists during a method execution
     *     -- MSTORE command -> 3 gas (Cheap to use)
     *
     * contract Foo {
     *   uint arr;
     *
     *   function method() {
     *     uint[] memory memoryArr = arr;
     *     memoryArr[0] = 0; // Modifies a copy
     *
     *     uint[] storage storageArr = arr;
     *     storageArr[0] = 0; // Modifies an original
     *   }
     * }
     */

    constructor(string[] _options) public {
        options = _options;
        votes.length = _options.length;

        for (uint i = 0; i < options.length; i++) {
            OptionPos memory optionPos = OptionPos(i, true);
            string optionName = options[i];
            posOfOption[optionName] = optionPos;
        }
    }

    function vote(uint256 option) public {
        require(option >= 0 && options.length > option, "Invalid option");
        require(!hasVoted[msg.sender], "Account has already voted");

        votes[option] = votes[option] + 1;
        hasVoted[msg.sender] = true;
    }

    function vote(string optionName) public {
        require(!hasVoted[msg.sender], "Account has already voted");

        OptionPos memory optionPos = posOfOption[optionName];
        require(optionPos.exists, "Option does not exist");

        votes[optionPos.position] = votes[optionPos.position] + 1;
        hasVoted[msg.sender] = true;
    }

    function getOptions() public view returns (string[]) {
        return options;
    }

    function getVotes() public view returns (uint256[]) {
        return votes;
    }
}

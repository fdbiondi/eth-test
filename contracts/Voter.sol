pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract Voter {

  uint[] public votes;
  string[] public options;

  /**
   * Mapping -> mapping([key-type] => [value-type]) mapName;
   * // Hash Map Java, unorderer_map C++
   * mapping (address => bool) hasVoted;
   * 
   * example:
   * mapping(string => uint) scoreFor; 
   * // Score value
   * scoreFor["Adam"] = 1;
   * // Get value
   * uint userScore = scoreFor["Adam"];
   * // Non existent key
   * uint userScore = scoreFor["non-existent-user"]; // 0 -> default value depends on the type 
   * 
   * Not supported
   *   - get total number of items stored
   *   - check if key exists
   *   - get all keys
   */

  mapping (address => bool) hasVoted;

  constructor(string[] _options) public {
    options = _options;
    votes.length = _options.length;
  }

  function vote(uint option) public {
    require(option >= 0 && options.length > option, "Invalid option");
    require(!hasVoted[msg.sender]);

    votes[option] = votes[option] + 1;
    hasVoted[msg.sender] = true;
  }

  function getOptions() public view returns (string[]) {
    return options;
  }

  function getVotes() public view returns (uint[]) {
    return votes;
  }
}

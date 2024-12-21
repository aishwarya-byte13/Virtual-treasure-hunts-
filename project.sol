// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VirtualTreasureHunt {
    struct Treasure {
        string clue;
        string answer;
        bool isFound;
        address finder;
    }

    address public owner;
    Treasure[] public treasures;

    event TreasureAdded(uint256 indexed treasureId, string clue);
    event TreasureFound(uint256 indexed treasureId, address indexed finder);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addTreasure(string memory _clue, string memory _answer) public onlyOwner {
        treasures.push(Treasure({
            clue: _clue,
            answer: _answer,
            isFound: false,
            finder: address(0)
        }));
        emit TreasureAdded(treasures.length - 1, _clue);
    }

    function getTreasure(uint256 _treasureId) public view returns (string memory clue, bool isFound, address finder) {
        require(_treasureId < treasures.length, "Treasure does not exist");
        Treasure memory treasure = treasures[_treasureId];
        return (treasure.clue, treasure.isFound, treasure.finder);
    }

    function solveTreasure(uint256 _treasureId, string memory _answer) public {
        require(_treasureId < treasures.length, "Treasure does not exist");
        Treasure storage treasure = treasures[_treasureId];
        require(!treasure.isFound, "Treasure has already been found");
        require(keccak256(abi.encodePacked(_answer)) == keccak256(abi.encodePacked(treasure.answer)), "Incorrect answer");

        treasure.isFound = true;
        treasure.finder = msg.sender;

        emit TreasureFound(_treasureId, msg.sender);
    }

    function totalTreasures() public view returns (uint256) {
        return treasures.length;
    }
}

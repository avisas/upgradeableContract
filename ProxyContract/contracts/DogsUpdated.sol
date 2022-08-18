pragma solidity 0.8.16;
import "./Storage.sol";

contract DogsUpdated is Storage {
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        initialize(msg.sender);
    }

    // only to run once.
    function initialize(address _owner) public {  //args used in constructor
        require(!_initialized); // will set _initialized to false
        owner = _owner;
        _initialized = true;
    }

    function getNumberOfDogs() public view returns (uint256) {
        return _uintStorage["Dogs"];
    }

    function setNumberOfDogs(uint256 toSet) public onlyOwner {
        _uintStorage["Dogs"] = toSet;
    }
}
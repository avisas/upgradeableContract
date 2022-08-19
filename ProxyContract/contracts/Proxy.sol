pragma solidity 0.8.16;
import "./Storage.sol";

contract Proxy is Storage {
    address currentAddress;

    constructor(address _currentAddress) public {
      owner = msg.sender;
      currentAddress = _currentAddress;
    }

    function upgrade(address _newAddress) public {
      require(msg.sender == owner);
      currentAddress = _newAddress;
    }

    //CALLBACK FUNCTION
    // redirect all functions that are not in this contract
    fallback() external payable {
        address implementation = currentAddress;
        require(currentAddress != address(0), "fallback: can't be zero address");
        bytes memory data = msg.data;

        //DELEGATECALL EVERY FUNCTION CALL
        assembly {
          let result := delegatecall(
                gas(),
                implementation,
                add(data, 0x20),
                mload(data),
                0,
                0
            )
          let size := returndatasize()
          let ptr := mload(0x40)
          returndatacopy(ptr, 0, size)
          switch result
          case 0 {
            revert(ptr, size)
          }
          default {
            return(ptr, size)
          }
        }
    }
}

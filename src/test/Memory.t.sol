pragma solidity ^0.8.0;

import "ds-test/test.sol";

library Array {
  struct Array {
    bytes self;
  }

  function create(uint8 length) internal pure returns (Array memory offset) {
    assembly {
      // get free memory pointer
      offset := mload(0x40)
      // update free memory pointer adding 
      // - (32 * len) to store array items
      // - (32 * 2) to store current index and length
      mstore(0x40, add(offset, mul(add(2, length), 0x20)))
      // store length of array in first 32 bytes
      mstore(add(0x20, offset), length)
    }
  }

  function push(Array memory self, uint256 element) internal pure {
    assembly {
      // get current index
      let current_index := mload(self)
      // check we wont overflow
      if eq(current_index, mload(add(0x20, self))) {
        revert(0,0)
      }
      // add element to array at (current_index * 32) + (2 * 32)
      mstore(add(self, mul(add(2, current_index), 0x20)), element)
      // update current index + 1
      mstore(self, add(0x01, current_index))
    }
  }

  function get(Array memory self, uint8 index) internal pure returns (uint256 element) {
    assembly {
      element := mload(add(self, mul(0x20, add(0x01, add(1, index))))) 
    }
  }
}

contract Memory is DSTest {
  using Array for Array.Array;

  function testTing() external {
    Array.Array memory pa = Array.create(5);
    pa.push(125);
    assertEq(pa.get(0), 125);
    emit log_uint(pa.get(0));
  }
}

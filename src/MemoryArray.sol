pragma solidity ^0.8.0;

library MemoryArray {
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
      mstore(0x40, add(offset, mul(add(0x02, length), 0x20)))
      // store length of array in first 32 bytes
      mstore(add(0x20, offset), length)
    }
  }

  function push(Array memory self, uint256 element) internal pure {
    assembly {
      let current_index := mload(self)
      // check we wont overflow
      if eq(current_index, mload(add(0x20, self))) {
        revert(0,0)
      }
      // add element to array at (current_index * 32) + (2 * 32)
      mstore(add(self, mul(add(0x02, current_index), 0x20)), element)
      // update current index + 1
      mstore(self, add(0x01, current_index))
    }
  }

  function get(Array memory self, uint8 index) internal pure returns (uint256 element) {
    assembly {
      element := mload(add(self, mul(0x20, add(0x02, index)))) 
    }
  }

  function min(Array memory self) internal pure returns (uint256 element) {
    assembly {
      let length := mload(self)
      element := mload(add(self, 0x40))
      for { let i := 0 } lt(i, length) { i := add(i, 0x01) }
      {
          let elm := mload(add(self, mul(0x20, add(0x01, add(0x01, i)))))
          if lt(elm, element) {
            element := elm
          }
      }
    }
  }

  function max(Array memory self) internal pure returns (uint256 element) {
    assembly {
      let length := mload(self)
      element := mload(add(self, 0x40))
      for { let i := 0 } lt(i, length) { i := add(i, 0x01) }
      {
          let elm := mload(add(self, mul(0x20, add(0x01, add(0x01, i)))))
          if gt(elm, element) {
            element := elm
          }
      }
    }
  }

  function sum(Array memory self) internal pure returns (uint256 value) {
    assembly {
      let length := mload(self)
      for { let i := 0 } lt(i, length) { i := add(i, 0x01) }
      {
          value := add(value, mload(add(self, mul(0x20, add(0x01, add(0x01, i))))))
      }
    }
  }

  function indexOf(Array memory self, uint256 element) internal pure returns (uint256 index) {
    index = type(uint256).max;
    assembly {
      let length := mload(self)
      for { let i := 0 } lt(i, length) { i := add(i, 0x01) }
      {
          let elm := mload(add(self, mul(0x20, add(0x01, add(0x01, i)))))
          if eq(elm, element) {
            index := i
          }
      }
    }
  }

  function len(Array memory self) internal pure returns (uint256 length) {
    assembly {
      length := mload(add(0x20, self))
    }
  }
}

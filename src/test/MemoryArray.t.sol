pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../MemoryArray.sol";

contract MemoryArrayTest is DSTest {
  using MemoryArray for MemoryArray.Array;

  function createArray() internal pure returns (MemoryArray.Array memory) {
    MemoryArray.Array memory array = MemoryArray.create(5);
    for (uint i = 0; i < 5; i++) {
      array.push(i + 1);
    }
    return array;
  }

  function testArrayIsSetup() external {
    MemoryArray.Array memory array = createArray(); 
    for (uint i = 0; i < 5; i++) {
      assertEq(array.get(uint8(i)), i + 1);
    }
  }

  function testArraySum() external {
    MemoryArray.Array memory array = createArray();
    assertEq(array.sum(), 15);
  }

  function testArrayMin() external {
    MemoryArray.Array memory array = createArray();
    assertEq(array.min(), 1);
  }

  function testArrayMax() external {
    MemoryArray.Array memory array = createArray();
    assertEq(array.max(), 5);
  }

  function testArrayIndexOf() external {
    MemoryArray.Array memory array = createArray();
    assertEq(array.indexOf(5), 4);
  }

  function testArrayLength() external {
    MemoryArray.Array memory array = createArray();
    assertEq(array.len(), 5);
  }
}

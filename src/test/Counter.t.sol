pragma solidity ^0.8.0;

import "ds-test/test.sol";

library Counters {
  struct Counter {
    uint256 _value; // default: 0
  }
  
  function current(Counter storage self) internal view returns (uint256 value) {
    assembly {
      value := sload(self.slot)
    }
  }

  function increment(Counter storage self) internal {
    assembly {
      sstore(self.slot, add(sload(self.slot), 0x01))
    }
  }

  function decrement(Counter storage self) internal {
    assembly {
      let current_value := sload(self.slot)
      if eq(current_value, 0) {
        revert(0,0)
      }
      sstore(self.slot, sub(current_value, 0x01))
    }
  }

  function reset(Counter storage self) internal {
    assembly {
      sstore(self.slot, 0)
    }
  }
}

contract TestCounters is DSTest {
  using Counters for Counters.Counter;

  Counters.Counter public counter;

  function testCurrent() external {
    assertEq(counter.current(), 0);
  } 

  function testIncrement() external {
    counter.increment();
    assertEq(counter.current(), 1);
  }

  function testDecrement() external {
    counter.increment();
    counter.increment();
    counter.decrement();
    assertEq(counter.current(), 1);
  }

  function testFailDecrementUnderflow() external {
    counter.decrement();
  }

  function testReset() external {
    counter.increment();
    assertEq(counter.current(), 1);
    counter.reset();
    assertEq(counter.current(), 0);
  }
}

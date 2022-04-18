pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../Counters.sol";

contract CountersTest is DSTest {
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

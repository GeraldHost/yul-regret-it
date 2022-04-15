pragma solidity ^0.8.0;

import "ds-test/test.sol";

contract GasToken is DSTest {
  function exspensiveShit(uint size) internal {
    for(uint i = 0; i < size; i++) {
      assembly {
        sstore(i, 1)
      }
    }
  }

  function destroyShit(uint size) internal {
    for(uint i = 0; i < size; i++) {
      assembly {
        sstore(i, 0)
      }
    }
  }

  function testExpensiveShit() external {
    exspensiveShit(1000);
  }

  function testExpensiveThenDestroyShit() external {
    exspensiveShit(1000);
    destroyShit(1000);
  }

}

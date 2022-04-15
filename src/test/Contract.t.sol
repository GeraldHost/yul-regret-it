// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";

contract ContractTest1 is DSTest {
  function accountToStorageOffset(address account) internal view returns (uint256 offset) {
    assembly {
      offset := add(0x1000, account)
    }
  }

  function updateAccountBalance(address account, uint value) internal {
    uint offset = accountToStorageOffset(account);
    assembly {
      sstore(offset, add(sload(offset), value))
    }
  }

  function getAccountBalance(address account) internal view returns (uint256 bal) {
    uint offset = accountToStorageOffset(account);
    assembly {
      bal := sload(offset)
    }
  }

  function testExample() public {
    uint balanceBefore = getAccountBalance(address(1));
    emit log_uint(balanceBefore);

    updateAccountBalance(address(1), 100);

    uint balanceAfter = getAccountBalance(address(1));
    emit log_uint(balanceAfter);
  }
}

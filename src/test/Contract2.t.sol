// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";

contract ContractTest2 is DSTest {
  mapping(address => uint) public balances;

  function updateAccountBalance(address account, uint value) internal {
    balances[account] += value;
  }

  function getAccountBalance(address account) internal view returns (uint256) {
    return balances[account];
  }

  function testExample() public {
    uint balanceBefore = getAccountBalance(address(1));
    emit log_uint(balanceBefore);

    updateAccountBalance(address(1), 100);

    uint balanceAfter = getAccountBalance(address(1));
    emit log_uint(balanceAfter);
  }
}

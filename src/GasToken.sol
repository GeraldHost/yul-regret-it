pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "./ERC20.sol";

contract GasToken is ERC20 {
  function mint(address to, uint amount) public override {
    uint offset = getAccountOffset(to);
    assembly {
      let total_supply := sload(0x01)
      for { let i := add(total_supply, 0x01) } lt(i, amount) { i := add(i, 0x01) }
      {
        sstore(i, 0x01)
      }
      sstore(offset, add(sload(offset), amount))
      sstore(0x01, add(sload(0x01), amount))
    }
  }

  function burn(address account, uint amount) public override {
    uint offset = getAccountOffset(account);
    assembly {
      let total_supply := sload(0x01)
      for { let i := sub(total_supply, amount) } lt(i, total_supply) { i := add(i, 0x01) }
      {
        sstore(i, 0)
      }
      if iszero(eq(account, caller())) {
        revert(0,0)
      }
      let bal := sload(offset)
      if iszero(iszero(lt(bal, amount))) {
        // balance is less than amount
        revert(0,0)
      }
      sstore(offset, sub(bal, amount))
    }
  }
}

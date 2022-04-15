pragma solidity ^0.8.0;

import "ds-test/test.sol";

contract ERC20 is DSTest {
  function accountOffset(address account) internal view returns (uint offset) {
    assembly {
      offset := add(0x1000, account)
    }
  }

  function balanceOf(address account) public view returns (uint bal) {
    uint offset = accountOffset(account);
    assembly {
      bal := sload(offset)
    }
  }

  function totalSupply() public view returns (uint supply) {
    assembly {
      supply := sload(0x01)
    }
  }

  function transfer(address to, address from, uint amount) public {
    uint toOffset = accountOffset(to);
    uint fromOffset = accountOffset(from);

    assembly {
      let fromBal := sload(fromOffset)
      if iszero(iszero(lt(fromBal, amount))) { revert(0, 0) }
      sstore(toOffset, add(sload(toOffset), amount))
      sstore(fromOffset, sub(fromBal, amount))
    }
  }

  function mint(address to, uint amount) public {
    uint offset = accountOffset(to);
    assembly {
      sstore(offset, add(sload(offset), amount))
    }
  }

  function testToken() public {
    emit log("first");
    uint bef = balanceOf(address(1));
    emit log_uint(bef);
    assert(bef == 0);
    mint(address(1), 100);
    uint aft = balanceOf(address(1));
    assert(aft == 100);
    emit log_uint(aft);

    {
      emit log("second");
      uint bef = balanceOf(address(2));
      emit log_uint(bef);
      assert(bef == 0);
      transfer(address(2), address(1), 100);
      uint aft = balanceOf(address(2));
      assert(aft == 100);
      emit log_uint(aft);
      emit log_uint(balanceOf(address(1)));
    }
  }
}

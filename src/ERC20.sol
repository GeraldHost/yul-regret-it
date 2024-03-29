pragma solidity ^0.8.0;

contract ERC20 {

  /*----------------------------------------------------
    Offsets
  ----------------------------------------------------*/

  function getAccountOffset(address account) internal pure returns (uint offset) {
    assembly {
      // account offset is 4096 + account
      offset := add(0x1000, account)
    }
  }

  function getAllowanceOffset(address account, address spender) internal pure returns (uint offset) {
    offset = getAccountOffset(account);
    assembly {
      // store offset in mem[0..32]
      mstore(0, offset)
      // store spender in mem[0..32]
      mstore(0x20, spender)
      // offset is hash off mem[0..64]
      offset := keccak256(0, 0x40)
    }
  }

  /*----------------------------------------------------
    View functions 
  ----------------------------------------------------*/

  function balanceOf(address account) public view returns (uint bal) {
    uint offset = getAccountOffset(account);
    assembly {
      bal := sload(offset)
    }
  }

  function totalSupply() public view returns (uint supply) {
    assembly {
      // load from slot 1
      supply := sload(0x01)
    }
  }

  function allowance(address spender, address account) public view returns (uint amount) {
    uint offset = getAllowanceOffset(account, spender);
    assembly {
      amount := sload(offset)
    }
  }

  /*----------------------------------------------------
    State updates 
  ----------------------------------------------------*/

  function mint(address to, uint amount) public virtual {
    uint offset = getAccountOffset(to);
    assembly {
      sstore(offset, add(sload(offset), amount))
      sstore(0x01, add(sload(0x01), amount))
    }
  }

  function transfer(address from, address to, uint amount) public {
    uint fromOffset = getAccountOffset(from);
    uint toOffset = getAccountOffset(to);

    assembly {
      if iszero(eq(from, caller())) {
        // caller is not from address
        revert(0,0)
      }
      let fromBal := sload(fromOffset)
      if iszero(iszero(lt(fromBal, amount))) { 
        // from balance is less than amount
        revert(0, 0) 
      }
      sstore(toOffset, add(sload(toOffset), amount))
      sstore(fromOffset, sub(fromBal, amount))
    }
  }

  function transferFrom(address from, address to, uint amount) public {
    uint fromOffset = getAccountOffset(from);
    uint toOffset = getAccountOffset(to);
    uint allowanceOffset = getAllowanceOffset(from, to);
    assembly {
      let fromBal := sload(fromOffset)
      if iszero(iszero(lt(fromBal, amount))) {
        // from balance is less than amount
        revert(0,0)
      }
      if lt(sload(allowanceOffset), amount) {
        // allowance is less than amount
        revert(0,0)
      }
      sstore(toOffset, add(sload(toOffset), amount))
      sstore(fromOffset, sub(fromBal, amount))
    }
  }

  function approve(address account, address spender, uint amount) public {
    uint offset = getAllowanceOffset(account, spender);
    assembly {
      // can only be called by account
      if iszero(eq(account, caller())) {
        revert(0,0)
      }
      sstore(offset, amount)
    }
  }
  
  function burn(address account, uint amount) public virtual {
    uint offset = getAccountOffset(account);
    assembly {
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

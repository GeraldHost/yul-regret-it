pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../ERC20.sol";

interface CheatCodes {
  function prank(address) external;
  function startPrank(address) external;
  function stopPrank() external;
}


contract GasTokenTest is DSTest {

  /*----------------------------------------------------
    Tests 
  ----------------------------------------------------*/
  CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

  address public constant ALICE = address(420);
  address public constant BOB = address(69);

  uint public constant initialBalance = 1000000 ether;
  
  ERC20 public token;

  function setUp() external {
    token = new ERC20();
    token.mint(ALICE, initialBalance);
    token.mint(BOB, initialBalance);
  }

  function testBalanceOf() external {
    assertEq(token.balanceOf(ALICE), initialBalance); 
    assertEq(token.balanceOf(BOB), initialBalance); 
  }

  function testTotalSupply() external {
    assertEq(token.totalSupply(), initialBalance * 2);
  }

  function testBurn() external {
    uint amount = 1 ether;
    cheats.prank(ALICE);
    token.burn(ALICE, amount);
    assertEq(token.balanceOf(ALICE), initialBalance - amount);
  }
}

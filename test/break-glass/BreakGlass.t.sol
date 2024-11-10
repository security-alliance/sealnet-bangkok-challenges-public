// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract BreakGlassChallenge is Test {
    address player = makeAddr("player");
    address recovery = makeAddr("BreakGlassRecovery");

    // ERC20 tokens
    address constant USDC = 0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E;
    address constant USP = 0xdaCDe03d7Ab4D81fEDdc3a20fAA89aBAc9072CE2;

    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 1e18;
    
    uint256 initialUSPSupply;

    modifier checkSolvedByPlayer() {
        vm.startPrank(player, player);
        _;
        vm.stopPrank();
        _isSolved();
    }

    /**
     * SETS UP CHALLENGE - DO NOT TOUCH
     */
    function setUp() public {
        vm.createSelectFork(vm.envString("AVAX_FORKING_URL"), 26343613);
        initialUSPSupply = IERC20(USP).totalSupply();

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE, "Player does not have initial ETH balance");
        assertEq(IERC20(USDC).balanceOf(recovery), 0, "Recovery has USDC");
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_breakGlass() public checkSolvedByPlayer {
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
      uint256 finalUSPSupply = IERC20(USP).totalSupply();
      assertGt(finalUSPSupply, initialUSPSupply, "USP supply did not increase");
      assertGt(IERC20(USDC).balanceOf(recovery), 0, "Recovery does not have USDC");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract LicenseToStealChallenge is Test {
    address player = makeAddr("player");
    address recovery = makeAddr("LicenseToStealRecovery");

    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 1e18;
    
    address constant VICTIM_WETH = 0x31d3243CfB54B34Fc9C73e1CB1137124bD6B13E1;

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
        vm.createSelectFork(vm.envString("MAINNET_FORKING_URL"), 17007838);

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE, "Player does not have initial ETH balance");
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_licenseToSteal() public checkSolvedByPlayer {
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
      // Check that recovery balance has WETH
      assertGt(IERC20(WETH).balanceOf(recovery), 1600 ether, "Recovery does not have enough WETH");
      // Check victim balance
      assertEq(IERC20(WETH).balanceOf(VICTIM_WETH), 0, "Victim still has WETH");
    }
}
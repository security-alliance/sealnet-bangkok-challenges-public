// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract MagicBeansChallenge is Test {
    address player = makeAddr("player");
    address recovery = makeAddr("MagicBeanRecovery");

    address constant GOVERNANCE_FACET_ADDRESS = 0xf480eE81a54E21Be47aa02D0F9E29985Bc7667c4;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant CRV_BEAN = 0x3a70DfA7d2262988064A2D051dd47521E43c9BdD;
    address constant BEANSTALK = 0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 1e18;
    

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
        vm.createSelectFork(vm.envString("MAINNET_FORKING_URL"), 14595905);

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);

        string memory modifiedFacetDataString = vm.readFile("bytecode/beanstalk/governancefacet.txt");
        bytes memory modifiedFacetData = vm.parseBytes(modifiedFacetDataString);
        vm.etch(GOVERNANCE_FACET_ADDRESS, modifiedFacetData);
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE, "Player does not have initial ETH balance");
        
        uint256 initialBeanstalkCrvBeanBalance = IERC20(CRV_BEAN).balanceOf(BEANSTALK);
        assertEq(initialBeanstalkCrvBeanBalance, 73225726535800514629402943, "Beanstalk does not have initial CRV_BEAN balance");
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_magicBeans() public checkSolvedByPlayer {
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
      // Check that recovery balance has USDC
      assertGt(IERC20(USDC).balanceOf(recovery), 42000000 * (10 ** 6), "Recovery does not have enough USDC");
        uint256 finalBeanstalkCrvBeanBalance = IERC20(CRV_BEAN).balanceOf(BEANSTALK);
        assertEq(finalBeanstalkCrvBeanBalance, 0, "Beanstalk still has CRV_BEAN");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract NomadChallenge is Test {
    address player = makeAddr("player");
    address recovery = makeAddr("NomadRecovery");

   address constant ERC20_BRIDGE = 0x88A69B4E698A4B090DF6CF5Bd7B2D47325Ad30A3;

    address constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant FRAX = 0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0;
    address constant CQT = 0xD417144312DbF50465b1C641d016962017Ef6240;
    
    uint256 initialNomadBalanceWbtc;
    uint256 initialNomadBalanceWeth;
    uint256 initialNomadBalanceUsdc;
    uint256 initialNomadBalanceUsdt;
    uint256 initialNomadBalanceDai;
    uint256 initialNomadBalanceFrax;
    uint256 initialNomadBalanceCqt;

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
        vm.createSelectFork(vm.envString("MAINNET_FORKING_URL"), 15259101);

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);
        
        initialNomadBalanceWbtc = IERC20(WBTC).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceWeth = IERC20(WETH).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceUsdc = IERC20(USDC).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceUsdt = IERC20(USDT).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceDai = IERC20(DAI).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceFrax = IERC20(FRAX).balanceOf(address(ERC20_BRIDGE));
        initialNomadBalanceCqt = IERC20(CQT).balanceOf(address(ERC20_BRIDGE));

    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE, "Player does not have initial ETH balance");
        
        assertGt(initialNomadBalanceWbtc, 0, "Nomad does not have initial WBTC balance");
        assertGt(initialNomadBalanceWeth, 0, "Nomad does not have initial WETH balance");
        assertGt(initialNomadBalanceUsdc, 0, "Nomad does not have initial USDC balance");
        assertGt(initialNomadBalanceUsdt, 0, "Nomad does not have initial USDT balance");
        assertGt(initialNomadBalanceDai, 0, "Nomad does not have initial DAI balance");
        assertGt(initialNomadBalanceFrax, 0, "Nomad does not have initial FRAX balance");
        assertGt(initialNomadBalanceCqt, 0, "Nomad does not have initial CQT balance");
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_nomad() public checkSolvedByPlayer {
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
      assertEq(IERC20(WBTC).balanceOf(ERC20_BRIDGE), 0, "Nomad still has WBTC");
      assertEq(IERC20(WBTC).balanceOf(recovery), initialNomadBalanceWbtc, "Recovery does not have Nomad WBTC balance");
      
      assertEq(IERC20(WETH).balanceOf(ERC20_BRIDGE), 0, "Nomad still has WETH");
      assertEq(IERC20(WETH).balanceOf(recovery), initialNomadBalanceWeth, "Recovery does not have Nomad WETH balance");
      
      assertEq(IERC20(USDC).balanceOf(ERC20_BRIDGE), 0, "Nomad still has USDC");
      assertEq(IERC20(USDC).balanceOf(recovery), initialNomadBalanceUsdc, "Recovery does not have Nomad USDC balance");
      
      assertEq(IERC20(USDT).balanceOf(ERC20_BRIDGE), 0, "Nomad still has USDT");
      assertEq(IERC20(USDT).balanceOf(recovery), initialNomadBalanceUsdt, "Recovery does not have Nomad USDT balance");
      
      assertEq(IERC20(DAI).balanceOf(ERC20_BRIDGE), 0, "Nomad still has DAI");
      assertEq(IERC20(DAI).balanceOf(recovery), initialNomadBalanceDai, "Recovery does not have Nomad DAI balance");
      
      assertEq(IERC20(FRAX).balanceOf(ERC20_BRIDGE), 0, "Nomad still has FRAX");
      assertEq(IERC20(FRAX).balanceOf(recovery), initialNomadBalanceFrax, "Recovery does not have Nomad FRAX balance");
      
      assertEq(IERC20(CQT).balanceOf(ERC20_BRIDGE), 0, "Nomad still has CQT");
      assertEq(IERC20(CQT).balanceOf(recovery), initialNomadBalanceCqt, "Recovery does not have Nomad CQT balance");
    }
}
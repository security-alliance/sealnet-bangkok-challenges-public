// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {LinkTokenInterface} from "lib/libocr/contract2/interfaces/LinkTokenInterface.sol";
import {AccessControllerInterface} from "lib/libocr/contract2/interfaces/AccessControllerInterface.sol";
import {AggregatorV2V3Interface, IAccessControlledOCR2Aggregator} from "../../src/there-is-no-spoon/Interfaces.sol";


contract ThereIsNoSpoonChallenge is Test {
    address player = makeAddr("player");
    address recovery = makeAddr("MagicBeanRecovery");

    IAccessControlledOCR2Aggregator ocr;
    AggregatorV2V3Interface aggregator;
    address constant OCR_ADDRESS = 0x7d4E742018fb52E48b08BE73d041C18B21de6Fb5;
    address constant AGGREGATOR_PROXY =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    address constant COMET = 0xc3d688B66703497DAA19211EEdff47f25384cdc3;
    address constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant WBTC_ADDRESS = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address constant USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant WSTETH_ADDRESS = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address constant COMP_ADDRESS = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address constant LINK_ADDRESS = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
    address constant UNI_ADDRESS = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant CBBTC_ADDRESS = 0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf;

    address[] signers;
    address[] transmitters;
    uint8 constant f = 4; // Fault tolerance

    // Private keys
    uint256 constant PRIVATE_KEY_1 = 0x1;
    uint256 constant PRIVATE_KEY_2 = 0x2;
    uint256 constant PRIVATE_KEY_3 = 0x3;
    uint256 constant PRIVATE_KEY_4 = 0x4;
    uint256 constant PRIVATE_KEY_5 = 0x5;

    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 1e18;

    modifier checkSolvedByPlayer() {
        _;
        _isSolved();
    }

    /**
     * SETS UP CHALLENGE - DO NOT TOUCH
     */
    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_FORKING_URL"), 21141795);
        // vm.createSelectFork(vm.envString("MAINNET_FORKING_URL"));

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);

        // Get existing contract instance
        ocr = IAccessControlledOCR2Aggregator(OCR_ADDRESS);
        aggregator = AggregatorV2V3Interface(AGGREGATOR_PROXY);

        // Setup oracle addresses
        signers = new address[](13);
        transmitters = new address[](13);

        // Set up first 5 signers with known private keys
        for (uint i = 0; i < 5; i++) {
            signers[i] = vm.addr(i + 1);
            transmitters[i] = vm.addr(i + 100);
        }

        // Fill remaining addresses
        for (uint i = 5; i < 13; i++) {
            signers[i] = vm.addr(i + 1);
            transmitters[i] = vm.addr(i + 100);
        }

        // Get contract owner
        address owner = ocr.owner();
        console.log("Contract owner:", owner);

        // Prank as owner to set new config
        vm.startPrank(owner);

        // Configure OCR2 with our test addresses
        bytes memory onchainConfig = abi.encodePacked(
            uint8(1),
            ocr.minAnswer(), // Use existing min answer
            ocr.maxAnswer() // Use existing max answer
        );

        ocr.setConfig(
            signers,
            transmitters,
            f,
            onchainConfig,
            1, // offchainConfigVersion
            "" // offchainConfig
        );

        // Set payees to be same as transmitters
        ocr.setPayees(transmitters, transmitters);

        // Set billing params to 0 for testing
        ocr.setBilling(0, 0, 0, 0, 0);

        vm.stopPrank();
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(
            player.balance,
            PLAYER_INITIAL_ETH_BALANCE,
            "Player does not have initial ETH balance"
        );
    }

    function transmitPrice(int192 price) internal {
        // Create price observations - using same price for simplicity
        int192[] memory observations = new int192[](9);
        for (uint i = 0; i < 9; i++) {
            observations[i] = price;
        }

        // Get current config details
        (uint32 configCount, uint32 blockNumber, bytes32 configDigest) = ocr
            .latestConfigDetails();
        console.log("Config digest:", vm.toString(configDigest));

        // Set up report context
        bytes32[3] memory reportContext;
        reportContext[0] = configDigest;
        reportContext[1] = bytes32((uint256(1) << 8) | uint256(1)); // epoch 1, round 1
        reportContext[2] = bytes32(0);

        // Create observer bytes32 (first 9 oracles)
        bytes32 observers = bytes32(
            uint256(
                0x0001020304050607080000000000000000000000000000000000000000000000
            )
        );

        // Encode the report
        bytes memory report = abi.encode(
            uint32(block.timestamp),
            observers,
            observations,
            int192(1e18) // juelsPerFeeCoin
        );

        // Hash the message that needs to be signed
        bytes32 message = keccak256(
            abi.encode(keccak256(report), reportContext)
        );

        // Create signature arrays
        bytes32[] memory rs = new bytes32[](f + 1);
        bytes32[] memory ss = new bytes32[](f + 1);
        bytes32 rawVs;

        console.log("Message to sign:", vm.toString(message));

        // Generate f+1 valid signatures
        for (uint i = 0; i < f + 1; i++) {
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(i + 1, message);
            rs[i] = r;
            ss[i] = s;
            // Pack v values into rawVs, adjusting v to be 0 or 1
            v = v - 27; // Convert to 0/1 format
            rawVs |= bytes32(uint256(v) << (8 * (31 - i)));
        }
        // Submit as authorized transmitter
        vm.startPrank(transmitters[0]);

        ocr.transmit(reportContext, report, rs, ss, rawVs);
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_thereIsNoSpoon() public checkSolvedByPlayer {


    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
        // Check latest answer
        // Verify new round data
        (, int256 newAnswer, , , ) = aggregator.latestRoundData();
        console.log("New price:", uint256(newAnswer));

        // Assertions
        assertEq(newAnswer, 10000e8);
        
        // TODO check for recovered funds
    }
}

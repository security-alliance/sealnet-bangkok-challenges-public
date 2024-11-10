pragma solidity ^0.8.13;

interface AggregatorInterface {
  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);

  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
  event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
}

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface
{
}

interface IAccessControlledOCR2Aggregator {
    function setConfig(
        address[] calldata signers,
        address[] calldata transmitters,
        uint8 f,
        bytes calldata onchainConfig,
        uint64 offchainConfigVersion,
        bytes calldata offchainConfig
    ) external;

    function owner() external view returns (address);
    function setBilling(
        uint32 maximumGasPriceGwei,
        uint32 reasonableGasPriceGwei,
        uint32 observationPaymentGjuels,
        uint32 transmissionPaymentGjuels,
        uint24 accountingGas
    ) external;
    function setPayees(
        address[] calldata transmitters,
        address[] calldata payees
    ) external;
    function transmit(
        // reportContext consists of:
        // reportContext[0]: ConfigDigest
        // reportContext[1]: 27 byte padding, 4-byte epoch and 1-byte round
        // reportContext[2]: ExtraHash
        bytes32[3] calldata reportContext,
        bytes calldata report,
        // ECDSA signatures
        bytes32[] calldata rs,
        bytes32[] calldata ss,
        bytes32 rawVs
    ) external;

    function minAnswer() external view returns (int192);
    function maxAnswer() external view returns (int192);
    function latestConfigDetails()
        external
        view
        returns (uint32 configCount, uint32 blockNumber, bytes32 configDigest);
  function latestTransmissionDetails()
    external
    view
    returns (
      bytes16 configDigest,
      uint32 epoch,
      uint8 round,
      int192 latestAnswer,
      uint64 latestTimestamp
    );
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
 
interface IReplica {
   function process(bytes memory _message) external returns (bool _success);
}
 
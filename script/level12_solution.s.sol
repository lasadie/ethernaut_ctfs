// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Privacy } from "../src/level12.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice read private variable values from memory and casting
contract Level12Solution is Script {
    Privacy level = Privacy(0x217259F1Ee83063F32624DCbd87f8EAd2E78c315);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        /*
        slot 0 = locked
        slot 1 = ID
        slot 2 = flattening, denomination, awkwardness
        slot 3 = data[0]
        slot 4 = data[1]
        slot 5 = data[2]
        
        Step 1: Read from contract's storage to retrieve value from slot 5
            cast storage <contract address> 5
        Step 2: Returned value will be in 32bytes, casting to bytes16 means first 32 characters is retained
        Step 3: Use the retained bytes16 value and call unlock() function.
        */
        level.unlock(bytes16(0x53d52270eadbe637dba2ff24fe2484b6));
        console.log("locked: ", level.locked());

        vm.stopBroadcast();
    }
}



/*
variable storage sides
    bool = 1 byte
    address = 20 bytes
    uint8 = 1 bytes
    uint16 = 2 bytes
    uint256 = 32 bytes
    string = dynamic
*/ 
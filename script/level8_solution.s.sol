// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Vault} from "../src/level8.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice reading private variables
contract Level8Solution is Script {
    Vault public level = Vault(0xE355Fc416Be90eED3980Ddaa28D8b212A1D45522);

    // Step 1: Use CLI cast storage [contract address] [slot number]
    // In this case, the slot number should be 1, as bool takes 1 byte and be filled in slot 0,
    // bytes32 takes a full slot, so it will take slot 1.

    // Alternative method is to look at blockchain explorer -> contract address -> internal transactions
    // -> "create level instance" transaction -> State
    // This will show the state variables and their assigned slot ahd hex values.

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Locked: ", level.locked());
        level.unlock(0x412076657279207374726f6e67207365637265742070617373776f7264203a29);
        console.log("Locked: ", level.locked());

        vm.stopBroadcast();
    }
}



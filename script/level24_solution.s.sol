// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { PuzzleProxy } from "../src/level24.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin-contracts/contracts/utils/Strings.sol";

///@notice Manipulating own Token to drain Token1+Token2
contract Level24Solution is Script {
    PuzzleProxy level = PuzzleProxy(0x37E8B500D0fddBaCb7fB68D27499425b09557CBD);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        

        vm.stopBroadcast();
    }
}

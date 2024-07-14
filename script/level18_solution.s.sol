// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { MagicNum } from "../src/level18.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice Writing EVM bytecodes assembly level
contract Level18Solution is Script {
    MagicNum level = MagicNum(0x9030F92130a1BCE4C30ac66069c34139066dDa23);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        level.setSolver(solver);
        console.log("solver: ", level.solver());

        vm.stopBroadcast();
    }
}
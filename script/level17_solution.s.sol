// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SimpleToken } from "../src/level17.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Level17Solution is Script {
    SimpleToken level = SimpleToken(payable(0x16bfBA7B813AD70c5f598F9Accb7671Aa19D0B9f));
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        /*
        EASY WAY
        ========
        Step 1: Go to Etherscan and find the instance level
        Step 2: Click Internal Txns and find the 'Contract Creation' address
        Step 3: Call the contract address's destroy() function and provide your address
        */

        address addr = address(0x66f82077Bb500b7e7Aa6dAB828399EDEd5495fC4);
        addr.call(abi.encodeWithSignature("destroy(address)", vm.envAddress("MY_ADDRESS")));
        console.log("balance: ", addr.balance);

        vm.stopBroadcast();
    }
}

/*
DIFFICULT WAY
==============
Contract address are deterministic and calculated by keccak256(address, nonce) where the address is the address 
of the contract (or ethereum address that created the transaction) and nonce is the number of contracts the 
spawning contract has created (or the transaction nonce, for regular transactions).


Formula: 
The address of the new account is defined as being the rightmost 160 bits of the Keccak hash of the RLP 
encoding of the structure containing only the sender and the account nonce.
RLP for 20 byte address will be 0xd6, 0x94.

address lostcontract = address(uint160(uint256(keccak256(abi.encodePacked(0xd6, 0x94, address(<creator_address>), 0x01)))));

*/
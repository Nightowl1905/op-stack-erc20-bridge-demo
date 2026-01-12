// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    uint256 public constant initialSupply = 1_000_000 * 10 ** 18; // 1 million tokens with 18 decimals

    function run() external returns (MyToken) {
        vm.startBroadcast();
        MyToken myToken = new MyToken(initialSupply);
        vm.stopBroadcast();
        return myToken;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "../lib/forge-std/src/Script.sol";

interface IOptimismMintableERC20Factory {
    function createOptimismMintableERC20(
        address _remoteToken,
        string memory _name,
        string memory _symbol
    ) external returns (address);
}

contract DeployMyTokenL2 is Script {
    function run() external {
        address l1TokenAddress = vm.envAddress("L1_ERC20_ADDRESS");

        // OP Stack's standard factory address
        address factory = 0x4200000000000000000000000000000000000012;
        // Deploy L2 token via factory
        vm.startBroadcast();
        address l2Token = IOptimismMintableERC20Factory(factory)
            .createOptimismMintableERC20(
                l1TokenAddress,
                "OZEAN L2 Token",
                "OZT"
            );
        vm.stopBroadcast();

        // Output the L2 token address
        console.log("L2 Token deployed at:", l2Token);
    }
}

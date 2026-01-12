// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "../lib/forge-std/src/Script.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IL2StandardBridge {
    function withdraw(
        address _l2Token, // The L2 token address
        uint256 _amount, // Amount to withdraw
        uint32 _minGasLimit, // Min gas for L1 execution
        bytes calldata _extraData
    ) external;
}

contract BridgeL2toL1 is Script {
    function run() external {
        // Load from .env
        address l2Token = vm.envAddress("L2_ERC20_ADDRESS");

        // Sepolia withdraw address
        address l2Bridge = 0x4200000000000000000000000000000000000010;

        // Amount to withdraw  (10 tokens with 18 decimals)
        uint256 amount = 10 * 1e18;
        // Recommended gas limit for L2 finalization
        uint32 minGasLimit = 200_000;

        vm.startBroadcast();
        // Step 1: Approve L2 bridge to spend L2 tokens
        console.log("Approving L2 bridge for", amount);
        IERC20(l2Token).approve(l2Bridge, amount);

        // Step 2: Initiate withdrawal from L2 to L1
        console.log("Bridging from L2 to L1...");
        IL2StandardBridge(l2Bridge).withdraw(l2Token, amount, minGasLimit, "");
        vm.stopBroadcast();

        console.log("Withdrawal initiated!");
        console.log("Amount:", amount);
    }
}

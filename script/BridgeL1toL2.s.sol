// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "../lib/forge-std/src/Script.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IL1StandardBridge {
    function bridgeERC20To(
        address _localToken,
        address _remoteToken,
        address _to,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;
}

contract BridgeL1toL2 is Script {
    function run() external {
        // Load from .env
        address l1Token = vm.envAddress("L1_ERC20_ADDRESS");
        address l2Token = vm.envAddress("L2_ERC20_ADDRESS");

        // Sepolia bridge address
        address l1Bridge = 0xFBb0621E0B23b5478B630BD55a5f21f67730B0F1;
        // Amount to bridge (100 tokens with 18 decimals)
        uint256 amount = 100 * 1e18;
        // Recommended gas limit for L2 finalization
        uint32 minGasLimit = 200_000;
        // Users wallet address
        address myAddress = 0x1A2115173c31Fa8E6a598a8a40671Df4c2C99680;

        vm.startBroadcast();
        // Step 1: Approve bridge
        console.log("Approving bridge for", amount);
        IERC20(l1Token).approve(l1Bridge, amount);

        // Step 2: Bridge tokens
        console.log("Bridging from L1 to L2...");
        IL1StandardBridge(l1Bridge).bridgeERC20To(
            l1Token,
            l2Token,
            myAddress, // _to (your address)
            amount,
            minGasLimit, // _minGasLimit
            ""
        );
        vm.stopBroadcast();

        console.log("Bridge transaction sent!");
        console.log("Amount:", amount);
    }
}

# OP Standard Bridge Demo

## Overview
ERC20 token deployment + L1↔L2 bridging via Optimism Standard Bridge.
Demonstrates complete bridging lifecycle using Foundry scripts.

## Prerequisites

| Requirement | Version Used |
|-------------|--------------|
| OS | Ubuntu 24.04.1 LTS |
| Foundry | forge Version: 1.5.0-stable |
| Solidity | ^0.8.24 |


## Setup
1. Clone repo: `git clone <repo-url>`
2. Install dependencies: `forge install`
3. Copy `.env.example` → `.env`
4. Add your private key to Foundry keystore:
   ```bash
   cast wallet import YourTestAccountKey --interactive
   ```
5. Build: `forge build`

---

## Project Structure
```
├── src/
│   ├── MyToken.sol          # L1 ERC20 token
├── script/
│   ├── Deploy_MyToken.s.sol      # L1 deployment
│   ├── Deploy_MyTokenL2.s.sol    # L2 deployment via OP factory
│   ├── BridgeL1toL2.s.sol        # Bridge tokens L1 → L2
│   └── BridgeL2toL1.s.sol        # Withdraw tokens L2 → L1
└── Makefile                      # All commands
```
---

## Development Stages

### Stage 1: ERC-20 on L1 (Sepolia)
**Scripts:** `Deploy_MyToken.s.sol`  
**Contracts:** `src/MyToken.sol`  
**Description:** Standard ERC20 using OpenZeppelin. Deployed on Ethereum Sepolia testnet.
```
make deploy-sepolia
```

### Stage 2: L2 Token via OP Factory
**Scripts:** `Deploy_MyTokenL2.s.sol`  
**Contracts:** `src/MyTokenL2.sol`  
**Description:** Created OptimismMintableERC20 by calling `IOptimismMintableERC20Factory` on OP Sepolia. This links L2 token to L1 counterpart for bridging.
```
make deploy-sepolia-op
```

### Stage 3: Bridge L1 → L2
**Scripts:** `BridgeL1toL2.s.sol`  
**Description:** Used `IL1StandardBridge.bridgeERC20To()` to deposit tokens from Sepolia into OP Sepolia via Optimism's canonical bridge.
```
make bridge-l1-to-l2
```

### Stage 4: Withdraw L2 → L1
**Scripts:** `BridgeL2toL1.s.sol`  
**Description:** Initiated withdrawal using `IL2StandardBridge.withdraw()`. Note: Full finalization requires 7-day challenge period on mainnet.
```
make bridge-l2-to-l1
```

---

## Deployed Contracts

| Chain | Contract | Address |
|-------|----------|---------|
| L1 (Sepolia) | MyToken | `0xf96b35b3366d5459cDf7462bcd754D8CC5faa454` |
| L2 (OP Sepolia) | MyToken | `0xE6Df762aBb5990d11872409db6A80904cA1e35D8` |

### Transaction Evidence

**Developer Links:**
- [My Sepolia address](https://sepolia.etherscan.io/address/0x1a2115173c31fa8e6a598a8a40671df4c2c99680)
- [My OP Sepolia address](https://testnet-explorer.optimism.io/address/0x1A2115173c31Fa8E6a598a8a40671Df4c2C99680)
  
**Sepolia Etherscan:**
- [Deploy TX](https://sepolia.etherscan.io/tx/0x70da9cebff950baf480712df091197000d5caa423decb4785ff012108a3fc505)
- [Bridge TX](https://sepolia.etherscan.io/tx/0xb7e4b34503dcf415ec583302a2f9da74c9017dcbd8e0f2652db7891158fb9627)

**OP Sepolia Etherscan:**
- [Bridging Received](https://testnet-explorer.optimism.io/tx/0xef7daabdc9e0cb41fd5e7ad6885431bf85effe26e6d81f99882b2c90cb703ac5)
- [Withdraw to L1](https://testnet-explorer.optimism.io/tx/0x31bbbaebde48b495f51f1367f6059133df1e2fc764e7b813276bb4ae0dcccb9a)
- Status: In 7-day challenge period (~6 days remaining as of Dec 30, 2025)
- [Withdraw Success (Jan-06-2026 05:18:12 AM UTC)](https://sepolia.etherscan.io/tx/0xd915bfc463bc7d88e1bee88e2ab9d0a72fb3b0294a6d1ac79c730a3b09d0840a)

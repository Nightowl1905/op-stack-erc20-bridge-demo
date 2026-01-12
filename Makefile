-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil install deploy deploy-sepolia verify

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install openzeppelin/openzeppelin-contracts@v5.4.0

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:
	@forge script script/deploy_myToken.s.sol:DeployMyToken --rpc-url $(LOCAL_RPC) --private-key $(LOCAL_ANVIL_KEY) --broadcast

deploy-sepolia:
	@forge script script/Deploy_MyToken.s.sol:DeployMyToken --rpc-url $(SEPOLIA_RPC) --account YourTestAccountKey --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)

deploy-sepolia-op:
	@forge script script/Deploy_MyTokenL2.s.sol:DeployMyTokenL2 --rpc-url $(OPTIMISM_SEPOLIA_RPC) --account YourTestAccountKey --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

bridge-l1-to-l2:
	@forge script script/BridgeL1toL2.s.sol:BridgeL1toL2 --rpc-url $(SEPOLIA_RPC) --account YourTestAccountKey --broadcast -vvv

bridge-l2-to-l1:
	@forge script script/BridgeL2toL1.s.sol:BridgeL2toL1 --rpc-url $(OPTIMISM_SEPOLIA_RPC) --account YourTestAccountKey --broadcast -vvv

cast-total-supply:
	@cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "totalSupply()" --rpc-url $(LOCAL_RPC) | \
	xargs cast to-dec | \
	awk '{printf "Total Supply: %s tokens (%.2f with 18 decimals)\n", $$1, $$1/1e18}'

cast-send:
	@cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "transfer(address,uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 1000000000000000000000 --private-key $(LOCAL_ANVIL_KEY) --rpc-url $(LOCAL_RPC)

cast-balance-main:
	@cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "balanceOf(address)"  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url $(LOCAL_RPC) | \
	xargs cast to-dec | \
	awk '{printf "Balance: %s tokens (%.2f with 18 decimals)\n", $$1, $$1/1e18}'
	
cast-balance-2nd:
	@cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "balanceOf(address)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --rpc-url $(LOCAL_RPC) | \
	xargs cast to-dec | \
	awk '{printf "Balance: %s tokens (%.2f with 18 decimals)\n", $$1, $$1/1e18}'
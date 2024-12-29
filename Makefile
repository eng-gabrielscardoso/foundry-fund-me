include .env

INSTALL_SCRIPT = .githooks/install

.PHONY: install

default: install

run-anvil-tests:
	@forge test -vvvvv

run-sepolia-tests:
	@forge test --fork-url ${SEPOLIA_RPC_URL} -vvvvv

run-mainnet-tests:
	@forge test --fork-url ${MAINNET_RPC_URL} -vvvvv

install-hooks:
	@bash $(INSTALL_SCRIPT)

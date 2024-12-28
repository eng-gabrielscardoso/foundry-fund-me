include .env

INSTALL_SCRIPT = .githooks/install

.PHONY: install

default: install

run-test:
	@forge test --fork-url ${SEPOLIA_RPC_URL} -vvvvv

install-hooks:
	@bash $(INSTALL_SCRIPT)

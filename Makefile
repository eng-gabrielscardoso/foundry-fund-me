INSTALL_SCRIPT = .githooks/install

.PHONY: install

default: install

install-hooks:
	@bash $(INSTALL_SCRIPT)

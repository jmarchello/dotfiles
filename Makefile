.PHONY: all check-python install-ansible ansible-run

all: ansible-run

check-python:
	@command -v python3 >/dev/null 2>&1 || { echo "Error: Python 3 is required but not installed."; exit 1; }
	@echo "Python 3 found: $$(python3 --version)"

install-ansible: check-python
	@command -v ansible >/dev/null 2>&1 || { \
		echo "Installing Ansible via pip..."; \
		pip3 install --user ansible; \
		echo "Note: Ensure ~/.local/bin is in your PATH"; \
	}
	@echo "Ansible found: $$(ansible --version | head -n1)"

ansible-run: install-ansible
	cd ansible && ansible-playbook site.yml

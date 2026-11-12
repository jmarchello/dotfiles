.PHONY: all check-python install-ansible ansible-run herdr-sync

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
	cd ansible && ansible-playbook site.yml --ask-become-pass

HERDR_LIVE := $(HOME)/.config/herdr-app
HERDR_SESSIONS := $(HOME)/.local/share/herdr-sessions

herdr-sync:
	@cd config/herdr-app && for f in keys.json settings.json layouts/* themes/*; do cp "$(HERDR_LIVE)/$$f" "$$f"; done
	@for m in config/herdr-app/mods/*/; do rsync -a --delete --exclude jsconfig.json --exclude gpui-kit.d.ts --exclude __pycache__ "$(HERDR_LIVE)/mods/$$(basename $$m)/" "$$m"; done
	@cp $(HERDR_SESSIONS)/session_prs.py $(HERDR_SESSIONS)/resume.py config/herdr-sessions/
	@cp $(HOME)/.claude/hooks/herdr-app-session.sh config/herdr-sessions/claude-hook.sh
	@git status --short config/herdr-app config/herdr-sessions

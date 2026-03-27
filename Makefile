.PHONY: help install install-man check-deps uninstall

PREFIX ?= $(HOME)/.local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

help:
	@echo "fzfm - Fuzzy File Manager"
	@echo ""
	@echo "Targets:"
	@echo "  install       Install fzfm to $(PREFIX)"
	@echo "  install-man   Install man page only"
	@echo "  check-deps    Check for required dependencies"
	@echo "  uninstall     Remove installed files"

check-deps:
	@echo "Checking dependencies..."
	@command -v fzf >/dev/null 2>&1 && echo "[OK] fzf" || echo "[MISSING] fzf - run: sudo xbps-install fzf"
	@command -v lsd >/dev/null 2>&1 && echo "[OK] lsd" || echo "[MISSING] lsd - run: sudo xbps-install lsd"
	@command -v bat >/dev/null 2>&1 && echo "[OK] bat" || echo "[OPT] bat - run: sudo xbps-install bat"
	@command -v chafa >/dev/null 2>&1 && echo "[OK] chafa" || echo "[OPT] chafa - run: sudo xbps-install chafa (for image previews)"
	@command -v viu >/dev/null 2>&1 && echo "[OK] viu" || echo "[OPT] viu - run: sudo xbps-install viu (for image previews)"
	@command -v trash-put >/dev/null 2>&1 && echo "[OK] trash-put" || echo "[OPT] trash-put - run: sudo xbps-install trash-cli"
	@command -v ffmpeg >/dev/null 2>&1 && echo "[OK] ffmpeg" || echo "[OPT] ffmpeg - run: sudo xbps-install ffmpeg (for video thumbnails)"

install: check-deps
	@echo "Installing fzfm to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@install -Dm755 fzfm.sh $(BINDIR)/fzfm
	@echo "Installing man page to $(MANDIR)..."
	@mkdir -p $(MANDIR)
	@install -Dm644 fzfm.1 $(MANDIR)/fzfm.1
	@echo ""
	@echo "Installation complete!"
	@echo "Add to your shell profile:"
	@echo "  echo 'source $(BINDIR)/fzfm' >> ~/.bashrc"
	@echo ""
	@echo "Or run directly:"
	@echo "  $(BINDIR)/fzfm"

install-man:
	@echo "Installing man page to $(MANDIR)..."
	@mkdir -p $(MANDIR)
	@install -Dm644 fzfm.1 $(MANDIR)/fzfm.1

uninstall:
	@echo "Removing fzfm..."
	@rm -f $(BINDIR)/fzfm
	@rm -f $(MANDIR)/fzfm.1
	@echo "Done."

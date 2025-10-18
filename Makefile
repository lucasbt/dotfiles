REPO_URL = https://github.com/lucasbt/dotfiles.git
INSTALL_DIR = $(HOME)/.dotfiles
.SILENT:
.PHONY: install clean

install:
	@echo "🔧 Applying dotfiles with stow..."
	cd $(INSTALL_DIR) && stow dots
	@echo "✅ Dotfiles applied successfully!"

clean:
	@echo "🧹 Removing symlinks with stow..."
	cd $(INSTALL_DIR) && stow -D dots
	@echo "✅ Symlinks removed!"

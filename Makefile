REPO_URL = https://github.com/lucasbt/dotfiles.git
INSTALL_DIR = $(HOME)/.dotfiles

.PHONY: install clean

install:
	@echo "🔧 Aplicando dotfiles com stow..."
	cd $(INSTALL_DIR) && stow dots
	@echo "✅ Dotfiles aplicados com sucesso!"

clean:
	@echo "🧹 Removendo symlinks com stow..."
	cd $(INSTALL_DIR) && stow -D dots
	@echo "✅ Symlinks removidos!"

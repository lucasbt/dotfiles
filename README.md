# 🛠️ dotfiles

Arquivos de configuração pessoais utilizados para configurar rapidamente meu ambiente de desenvolvimento em novas máquinas.

Este repositório usa o utilitário [`stow`](https://www.gnu.org/software/stow/) para aplicar os arquivos via symlinks no diretório `$HOME`.

## 📦 Conteúdo

Este repositório contém alguns dos seguintes arquivos de configuração:

- `.aliases` – Aliases personalizados
- `.functions` – Funções auxiliares para o shell
- `.gitconfig`, `.gitignore`, `.gitattributes` – Configurações do Git
- `.git-completion.bash` – Autocompletar comandos Git no Bash
- `.inputrc` – Configurações de comportamento da linha de comando
- `.nanorc` – Customizações para o editor Nano
- `.wgetrc` – Configurações do `wget`
- `.zshrc`, `.zshenv` – Configurações do Zsh

## 🚀 Instalação rápida

### 1. Pré-requisitos

- `git`
- [`stow`](https://www.gnu.org/software/stow/)
Instale com:
```bash
# Fedora
sudo dnf install stow
# Debian/Ubuntu
sudo apt install stow
# macOS (via Homebrew)
brew install stow
```

### 2. Instalação automática

Execute o comando abaixo no terminal:

```bash
curl -sL https://raw.githubusercontent.com/lucasbt/dotfiles/main/install.sh | sh
```

Esse comando irá:
- Clonar este repositório no diretório `~/.dotfiles`
- Usar `stow` para aplicar os arquivos no seu `$HOME`

## ⚙️ Makefile

Este repositório contém um `Makefile` com os seguintes alvos:
- `make install` — Aplica os dotfiles no diretório home com `stow`
- `make clean` — Remove os symlinks aplicados por `stow`

## 🧼 Remoção

Para desfazer os symlinks:

```bash
make clean
```

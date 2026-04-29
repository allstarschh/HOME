#!/usr/bin/env bash
# Ubuntu 24.04 fresh install script

set -euo pipefail

STEP() { echo; echo "==> $*"; }

# ── apt packages ──────────────────────────────────────────────────────────────

STEP "Update apt"
sudo apt-get update

STEP "Firefox Nightly (ubuntu-mozilla-daily PPA)"
sudo add-apt-repository -y ppa:ubuntu-mozilla-daily/ppa
sudo apt-get update
sudo apt-get install -y firefox-trunk

STEP "Dev tools"
sudo apt-get install -y \
  terminator \
  git mercurial vim vim-scripts vim-gtk3 gitk \
  clang ccache curl \
  php php-curl \
  valgrind \
  cargo \
  python3-pip \
  git-revise \
  fd-find ripgrep mold \
  libxcb-xtest0

#STEP "Java"
#sudo apt-get install -y openjdk-11-jdk

STEP "fcitx5"
sudo apt-get install -y fcitx5
echo "NOTE: run 'im-config' to switch input method to fcitx5"
echo "NOTE: download fcitx5-table-extra from pkgs.org and copy usr/share files manually"

STEP "rr build dependencies"
sudo apt-get install -y \
  ccache cmake make g++-multilib gdb \
  pkg-config coreutils python3-pexpect manpages-dev git \
  ninja-build capnproto libcapnp-dev

# ── Cargo tools ───────────────────────────────────────────────────────────────

STEP "Cargo tools"
curl https://sh.rustup.rs -sSf | sh
cargo install du-dust gitui exa ytop bottom procs git-interactive-rebase-tool git-delta cargo-binstall

# ── Git repos ─────────────────────────────────────────────────────────────────

#STEP "git-cinnabar"
#mkdir -p ~/src
#if [[ ! -d ~/src/git-cinnabar ]]; then
  #git clone git@github.com:glandium/git-cinnabar.git ~/src/git-cinnabar
#fi
# Ensure git-cinnabar is on PATH (add to ~/.bashrc if not already there)
#if ! grep -q 'git-cinnabar' ~/.bashrc; then
  #echo 'export PATH="$HOME/src/git-cinnabar:$PATH"' >> ~/.bashrc
#fi
#export PATH="$HOME/src/git-cinnabar:$PATH"
#git cinnabar download

STEP "phlay"
if [[ ! -d ~/src/phlay ]]; then
  git clone git@github.com:mystor/phlay.git ~/src/phlay
fi
mkdir -p ~/bin
ln -sf ~/src/phlay/phlay ~/bin/phlay

# ── Gecko ─────────────────────────────────────────────────────────────────────

GECKO_SRC_URL="${GECKO_SRC_URL:-https://github.com/mozilla-firefox/firefox.git}"
# Alternative: GECKO_SRC_URL=hg::https://hg.mozilla.org/mozilla-unified

STEP "gecko-dev clone (this will take a while)"
if [[ ! -d ~/src/gecko ]]; then
  git -C ~/src clone "$GECKO_SRC_URL" gecko
  git -C ~/src/gecko config fetch.prune true
else
  echo "gecko already cloned, skipping"
fi

STEP "gecko bootstrap"
~/src/gecko/mach bootstrap

# ── atuin ─────────────────────────────────────────────────────────────────────

STEP "atuin"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# ── Keyboard: caps:escape ─────────────────────────────────────────────────────

setup_keyboard() {
  STEP "Keyboard: remap Caps Lock to Escape"
  case "${XDG_CURRENT_DESKTOP:-}" in
    *KDE*)
      KWRITECONFIG=$(command -v kwriteconfig6 || command -v kwriteconfig5 || true)
      if [[ -n "$KWRITECONFIG" ]]; then
        "$KWRITECONFIG" --file kxkbrc --group Layout --key Options caps:escape
        "$KWRITECONFIG" --file kxkbrc --group Layout --key ResetOldOptions true
      else
        echo "WARNING: kwriteconfig not found, skipping"
      fi
      ;;
    *GNOME*)
      gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
      ;;
    *)
      echo "WARNING: unknown desktop '$XDG_CURRENT_DESKTOP', skipping caps:escape config"
      ;;
  esac
}

setup_config() {
  STEP "Copy configuration files"

  local files=(.gitconfig .vimrc .bash_aliases)

  # Copy config files to $HOME
  for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
      cp "$file" "$HOME/$file"
      echo "✓ Copied $file to $HOME/"
    else
      echo "⚠ $file not found, skipping"
    fi
  done

  # Append bashrc content
  if [[ -f bashrc ]]; then
    cat bashrc >> "$HOME/.bashrc"
    echo "✓ Appended bashrc to $HOME/.bashrc"
  else
    echo "⚠ bashrc not found, skipping"
  fi

  # Copy .config files
  if [[ -d .config ]]; then
    mkdir -p "$HOME/.config"
    cp -r .config/* "$HOME/.config/"
    echo "✓ Copied .config files to $HOME/.config/"
  else
    echo "⚠ .config directory not found, skipping"
  fi
}

# Command handlers
# kb:  Configure keyboard (remap Caps Lock to Escape)
# cfg: Copy configuration files (.gitconfig, .vimrc, .bash_aliases, bashrc, .config) to $HOME
case "${1:-}" in
  kb)
    setup_keyboard
    exit 0
    ;;
  cfg)
    setup_config
    exit 0
    ;;
esac

echo
echo "==> Done. Restart your shell (or source ~/.bashrc) to pick up PATH changes."

#!/usr/bin/env bash
set -e

BIN_NAME=kdotool
BUILD_DIR=target/release
INSTALL_PATH=/usr/local/bin/$BIN_NAME

detect_distro() {
  if command -v apt >/dev/null; then
    echo debian
  elif command -v dnf >/dev/null; then
    echo rhel
  else
    echo unsupported
  fi
}

install_deps() {
  case "$(detect_distro)" in
    debian)
      sudo apt update
      sudo apt install -y cargo rustc pkg-config libdbus-1-dev
      ;;
    rhel)
      sudo dnf install -y cargo rust pkg-config dbus-devel
      ;;
    *)
      echo "Unsupported distro"
      exit 1
      ;;
  esac
}

case "$1" in
  install)
    install_deps
    cargo build --release
    sudo install -m 755 "$BUILD_DIR/$BIN_NAME" "$INSTALL_PATH"
    ;;

  uninstall)
    sudo rm -f "$INSTALL_PATH"
    ;;

  *)
    echo "Usage: $0 {install|uninstall}"
    exit 1
    ;;
esac

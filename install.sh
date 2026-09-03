#!/usr/bin/env bash
# Install grok-models + PATH wrapper on this machine. Does not write API keys
# or ~/.grok/config.toml.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
CFG_DIR="${HOME}/.config/grok-models"
GROK_DIR="${HOME}/.grok"

BASHRC_MARKER="grok-models BYOK keys"
PROFILE_SNIPPET='
# grok-models BYOK keys (do not print; used by Grok Build env_key)
if [ -f "$HOME/.config/grok-models/keys.env" ]; then
  set -a
  . "$HOME/.config/grok-models/keys.env"
  set +a
fi
'

if [[ ! -f "${ROOT}/bin/grok-models" || ! -f "${ROOT}/bin/grok" ]]; then
  echo "Run this from a clone of grok-build-byok (missing bin/)." >&2
  exit 1
fi

mkdir -p "$BIN_DIR" "$CFG_DIR" "$GROK_DIR"
chmod 700 "$CFG_DIR"

install -m 755 "${ROOT}/bin/grok-models" "${BIN_DIR}/grok-models"
install -m 755 "${ROOT}/bin/grok" "${BIN_DIR}/grok"

if [[ ! -f "${CFG_DIR}/allowlist.json" ]]; then
  install -m 644 "${ROOT}/config/allowlist.json" "${CFG_DIR}/allowlist.json"
  echo "Installed ${CFG_DIR}/allowlist.json"
else
  echo "Left existing ${CFG_DIR}/allowlist.json in place"
fi

if [[ ! -f "${GROK_DIR}/AGENTS.md" ]]; then
  install -m 644 "${ROOT}/AGENTS.md" "${GROK_DIR}/AGENTS.md"
  echo "Installed ${GROK_DIR}/AGENTS.md"
else
  echo "Left existing ${GROK_DIR}/AGENTS.md in place (repo copy is ${ROOT}/AGENTS.md)"
fi

if [[ -f "${HOME}/.bashrc" ]] && ! grep -q "$BASHRC_MARKER" "${HOME}/.bashrc"; then
  printf '%s\n' "$PROFILE_SNIPPET" >> "${HOME}/.bashrc"
  echo "Appended key loader to ~/.bashrc"
fi

if [[ -f "${HOME}/.profile" ]] && ! grep -q "$BASHRC_MARKER" "${HOME}/.profile"; then
  printf '%s\n' "$PROFILE_SNIPPET" >> "${HOME}/.profile"
  echo "Appended key loader to ~/.profile"
fi

case ":${PATH}:" in
  *":${BIN_DIR}:"*) ;;
  *) echo "Note: add ${BIN_DIR} to PATH (e.g. export PATH=\"${BIN_DIR}:\$PATH\")" ;;
esac

echo
echo "Next:"
echo "  grok-models key openrouter    # also: neuralwatt, venice"
echo "  grok-models refresh"
echo "  grok                          # ask it to apply ~/.config/grok-models/resolved.json"
echo
echo "Keys stay in ${CFG_DIR}/keys.env (mode 600). Never commit them."

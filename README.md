# grok-build-byok

Bootstrap **Grok Build** on a new Linux host with a short pickable model list (OpenRouter / Neuralwatt / Venice). Native default stays `grok-4.6`. API keys never go in git or in `config.toml`.

Private repo. Working helper scripts, not a screenshot of a desktop.

## On the new VPS

```bash
# 1. Official Grok
curl -fsSL https://x.ai/cli/install.sh | bash
# SSH / no browser:
grok login --device-auth

# 2. This helper
git clone https://github.com/ARMedS/grok-build-byok.git
cd grok-build-byok
./install.sh

# 3. Keys (hidden prompt; stored in ~/.config/grok-models/keys.env mode 600)
grok-models key openrouter
grok-models key neuralwatt
grok-models key venice

# 4. Resolve the allowlist (does not write TOML)
grok-models refresh

# 5. Start Grok and ask it to apply ~/.config/grok-models/resolved.json
#    into the grok-models-helper markers. Then: new session, /model
grok
```

Put `~/.local/bin` on `PATH` (the installer appends this to `~/.bashrc`). The `grok` wrapper there loads keys then execs `~/.grok/bin/grok`.

## Layout

| Path | Role |
|------|------|
| `bin/grok-models` | Keys, catalog, allowlist. Never writes TOML. |
| `bin/grok` | `eval "$(grok-models env)"` then real grok |
| `config/allowlist.json` | ~16 families |
| `config/config.toml.example` | Default `grok-4.6` + empty helper markers |
| `AGENTS.md` | Standing rules for Grok on the new host |
| `install.sh` | Installs the above into `~/.local/bin` and `~/.config/grok-models` |

## Do not commit

`keys.env`, `catalog.json`, `resolved.json`, `~/.grok/auth.json`.

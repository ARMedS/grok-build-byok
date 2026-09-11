# grok-build-byok

Bootstrap **Grok Build** on a new Linux host with a short pickable model list (OpenRouter / Neuralwatt / Venice). Native default stays `grok-4.6`. API keys never go in git or in `config.toml`.

Private repo. Working helper scripts, not a screenshot of a desktop.

## Automatic model synchronization

The picker writes the selected models to `allowlist.json`, refresh resolves them to `resolved.json`, and the helper replaces only the region between `# BEGIN grok-models-helper` and `# END grok-models-helper` in `~/.grok/config.toml`. The complete candidate TOML is parsed before replacement, and the previous config is backed up to `~/.grok/config.toml.bak-grok-models`.

The wrapper reapplies the last successful `resolved.json` before every Grok launch. Startup does not contact provider APIs; run `grok-models refresh` when a new catalog is needed. The full provider catalog is never written to TOML.

Useful commands:

```bash
grok-models apply --dry-run
grok-models apply
grok-models refresh
```

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

# 4. Choose models and save; the picker applies the managed TOML block
grok-models
# Or select directly:
# grok-models pick openrouter

# 5. Start Grok; the wrapper reapplies the last resolved selection automatically
grok
```

Put `~/.local/bin` on `PATH` (the installer appends this to `~/.bashrc`). The `grok` wrapper there loads keys, applies the last successful `resolved.json` selection to the managed config block, then execs `~/.grok/bin/grok`. It does not refresh remote catalogs during startup.

## Layout

| Path | Role |
|------|------|
| `bin/grok-models` | Keys, catalog, allowlist, picker, and the validated managed TOML model block. |
| `bin/grok` | Loads keys, applies the last resolved selection, then launches real Grok |
| `config/allowlist.json` | ~16 families |
| `config/config.toml.example` | Default `grok-4.6` + empty helper markers |
| `AGENTS.md` | Standing rules for Grok on the new host |
| `install.sh` | Installs the above into `~/.local/bin` and `~/.config/grok-models` |

## Do not commit

`keys.env`, `catalog.json`, `resolved.json`, `~/.grok/auth.json`.

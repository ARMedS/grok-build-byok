# Grok Build on this host (BYOK helper)

You are Grok Build. Native default is **grok-4.6**. Other models are optional BYOK via OpenRouter, Neuralwatt, and Venice.

## Two pieces (do not merge them)

1. **`~/.local/bin/grok-models`** — keys, live catalog, picker, allowlist, and the validated managed model block in `~/.grok/config.toml`. It writes only between the `# BEGIN grok-models-helper` / `# END grok-models-helper` markers (with a `.bak-grok-models` backup first) and refuses to write if the resulting TOML would not parse.
2. **The helper owns only** that marker region; Grok Build owns the rest of the config. Do not hand-edit the managed block or duplicate `[model.*]` tables outside it.

Dumping a provider’s full `/v1/models` list into TOML caused `duplicate key` parse errors and made `grok` refuse to start. Keep about 16 unique `[model.NAME]` tables.

## Keys

- Source of truth: `~/.config/grok-models/keys.env` (directory mode `700`, file `600`).
- Env vars: `OPENROUTER_API_KEY`, `NEURALWATT_API_KEY`, `VENICE_API_KEY`.
- TOML and OpenCode config use `env_key` / `{env:VAR}` only. Never paste a key into TOML, OpenCode config, git, or chat.
- `grok-models env` prints `export …` for `eval "$(grok-models env)"`.
- SSH must source `keys.env` from `~/.bashrc` (this repo’s `install.sh` adds that). A 401 from OpenRouter that Grok labels as `/login` is usually **missing process env**, not a dead xAI session. Native Grok still works in that case.

```bash
grok-models key openrouter   # or neuralwatt, venice
grok-models refresh          # re-fetch catalogs, re-resolve, sync config.toml
grok-models apply [--dry-run]
grok-models pick [provider]  # interactive checkbox picker
grok-models status
```

## Automatic model synchronization

Saving the picker, running `grok-models refresh`, or starting the `grok` wrapper (which reapplies the last successful selection) writes the selected non-native entries as unique `[model.NAME]` tables inside the helper markers. The complete TOML is validated first and the previous config is backed up to `~/.grok/config.toml.bak-grok-models`. The full provider catalog is never written to TOML, and `[cli]` / `[ui]` / `[models]` / `[mcp_servers]` remain outside the managed block. Only re-point `[models] default` if it names a model that no longer exists (closest current equivalent: `nw-glm-5-3-flash`); on fresh hosts keep native `[models] default = "grok-4.6"`.

Validate:

```bash
python3 -c "import tomllib; tomllib.load(open('$HOME/.grok/config.toml','rb'))"
grok inspect
grok models
```

## Allowlist

`~/.config/grok-models/allowlist.json` (copy from this repo, `config/allowlist.json`). Version 3: each family is either `auto: true` (resolve newest matching variant) or pinned `auto: false` (resolve each exact id). Exact id if present, else fallback, else newest prefix. Skip `*-flex`, `*-fast`, `*-short`, `*:free` unless listed exactly.

Adapt families for **this** machine. Do not copy Pop!_OS desktop tooling (YouGrok, Cosmic dock, Blender/Inkscape MCP) onto a VPS.

## OpenCode

`~/.config/opencode/opencode.json` mirrors the same selection: three custom providers (neuralwatt, openrouter, venice) on `@ai-sdk/openai-compatible`, `whitelist` per provider to exactly the resolved models, `apiKey: "{env:NEURALWATT_API_KEY}"` etc. — never a literal key. `enabled_providers` restricts to the three. Default: `neuralwatt/glm-5.3-flash`. After changing the grok-models selection, update this file to match `resolved.json` (ids, names, context/output limits) and run `opencode models` + `opencode run "…" -m provider/model` per provider to verify.

## Other programs (LangChain, scripts)

Same `keys.env` is readable by this user (`600`). Load it (`dotenv` or `set -a; . ~/.config/grok-models/keys.env; set +a`). Do not copy keys into a project `.env` that might be committed.

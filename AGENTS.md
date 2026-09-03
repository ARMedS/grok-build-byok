# Grok Build on this host (BYOK helper)

You are Grok Build. Native default is **grok-4.6**. Other models are optional BYOK via OpenRouter, Neuralwatt, and Venice.

## Two pieces (do not merge them)

1. **`~/.local/bin/grok-models`** — keys, live catalog, short allowlist. **Never writes** `~/.grok/config.toml`.
2. **You (Grok Build)** — own the region between `# BEGIN grok-models-helper` and `# END grok-models-helper` in `~/.grok/config.toml`.

Dumping a provider’s full `/v1/models` list into TOML caused `duplicate key` parse errors and made `grok` refuse to start. Keep about 16 unique `[model.NAME]` tables.

## Keys

- Source of truth: `~/.config/grok-models/keys.env` (directory mode `700`, file `600`).
- Env vars: `OPENROUTER_API_KEY`, `NEURALWATT_API_KEY`, `VENICE_API_KEY`.
- TOML uses `env_key` only. Never paste a key into TOML, git, or chat.
- `grok-models env` prints `export …` for `eval "$(grok-models env)"`.
- SSH must source `keys.env` from `~/.bashrc` (this repo’s `install.sh` adds that). A 401 from OpenRouter that Grok labels as `/login` is usually **missing process env**, not a dead xAI session. Native Grok still works in that case.

```bash
grok-models key openrouter   # or neuralwatt, venice
grok-models refresh
grok-models status
```

## After refresh — your job

Read `~/.config/grok-models/resolved.json`. Emit only non-native entries as unique `[model.NAME]` tables (`env_key`, `api_backend = "chat_completions"`, `stream_tool_calls = false`). Delete matching `[model.*]` outside the markers. Leave `[cli]` / `[ui]` / `[models]` / `[mcp_servers]` alone. Keep `[models] default = "grok-4.6"`.

Validate:

```bash
python3 -c "import tomllib; tomllib.load(open('$HOME/.grok/config.toml','rb'))"
grok inspect
```

## Allowlist

`~/.config/grok-models/allowlist.json` (copy from this repo). Exact id if present, else fallback, else newest prefix. Skip `*-flex`, `*-fast`, `*-short`, `*:free` unless listed.

Adapt families for **this** machine. Do not copy Pop!_OS desktop tooling (YouGrok, Cosmic dock, Blender/Inkscape MCP) onto a VPS.

## Other programs (LangChain, scripts)

Same `keys.env` is readable by this user (`600`). Load it (`dotenv` or `set -a; . ~/.config/grok-models/keys.env; set +a`). Do not copy keys into a project `.env` that might be committed.

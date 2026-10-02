grok-models — copy for the server inbox
======================================

What this is
------------
grok-models is a user-space helper on the Pop!_OS workstation that decides
which AI models get written into the CLIs (Grok Build, OpenCode, etc.).

Files in this drop
------------------
grok-models                  the script (~/.local/bin/grok-models)
grok-models-resolved.json    the currently SELECTED models (output)
grok-models-allowlist.json   the selection rules (input)
SELECTED-MODELS.txt          the same list, human-readable

NOT included (on purpose)
-------------------------
keys.env                     API keys — never copy these off the machine

How to change the selection (on the workstation)
------------------------------------------------
  grok-models              interactive menu
  grok-models pick         keyboard checkbox picker
  grok-models refresh      re-fetch catalogs and re-apply
  grok-models status       show what is selected

The helper writes only a managed block in ~/.grok/config.toml:
  # BEGIN grok-models-helper
  ...
  # END grok-models-helper

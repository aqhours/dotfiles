# Dotfiles inventory

Last checked: 2026-06-29.

## Tracked now

These are low-risk, mostly declarative config files and are listed in `tracked-files.txt`.

- Shell and CLI: `.zshrc`, `.zprofile`, `.gitconfig`, `.tmux.conf`, `.condarc`
- Prompt and terminal tools: `.config/starship.toml`, Ghostty, Fastfetch, Neofetch
- Editor/tool config: LunarVim config, VS Code user settings/snippets, OpenCode config/plugin code
- Git ignore rules: `.config/git/ignore`
- Codex declarative config: `.codex/config.toml`, `.codex/hooks.json`, `.codex/rules/default.rules`
- Homebrew package list: `Brewfile`

## Review before tracking

These can be useful to back up, but should be reviewed before adding to Git.

- `.ssh/config`: useful server aliases, but may reveal hostnames, usernames, ports, and internal IPs.
- `.nvm/.npmrc` or any `.npmrc`: often contains registry tokens; track only a redacted template.
- `.claude/settings.json` and `.claude/settings.local.json`: can contain permissions and local paths; keep out until manually reviewed.
- `Library/Preferences/com.googlecode.iterm2.plist`: iTerm2 settings, but plist may include window/session state.
- `.config/filezilla/*.xml`: may contain recent servers or site metadata; avoid unless redacted.
- `.config/ohmyghostty/*` and `.config/ohmystarship/*`: current files appear to be backup copies; add only if still actively used.
- VS Code `mcp.json`, Cursor/Windsurf settings, and other AI/editor integration files: track only after checking for tokens and local secrets.

## Never track

These should not enter Git, even in a private repository.

- SSH private keys: `.ssh/id_rsa`, `.ssh/id_ed25519`, `*.pem`, `*.key`
- SSH runtime state: `.ssh/known_hosts`, `.ssh/agent`
- GPG private material: `.gnupg/`
- Package/account credentials: `.npmrc`, `.pypirc`, `.netrc`, `.env*`
- Codex/Claude auth and runtime state: `.codex/auth.json`, `.codex/history.jsonl`, `.codex/**/*.sqlite*`, `.claude.json`, `.claude/history.jsonl`
- App caches, logs, lockfiles, sockets, databases, generated dependencies, and game saves

## Adding a new config

1. Add the `$HOME`-relative path to `tracked-files.txt`.
2. Run `./scripts/snapshot.sh`.
3. Run `./scripts/audit-secrets.sh`.
4. Inspect `git diff`.
5. Commit only after the diff is clean.

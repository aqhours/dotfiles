# dotfiles

这个仓库用于备份和版本控制本机配置。采用普通 Git 仓库结构：

- `home/`：对应 `$HOME` 下的真实配置文件。
- `tracked-files.txt`：当前允许进入版本控制的白名单。
- `scripts/snapshot.sh`：从当前机器复制白名单文件到 `home/`。
- `scripts/install.sh`：在新机器上把 `home/` 里的文件软链接回 `$HOME`。
- `Brewfile`：Homebrew 软件清单。

## 日常更新

```sh
cd /Users/jiiong/Documents/Tool/dotfiles
./scripts/snapshot.sh
brew bundle dump --file=Brewfile --force
./scripts/audit-secrets.sh
git diff --stat
git diff
git add -A
git commit -m "Update dotfiles"
```

提交前一定先看 `git diff`。如果看到 token、密码、私钥、历史记录、数据库、缓存，停止提交，把对应路径从 `tracked-files.txt` 移除，并补进 `.gitignore`。

## 恢复到新机器

先预演，不改文件：

```sh
./scripts/install.sh --dry-run
```

确认无误后再执行：

```sh
./scripts/install.sh --apply
```

如果目标位置已经有文件，脚本会先移动到 `~/.dotfiles-backup/<timestamp>/`，再建立软链接。

## 推到远程

```sh
git remote add origin git@github.com:YOUR_NAME/dotfiles.git
git push -u origin main
```

这个仓库可以放在 public GitHub 仓库里，但每次推送前都要先跑 `./scripts/audit-secrets.sh` 并检查 `git diff`。`docs/inventory.md` 里标记为“需要确认”或“Never track”的项目不要直接提交。

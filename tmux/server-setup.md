# Replicating tmux setup on a new server

Covers airgapped RHEL/CentOS servers. Adapt package manager commands for other distros.

## Prerequisites

tmux 3.2+ must already be installed:
```bash
tmux -V
```

---

## Step 1 — Transfer files from source machine

Run on the **source machine** (Mac or existing server):

```bash
# Pack tmux config + plugins
tar czf tmux-bundle.tar.gz ~/.tmux.conf ~/.tmux/plugins/

# Copy to target
scp tmux-bundle.tar.gz user@target-server:~
```

On the **target server**:
```bash
tar xzf tmux-bundle.tar.gz
```

---

## Step 2 — Install packages

```bash
sudo dnf install pass gnupg2 sshpass pinentry-curses
```

If `xclip` is available (needed only for clipboard in copy mode, not required for SSH shortcut):
```bash
sudo dnf install xclip
```

---

## Step 3 — Configure GPG pinentry for headless server

Without this, `gpg --gen-key` fails with `No pinentry` on SSH sessions:

```bash
mkdir -p ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
chmod 700 ~/.gnupg
gpgconf --kill gpg-agent
```

---

## Step 4 — Generate GPG key and initialize pass

```bash
gpg --gen-key
```

When prompted: enter name and email, leave passphrase **empty** (press Enter twice) for passwordless unlock on headless servers.

Note the key ID from the output (long hex string), then:

```bash
pass init <your-gpg-key-id>
```

---

## Step 5 — Store SSH password

```bash
pass insert ssh-passwd
```

Type your password when prompted (twice to confirm). Verify:
```bash
pass show ssh-passwd
```

---

## Step 6 — Update .zshrc

Add these lines to `~/.zshrc`:

```bash
# Disable XON/XOFF so Ctrl+S reaches tmux
stty -ixon

# SSH with password from pass store (usage: s user@host)
s() {
  SSHPASS="$(pass show ssh-passwd)" sshpass -e ssh "$@"
}
```

Apply:
```bash
source ~/.zshrc
```

---

## Step 7 — Load tmux config

If tmux is already running:
```bash
tmux source ~/.tmux.conf
```

Otherwise just start tmux — it picks up `~/.tmux.conf` automatically.

---

## Step 8 — Verify

Test the `s` function directly:
```bash
s user@some-device
```

Test the `Ctrl+S` shortcut:
1. In tmux copy mode (`C-a [`), select a hostname and press `y` to copy it to the tmux buffer
2. Press `Ctrl+S` — should connect and authenticate automatically

---

## Updating config from dotfiles later

When `.tmux.conf` changes in the repo, transfer and apply:

```bash
# On source machine
scp ~/.tmux.conf user@target-server:~

# On target server
tmux source ~/.tmux.conf
```

---

## Troubleshooting

| Symptom | Cause | Fix |
| ------- | ----- | --- |
| `No pinentry` on gpg --gen-key | pinentry-curses not configured | Step 3 |
| `Ctrl+S` freezes terminal | XON/XOFF not disabled | Add `stty -ixon` to `.zshrc` |
| `Ctrl+S` does nothing | tmux config not reloaded | `tmux source ~/.tmux.conf` |
| `s hostname` asks for password | Wrong password in pass | `pass edit ssh-passwd` |
| Plugins missing after transfer | Archive didn't include `.tmux/plugins/` | Re-pack with correct path |
| `C-a C-s` conflicts with `Ctrl+S` SSH | They use different key tables | Not a conflict — `C-a C-s` requires prefix, `Ctrl+S` does not |

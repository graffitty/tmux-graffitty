# graffitty.tmux

Seamless Ctrl-H/J/K/L navigation through Neovim splits, tmux panes and Graffitty
panes. A TPM plugin with native tmux bindings and no background helper.

## Install with TPM

This checkout is currently a local Git repository. TPM accepts its absolute
path as the plugin source. Add it after other navigation plugins and before TPM
initialization in `~/.tmux.conf`:

```tmux
set -g @plugin '/absolute/path/to/graffitty.tmux'
run '~/.tmux/plugins/tpm/tpm'
```

Reload your tmux config, then press **prefix + I**. TPM clones the local source
into `~/.tmux/plugins/graffitty.tmux`. **Prefix + U** updates that clone from
commits in the source repository. Once the repository is published, replace the
absolute path with its Git URL or `owner/graffitty.tmux`.

Remove any old `source-file ~/.config/graffitty/tmux-navigator.conf` line; TPM
loads the plugin's executable entry point automatically. Repeated loads do not
add duplicate Graffitty environment variables.

Keep `gft` on PATH for Graffitty edge navigation. No CLI command runs when
loading this plugin or moving between tmux panes. The Graffitty-provided
`GRAFFITTY_BIN` is used when present.

For Neovim, install `graffitty.nvim` and configure:

```lua
require('graffitty').setup({
  navigator = { enable_default_keybindings = true, tmux = 'auto' },
})
```

Disable competing Neovim navigation mappings. The plugin preserves existing
custom mappings, so another plugin can otherwise retain ownership of the keys.

## Behavior

| Key | tmux direction | Graffitty edge command |
| --- | --- | --- |
| Ctrl-H | left | `gft navigate left` |
| Ctrl-J | down | `gft navigate down` |
| Ctrl-K | up | `gft navigate up` |
| Ctrl-L | right | `gft navigate right` |

Foreground applications receive their own keys. Neovim first tries its splits,
then tmux; shell panes move directly between tmux panes. Only an outer edge
invokes `gft`, passing the initiating client TTY to select the correct Graffitty
attachment. Copy mode keeps its bindings, zoomed panes remain zoomed, and pane
navigation never wraps. Without Graffitty, it stops at the tmux edge.

One tmux layer is supported. Plain SSH retains its keys and has no local
Graffitty handoff. Command-H remains the macOS Hide shortcut.

## Development

The source is vendored into Graffitty by `tools/sync_tmux_integration.py`.
The Graffitty repository's `tests/navigator_e2e.py --tpm /path/to/tpm` installs
this plugin with TPM in an isolated tmux server and exercises real keypresses.
The legacy `gft navigator tmux-config` command prints the same bundled config
for users who do not use TPM.

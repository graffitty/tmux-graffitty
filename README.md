# tmux-graffitty

Seamless Ctrl-H/J/K/L navigation through Neovim splits, tmux panes and Graffitty
panes, using native tmux bindings.

## Install with TPM

Add the plugin before TPM initialization in `~/.tmux.conf`:

```tmux
set -g @plugin 'graffitty/tmux-graffitty'
run '~/.tmux/plugins/tpm/tpm'
```

Reload with `tmux source-file ~/.tmux.conf`, then press **prefix + I** to install.
Use Ctrl-H/J/K/L to move left/down/up/right between panes.

Keep Graffitty's `gft` command on PATH to navigate into neighboring Graffitty panes.

For Neovim, install [graffitty.nvim](https://github.com/graffitty/graffitty.nvim)
and configure its navigation mappings through lazy.nvim:

```lua
{
  "graffitty/graffitty.nvim",
  opts = {},
  keys = {
    { "<C-h>", function() require("graffitty.navigator").move_left() end, desc = "Navigate left" },
    { "<C-j>", function() require("graffitty.navigator").move_down() end, desc = "Navigate down" },
    { "<C-k>", function() require("graffitty.navigator").move_up() end, desc = "Navigate up" },
    { "<C-l>", function() require("graffitty.navigator").move_right() end, desc = "Navigate right" },
  },
}
```

For navigation from shells outside tmux, set `[navigator] enabled = true` in
Graffitty's `server.toml`.

## Install without TPM

You can instead paste the contents of
[`scripts/navigation.conf`](scripts/navigation.conf) directly into
`~/.tmux.conf`, after any other navigation bindings. Reload with
`tmux source-file ~/.tmux.conf`. You can also use `source-file` with the absolute
path to that file. Choose either this setup or the TPM plugin.

## Behavior

| Key | tmux direction | Graffitty edge command |
| --- | --- | --- |
| Ctrl-H | left | `gft select-pane -L` |
| Ctrl-J | down | `gft select-pane -D` |
| Ctrl-K | up | `gft select-pane -U` |
| Ctrl-L | right | `gft select-pane -R` |

Foreground applications receive their own keys. Neovim first tries its splits,
then tmux; shell panes move directly between tmux panes. Only an outer edge
invokes `gft`, passing the initiating client TTY to select the correct Graffitty
attachment. Copy mode keeps its bindings, zoomed panes remain zoomed, and pane
navigation never wraps. Without Graffitty, it stops at the tmux edge.

One tmux layer is supported. Plain SSH retains its keys and has no local
Graffitty handoff.

## Development

The source is vendored into Graffitty by `tools/sync_tmux_integration.py`.
The Graffitty repository's `python3 tests/navigator_container_e2e.py` installs
this plugin with TPM and exercises real keypresses in preconfigured Neovim and
tmux inside Podman. Its CLI/server, home directories and sockets are isolated
from the host. A frontend protocol observer records Graffitty edge requests.

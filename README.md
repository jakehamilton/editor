# Editor

> Choose the right tool for the job... and Neovim for everything else.

This repository contains my editor configuration. It provides an out of the box
development environment using Neovim and a handful of plugins. The editor is
meant to have quality of life improvements that I have learned to appreciate
and remain minimal in terms of functionality.

## Quick Start

Run this editor directly using [Nilla](https://nilla.dev).

```shell
nilla run -p github:jakehamilton/editor
```

## Nix

Nix is used to fetch dependencies and to package the editor as a single unit that
can be shipped to different systems or environments. [Nilla](https://nilla.dev) is
used to manage the Nix project, [npins](https://github.com/andir/npins) is used to
pin dependencies, and [Gift Wrap](https://github.com/tgirlcloud/gift-wrap) is used
to build a customized Neovim package. The entrypoint for Nix is
[`nilla.nix`](./nilla.nix).

## Fennel

This repository's configuration is written in Fennel rather than Lua. Still, Lua is
required to begin the process. This initialization code exists inline in
[`package.nix`](./package.nix) using Gift Wrap's `extraInitLua` option. There,
Fennel is imported and installed into the Lua runtime. After installation, Fennel
code can be imported directly using Lua's `require` function. From here, the
configuration in [`config/fnl/editor/init.fnl`](./config/fnl/editor/init.fnl) takes
over.

In addition to the bootstrapping process, some macros are automatically injected
to ease development. These macros live in
[`config/fnl/editor/macros`](./config/fnl/editor/macros) and are hardcoded in the
initial Lua script to be prepended to any Fennel source that is imported. This
allows `import`, `import/macro`, `import/lua`, `export`, `vim-option`, and
`vim-global` to all be used globally.

## Theme

The color theme specification for this editor lives in the
[jakehamilton/bliss](https://github.com/jakehamilton/bliss) repository. In this
repository, the colors are implemented in
[`config/fnl/editor/theme.fnl`](./config/fnl/editor/theme.fnl). This is not done
in a best-practices kind of way. Instead, it has been done organically by changing
colors as the editor has been used and customized. There are likely parts missing
and it is not capable of being imported in another configuration without effort.

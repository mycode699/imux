# iccd-remote

`iccd-remote` is the internal remote helper used by `imux` for managed SSH workspaces.

Historical note:

- The product is `imux`.
- The daemon binary intentionally retains the legacy name `iccd-remote`.

## Responsibilities

- bootstrap remote control for `imux ssh`
- proxy browser and helper traffic through the remote session
- coordinate managed PTY attachments and resize semantics
- relay selected CLI calls from the remote host back to the local app

## Main commands

1. `iccd-remote version`
2. `iccd-remote serve --stdio`
3. `iccd-remote cli <command> [args...]`

When invoked as `imux` through the installed remote wrapper, the binary can auto-dispatch to the CLI relay path.

## RPC families

1. `hello`
2. `ping`
3. `proxy.*`
4. `session.*`

## Release note

Even though this daemon keeps the old name, release-facing documentation should describe it as the remote helper for `imux`, not as a separate end-user product.

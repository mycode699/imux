# Ghostty Fork Notes

This repository ships `icc`, but it still carries a Ghostty fork for changes that have not been fully removed or upstreamed.

Current submodule remote:

<https://github.com/manaflow-ai/ghostty>

## Why this doc exists

- track fork-only behavior required by the app
- document high-conflict files for rebases
- keep product docs honest about where `icc` diverges from upstream Ghostty

## Active fork areas

At the time of this release prep, the fork is primarily used for:

1. notification parsing support needed by the app
2. macOS display-link and stale-frame fixes
3. keyboard copy-mode API support used by the terminal host
4. zsh prompt redraw handling for Ghostty shell integration
5. helper hooks used by the theme picker flow

## Contribution workflow

1. Make and verify the Ghostty change inside `ghostty/`.
2. Push the submodule change to its actual remote first.
3. Update this file with the reason for carrying the patch.
4. Commit the parent repository with the new submodule SHA.

## Important caution

Even though the product name is now `icc`, this document should continue to use the real upstream and fork names where accuracy matters. Do not rename Ghostty fork references just for branding.

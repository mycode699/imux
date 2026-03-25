# ICC Brand Guidelines

This file defines the user-facing identity for `icc`.

## Canonical identity

- Product name: `icc`
- Repository: `miounet11/icc`
- App label: `icc`
- CLI name: `icc`
- Short descriptor: `AI Command Center for macOS`

Use `icc` in lowercase for product mentions unless a platform surface forces another style.

## Product positioning

`icc` is a native macOS command center for AI work. It combines:

- Ghostty-grade terminal rendering
- local and remote file exploration
- in-app file viewing and editing
- browser-assisted execution
- supervisor-driven planning and automation

The product promise is simple:

- move from intent to execution quickly
- keep project context visible while working
- handle local and remote work from one workspace

## Messaging pillars

When describing `icc`, emphasize these ideas:

1. Native macOS workspace, not a web wrapper.
2. Terminal-first, but not terminal-only.
3. Built for agent-driven execution, supervision, and iteration.
4. Local and remote context should stay visible beside the active terminal conversation.

## Naming rules

- Use `icc` for all user-facing product references.
- Use `icc` for the shipped CLI, release notes, screenshots, onboarding copy, and support text.
- Only mention legacy `cmux` names when accuracy or compatibility requires it.
- Keep `Ghostty`, `libghostty`, and upstream repository names accurate when discussing the rendering stack or fork history.

## Copy style

- Prefer direct, operational language.
- Emphasize speed, visibility, control, and execution.
- Avoid describing `icc` as only a terminal emulator or only a Ghostty fork.
- Avoid mixing old and new product names in the same user-facing paragraph unless the paragraph is explicitly about migration or compatibility.

## Release and documentation checklist

Before shipping a public release:

- update [README.md](../README.md) and the localized README landing pages
- keep install and upgrade URLs pointed at `miounet11/icc`
- verify that screenshots, issue templates, and support links use `icc`
- document any legacy `cmux` references as compatibility notes rather than product naming

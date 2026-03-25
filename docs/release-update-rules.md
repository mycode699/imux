# Release And Update Rules

This file is the operator guide for future `icc` releases and upgrades.

## Source of truth

The control file is:

- `scripts/release-config.sh`

Keep all canonical release values there:

- GitHub repo slug
- stable and nightly feed URLs
- DMG names
- appcast file names
- nightly bundle ID
- release notes and commit URL prefixes

## Upgrade request addresses

Stable Sparkle feed:

- `https://github.com/miounet11/icc/releases/latest/download/appcast.xml`

Nightly Sparkle feed:

- `https://github.com/miounet11/icc/releases/download/nightly/appcast.xml`

## Control files

Stable channel:

- `appcast.xml`

Nightly channel:

- `appcast.xml`
- `appcast-universal.xml`

Remote helper manifest:

- `remote-daemon-assets/cmuxd-remote-manifest.json`

Compatibility note:

- The remote helper and several manifest fields still use the legacy `cmuxd-remote` name. Do not rename those casually; they are part of the working remote bootstrap path.

## Asset naming rules

Stable release assets:

- `icc-macos.dmg`
- `appcast.xml`

Nightly release assets:

- `icc-nightly-macos.dmg`
- `icc-nightly-macos-<build>.dmg`
- `appcast.xml`
- `appcast-universal.xml`

## Version rules

- Marketing version uses semantic versioning, for example `0.0.1`.
- Git tags must use the `v` prefix, for example `v0.0.1`.
- `CURRENT_PROJECT_VERSION` must remain monotonic for Sparkle.
- `scripts/bump-version.sh` should remain the normal way to set or bump versions.

## Current baseline

- Initial repo line: `v0.0.1`
- Repository: `https://github.com/miounet11/icc`

## Release workflow rules

1. Update `MARKETING_VERSION` to the target release, currently `0.0.1`.
2. Keep `CURRENT_PROJECT_VERSION` increasing even if the marketing version resets for branding reasons.
3. Push the branch to `miounet11/icc`.
4. Create and push a tag such as `v0.0.1` only after signing and release secrets are ready.
5. Let `.github/workflows/release.yml` publish the DMG, `appcast.xml`, and remote helper assets.

## Important migration note

Older internal builds used different repository identities and in some cases higher pre-release version strings. If a machine is already running one of those older internal builds, do one manual reinstall onto the first public `icc` release. After that, Sparkle can follow the new `icc` feed normally.

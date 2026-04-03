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

- `https://www.iccjk.com/downloads/appcast.xml`

Nightly Sparkle feed:

- served from the active GitHub nightly release asset for the release repo

## Control files

Stable channel:

- `appcast.xml`
- `latest.json`

Nightly channel:

- `appcast.xml`
- `appcast-universal.xml`

Remote helper manifest:

- `https://www.iccjk.com/downloads/remote/iccd-remote-manifest.json`

Compatibility note:

- The remote helper and several manifest fields still use the legacy `iccd-remote` name. Do not rename those casually; they are part of the working remote bootstrap path.

## Asset naming rules

Stable release assets:

- `icc-v1.0.6-macos.dmg`
- `appcast.xml`
- `latest.json`

Website-hosted archive copies:

- `downloads/archive/v1.0.6/icc-v1.0.6-macos.dmg`
- `downloads/archive/v1.0.6/appcast.xml`

Website-hosted latest aliases:

- `downloads/icc-v1.0.6-macos.dmg`
- `downloads/icc-macos.dmg`
- `downloads/appcast.xml`
- `downloads/latest.json`

Nightly release assets:

- `icc-nightly-macos.dmg`
- `icc-nightly-macos-<build>.dmg`
- `appcast.xml`
- `appcast-universal.xml`

## Version rules

- Marketing version uses semantic versioning, for example `1.0.6`.
- Git tags must use the `v` prefix, for example `v1.0.6`.
- `CURRENT_PROJECT_VERSION` must remain monotonic for Sparkle.
- `scripts/bump-version.sh` should remain the normal way to set or bump versions.

## Current baseline

- Current public stable line: `v1.5.1`
- Repository: `https://github.com/mycode699/imux`

## Local operator env

Store local release and website deployment secrets in the repo root `.env`.

- `.env` is gitignored and should stay local-only.
- `.env.example` is the checked-in template for required keys.
- Release signing still comes from `ICC_RELEASE_ENV_FILE`.
- Website VPS deployment now reads the same root `.env`.

Current website deploy keys:

- `ICC_DEPLOY_HOST`
- `ICC_DEPLOY_USER`
- `ICC_DEPLOY_PASSWORD`
- `ICC_DEPLOY_PORT`
- `ICC_DEPLOY_SITE_ROOT`
- `ICC_DEPLOY_SERVICE`
- `ICC_DEPLOY_SITE_URL`

Current production values on the active website host:

- `ICC_DEPLOY_SITE_ROOT=/opt/iccjk-site`
- `ICC_DEPLOY_SERVICE=iccjk-site.service`
- The Next.js runtime serves from `current` under that root and the parent `CHANGELOG.md`.

## Release workflow rules

1. Update `MARKETING_VERSION` to the target release, currently `1.5.1`.
2. Keep `CURRENT_PROJECT_VERSION` increasing even if the marketing version resets for branding reasons.
3. Build the signed and notarized macOS app, then generate `appcast.xml` with the matching Sparkle private key.
4. Stage the DMG, appcast, release manifest, and remote helper assets into `web/public/downloads` or the production site's `public/downloads` directory.
5. Push the staged `web/public/downloads` update onto `main` so the website deployment picks up the same release state as the tag build.
6. Deploy the website so `iccjk.com` serves the new DMG, `appcast.xml`, `latest.json`, and remote helper manifest.
7. Push the branch to `mycode699/imux`.
8. Create and push a tag such as `v1.5.1` after the website-hosted artifacts have been verified.

## Website deploy command

Use the local env-backed helper:

```bash
./scripts/deploy-website-vps.sh
```

Helpful variants:

```bash
./scripts/deploy-website-vps.sh --dry-run
./scripts/deploy-website-vps.sh --env-file ~/.secrets/icc-site.env
```

Behavior:

- Reads local VPS credentials from `.env` by default.
- Uploads `web/` into a new staged directory under the configured site root.
- Copies the repo root `CHANGELOG.md` to the parent site root so `/changelog` stays current.
- Runs `npm ci`, falls back to `npm install` if the lockfile and package manifest drift again, then builds the site.
- Swaps the staged directory into `current`, restarts the configured systemd service, and verifies the live manifest, DMG URL, changelog page, and homepage download link.

## Important migration note

Older internal builds used different repository identities and in some cases higher pre-release version strings. If a machine is already running one of those older internal builds, do one manual reinstall onto the first public `icc` release. After that, Sparkle can follow the new `icc` feed normally.

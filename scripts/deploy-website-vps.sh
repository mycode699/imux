#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "${ROOT_DIR}/scripts/release-config.sh"

usage() {
  cat <<'EOF'
Usage: ./scripts/deploy-website-vps.sh [--env-file <path>] [--dry-run] [--skip-verify]

Deploy the local web app plus root CHANGELOG.md to the configured VPS website runtime.

Default env file:
  ./.env

Required env variables:
  ICC_DEPLOY_HOST
  ICC_DEPLOY_USER
  ICC_DEPLOY_PASSWORD

Optional env variables:
  ICC_DEPLOY_PORT=22
  ICC_DEPLOY_SITE_ROOT=/opt/iccjk-site
  ICC_DEPLOY_SERVICE=iccjk-site.service
  ICC_DEPLOY_SITE_URL=https://www.iccjk.com
  ICC_RELEASE_ENV_FILE=$HOME/.secrets/icc-release.env.sh

Examples:
  ./scripts/deploy-website-vps.sh
  ./scripts/deploy-website-vps.sh --env-file ~/.secrets/icc-site.env
  ./scripts/deploy-website-vps.sh --dry-run
EOF
}

ENV_FILE="${ICC_DEPLOY_ENV_FILE:-${ROOT_DIR}/.env}"
DRY_RUN="false"
SKIP_VERIFY="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env-file)
      ENV_FILE="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    --skip-verify)
      SKIP_VERIFY="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -f "$ENV_FILE" ]]; then
  echo "error: missing deploy env file: $ENV_FILE" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

ICC_DEPLOY_PORT="${ICC_DEPLOY_PORT:-22}"
ICC_DEPLOY_SITE_ROOT="${ICC_DEPLOY_SITE_ROOT:-/opt/iccjk-site}"
ICC_DEPLOY_SERVICE="${ICC_DEPLOY_SERVICE:-iccjk-site.service}"
ICC_DEPLOY_SITE_URL="${ICC_DEPLOY_SITE_URL:-$ICC_SITE_URL}"

for tool in sshpass ssh scp rsync python3 curl; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "error: missing required tool: $tool" >&2
    exit 1
  }
done

for var_name in ICC_DEPLOY_HOST ICC_DEPLOY_USER ICC_DEPLOY_PASSWORD; do
  if [[ -z "${!var_name:-}" ]]; then
    echo "error: missing required env var ${var_name} in ${ENV_FILE}" >&2
    exit 1
  fi
done

LATEST_JSON="${ROOT_DIR}/web/public/downloads/latest.json"
if [[ ! -f "$LATEST_JSON" ]]; then
  echo "error: missing local release manifest: $LATEST_JSON" >&2
  exit 1
fi

release_info="$(python3 - "$LATEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as fh:
    data = json.load(fh)

print(data["tag"])
print(data["version"])
print(data["downloads"]["macos"]["url"].rsplit("/", 1)[-1])
PY
)"

TAG="$(printf '%s\n' "$release_info" | sed -n '1p')"
VERSION="$(printf '%s\n' "$release_info" | sed -n '2p')"
DMG_BASENAME="$(printf '%s\n' "$release_info" | sed -n '3p')"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
DEPLOY_DIR="${ICC_DEPLOY_SITE_ROOT}/current.deploy-${TIMESTAMP}"
CURRENT_DIR="${ICC_DEPLOY_SITE_ROOT}/current"
BACKUP_DIR="${ICC_DEPLOY_SITE_ROOT}/backups/current-pre-${TAG}-${TIMESTAMP}"

export SSHPASS="${ICC_DEPLOY_PASSWORD}"
SSH_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
)

remote() {
  sshpass -e ssh -p "$ICC_DEPLOY_PORT" "${SSH_OPTS[@]}" "${ICC_DEPLOY_USER}@${ICC_DEPLOY_HOST}" "$@"
}

remote_copy() {
  local source_path="$1"
  local dest_path="$2"
  sshpass -e scp -P "$ICC_DEPLOY_PORT" "${SSH_OPTS[@]}" "$source_path" "${ICC_DEPLOY_USER}@${ICC_DEPLOY_HOST}:${dest_path}"
}

remote_rsync() {
  local source_path="$1"
  local dest_path="$2"
  rsync -az --delete \
    --exclude=".git" \
    --exclude=".next" \
    --exclude="node_modules" \
    --exclude=".DS_Store" \
    -e "sshpass -e ssh -p ${ICC_DEPLOY_PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    "$source_path" "${ICC_DEPLOY_USER}@${ICC_DEPLOY_HOST}:${dest_path}"
}

echo "Website deploy configuration"
echo "  env file:      ${ENV_FILE}"
echo "  host:          ${ICC_DEPLOY_USER}@${ICC_DEPLOY_HOST}:${ICC_DEPLOY_PORT}"
echo "  site root:     ${ICC_DEPLOY_SITE_ROOT}"
echo "  service:       ${ICC_DEPLOY_SERVICE}"
echo "  site url:      ${ICC_DEPLOY_SITE_URL}"
echo "  release tag:   ${TAG}"
echo "  release ver:   ${VERSION}"
echo "  dmg name:      ${DMG_BASENAME}"
echo "  deploy dir:    ${DEPLOY_DIR}"
echo "  backup dir:    ${BACKUP_DIR}"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run requested; no remote changes made."
  exit 0
fi

remote "mkdir -p '${DEPLOY_DIR}' '${ICC_DEPLOY_SITE_ROOT}/backups'"
remote_rsync "${ROOT_DIR}/web/" "${DEPLOY_DIR}/"
remote_copy "${ROOT_DIR}/CHANGELOG.md" "${ICC_DEPLOY_SITE_ROOT}/CHANGELOG.md"

remote bash -s -- "$DEPLOY_DIR" "$CURRENT_DIR" "$BACKUP_DIR" "$ICC_DEPLOY_SERVICE" <<'REMOTE'
set -euo pipefail

deploy_dir="$1"
current_dir="$2"
backup_dir="$3"
service_name="$4"

cd "$deploy_dir"

if ! npm ci --no-fund --no-audit; then
  echo "npm ci failed; falling back to npm install" >&2
  npm install --no-fund --no-audit
fi

NEXT_TELEMETRY_DISABLED=1 SKIP_ENV_VALIDATION=1 npm run build

if [[ -d "$current_dir" ]]; then
  mv "$current_dir" "$backup_dir"
fi

mv "$deploy_dir" "$current_dir"
systemctl restart "$service_name"
systemctl is-active "$service_name" >/dev/null
REMOTE

echo "Remote deploy completed."
echo "Backup saved at ${BACKUP_DIR}"

if [[ "$SKIP_VERIFY" == "true" ]]; then
  echo "Verification skipped."
  exit 0
fi

MANIFEST_URL="${ICC_DEPLOY_SITE_URL%/}/downloads/latest.json"
HOMEPAGE_URL="${ICC_DEPLOY_SITE_URL%/}/"
CHANGELOG_URL="${ICC_DEPLOY_SITE_URL%/}/changelog"

verify_info="$(python3 - "$MANIFEST_URL" <<'PY'
import json
import sys
import urllib.request

with urllib.request.urlopen(sys.argv[1], timeout=30) as response:
    data = json.load(response)

print(data["tag"])
print(data["version"])
print(data["downloads"]["macos"]["url"])
PY
)"

VERIFY_TAG="$(printf '%s\n' "$verify_info" | sed -n '1p')"
VERIFY_VERSION="$(printf '%s\n' "$verify_info" | sed -n '2p')"
VERIFY_DMG_URL="$(printf '%s\n' "$verify_info" | sed -n '3p')"

if [[ "$VERIFY_TAG" != "$TAG" || "$VERIFY_VERSION" != "$VERSION" ]]; then
  echo "error: live manifest mismatch after deploy: tag=${VERIFY_TAG} version=${VERIFY_VERSION}" >&2
  exit 1
fi

curl -fsSI -L --max-redirs 5 "$VERIFY_DMG_URL" >/dev/null
curl -fsSL -A "Mozilla/5.0" "$CHANGELOG_URL" | grep -q "$VERSION"
curl -fsSL -A "Mozilla/5.0" "$HOMEPAGE_URL" | grep -q "$DMG_BASENAME"

echo "Verified live site:"
echo "  manifest:  ${MANIFEST_URL}"
echo "  dmg:       ${VERIFY_DMG_URL}"
echo "  changelog: ${CHANGELOG_URL}"
echo "  homepage:  ${HOMEPAGE_URL}"

#!/bin/bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# release.sh — Ada Flutter Plugin release script
# ──────────────────────────────────────────────────────────────
# Usage:  ./release.sh <new-version>
# Example: ./release.sh 1.6.0
# ──────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}ℹ  $*${NC}"; }
ok()    { echo -e "${GREEN}✔  $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠  $*${NC}"; }
err()   { echo -e "${RED}✖  $*${NC}" >&2; }

# ── 0. Validate arguments ────────────────────────────────────
if [[ $# -ne 1 ]]; then
  err "Usage: ./release.sh <version>"
  err "Example: ./release.sh 1.6.0"
  exit 1
fi

VERSION="$1"

# Basic semver check (major.minor.patch with optional +build)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?$ ]]; then
  err "Invalid version format: $VERSION"
  err "Expected: major.minor.patch (e.g. 1.6.0) or major.minor.patch+build (e.g. 1.6.0+1)"
  exit 1
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  Ada Flutter Plugin — Release $VERSION"
echo "═══════════════════════════════════════════════"
echo ""

# ── 1. Check we are on the main branch ───────────────────────
info "Checking current branch..."
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "main" ]]; then
  err "You are on branch '$BRANCH'. Switch to 'main' before releasing."
  exit 1
fi
ok "On branch 'main'"

# ── 2. Pull latest changes ──────────────────────────────────
info "Pulling latest changes from origin/main..."
git pull origin main
ok "Up to date with origin/main"

# ── 3. Check for uncommitted changes ────────────────────────
info "Checking for uncommitted changes..."
if ! git diff --quiet || ! git diff --cached --quiet; then
  err "There are uncommitted changes. Commit or stash them before releasing."
  echo ""
  git status --short
  exit 1
fi

# Check for untracked files
UNTRACKED=$(git ls-files --others --exclude-standard)
if [[ -n "$UNTRACKED" ]]; then
  err "There are untracked files:"
  echo "$UNTRACKED"
  err "Commit, remove, or add them to .gitignore before releasing."
  exit 1
fi
ok "Working tree is clean"

# ── 4. Check if tag already exists ───────────────────────────
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  err "Tag '$VERSION' already exists. Choose a different version."
  exit 1
fi
ok "Tag '$VERSION' is available"

# ── 5. Update version in pubspec.yaml ────────────────────────
info "Updating pubspec.yaml version to $VERSION..."

if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' "s/^version: .*/version: $VERSION/" pubspec.yaml
else
  sed -i "s/^version: .*/version: $VERSION/" pubspec.yaml
fi

# Verify the change
UPDATED_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
if [[ "$UPDATED_VERSION" != "$VERSION" ]]; then
  err "Failed to update pubspec.yaml. Please update manually."
  exit 1
fi
ok "pubspec.yaml updated to $VERSION"

# ── 6. Remind about CHANGELOG.md ─────────────────────────────
echo ""
warn "Please update CHANGELOG.md before continuing."
warn "Add a new section at the top:"
echo ""
echo "  ## $VERSION"
echo ""
echo "  * your change description here"
echo ""
read -rp "$(echo -e "${YELLOW}Have you updated CHANGELOG.md? (y/n): ${NC}")" CHANGELOG_CONFIRM

if [[ "$CHANGELOG_CONFIRM" != "y" && "$CHANGELOG_CONFIRM" != "Y" ]]; then
  info "Opening CHANGELOG.md for editing..."
  if command -v code &>/dev/null; then
    code CHANGELOG.md
  elif [[ -n "${EDITOR:-}" ]]; then
    "$EDITOR" CHANGELOG.md
  else
    open CHANGELOG.md 2>/dev/null || nano CHANGELOG.md
  fi
  echo ""
  read -rp "$(echo -e "${YELLOW}Ready to continue? (y/n): ${NC}")" READY
  if [[ "$READY" != "y" && "$READY" != "Y" ]]; then
    warn "Release aborted. pubspec.yaml has been modified — revert with: git checkout pubspec.yaml"
    exit 1
  fi
fi

# ── 7. Commit changes ────────────────────────────────────────
info "Staging and committing release changes..."
git add .
git commit -m "Release $VERSION"
ok "Committed: Release $VERSION"

# ── 8. Push commit ────────────────────────────────────────────
info "Pushing commit to origin/main..."
git push origin main
ok "Commit pushed"

# ── 9. Create and push Git tag ────────────────────────────────
info "Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"
ok "Tag '$VERSION' created"

info "Pushing tag to origin..."
git push origin "$VERSION"
ok "Tag pushed"

# ── 10. Verify package (dry-run) ──────────────────────────────
info "Running flutter pub publish --dry-run..."
echo ""
if ! flutter pub publish --dry-run; then
  err "Dry-run failed. Fix the issues above before publishing."
  warn "The commit and tag have already been pushed."
  exit 1
fi
echo ""
ok "Dry-run passed"

# ── 11. Publish to pub.dev ────────────────────────────────────
echo ""
read -rp "$(echo -e "${CYAN}Publish to pub.dev now? (y/n): ${NC}")" PUBLISH_CONFIRM

if [[ "$PUBLISH_CONFIRM" == "y" || "$PUBLISH_CONFIRM" == "Y" ]]; then
  info "Publishing to pub.dev..."
  flutter pub publish --force
  echo ""
  ok "Published $VERSION to pub.dev!"
else
  warn "Skipped publishing. Run manually when ready:"
  echo "  flutter pub publish"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo -e "  ${GREEN}Release $VERSION complete!${NC}"
echo "═══════════════════════════════════════════════"
echo ""

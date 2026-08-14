# Release Guide — Ada Flutter Plugin

## Quick Release (using the script)

```bash
./release.sh 1.6.0
```

## Manual Release Steps

### 1. Ensure you are on `main` and up to date

```bash
git checkout main
git pull origin main
```

### 2. Check for uncommitted changes

```bash
git status
```

If there are uncommitted changes, commit or stash them first.

### 3. Update the version in `pubspec.yaml`

Change the `version:` field to the new version:

```yaml
version: 1.6.0
```

### 4. Update `CHANGELOG.md`

Add a new section at the top of the file with the version and a summary of changes:

```markdown
## 1.6.0

* your change description here
* another change
```

### 5. Commit the release

```bash
git add .
git commit -m "Release 1.6.0"
```

### 6. Push the commit

```bash
git push origin main
```

### 7. Create and push the Git tag

```bash
git tag -a 1.6.0 -m "Release 1.6.0"
git push origin 1.6.0
```

### 8. Verify the package

```bash
flutter pub publish --dry-run
```

Fix any issues reported before publishing.

### 9. Publish to pub.dev

```bash
flutter pub publish
```

## Version Format

Use semantic versioning: `major.minor.patch`

- **major** — breaking API changes
- **minor** — new features, backward-compatible
- **patch** — bug fixes

For build metadata use `major.minor.patch+build` (e.g. `1.6.0+1`).

## Troubleshooting

**"You are on branch 'X'"** — switch to main first: `git checkout main`

**"There are uncommitted changes"** — commit or stash: `git stash` or `git commit`

**"Tag already exists"** — you've already tagged this version. Pick a new version number.

**Dry-run fails** — read the output carefully. Common causes: missing description, invalid pubspec fields, analysis warnings.

**Publish auth error** — run `flutter pub login` to re-authenticate with pub.dev.

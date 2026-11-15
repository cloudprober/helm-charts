# Contributing

## Chart changes

Don't bump `version` in `cloudprober/Chart.yaml`. The release workflow
computes the published chart version when your change is merged.

Add a values file under `cloudprober/ci/` when you add a feature that the
default values don't exercise. CI installs the chart once with each file.

## Releasing (maintainers)

Every merge to `main` that changes what the chart ships releases a new chart
version. That means anything under `cloudprober/` except `ci/` and
`templates/tests/`. A merge that only changes CI values, the test hook,
workflows or other files outside the chart doesn't release.

- **Hold a release back:** put `[no release]` in the squash commit title.
  The held-back changes ship with the next release, even if that merge itself
  doesn't change the chart. When several PRs land together, add the marker to
  all but the last one you merge.
- **Release now:** run the "Helm Chart Lint and Release" workflow from the
  Actions tab on `main`. It releases any unreleased changes and ignores the
  marker.
- **New cloudprober versions:** the "Check for new Cloudprober release"
  workflow updates `appVersion` and starts a release.
- **A failed release:** re-run the failed run. It reuses the version it
  tagged and publishes only what's missing.

Only squash merges carry the marker reliably: with a rebase merge, the
release reads the title of the PR's last commit.

### Versions

The published version is `MAJOR.MINOR.PATCH`:

- `MAJOR.MINOR` is the sum of the `MAJOR.MINOR` parts of `version` and
  `appVersion` in `Chart.yaml`. For example, 1.0 plus cloudprober 0.14 gives
  1.14.
- `PATCH` increments with each release in that line, and starts at 0 when
  cloudprober moves to a new minor version.

Releases are tagged with the version they publish, and the tags are the
record of what has been released.

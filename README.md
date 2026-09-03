# USP Core WAAP documentation

This repository contains the USP Core WAAP (Web Application and API Protection) documentation,
published under https://docs.united-security-providers.ch/usp-core-waap/.
The content is in `content/en/<version>/`, and the site is built with Hugo and the
[USP Docs theme](https://github.com/united-security-providers/usp-docs-hugo-theme).

## Building

There are no required dependencies.
Hugo and Pagefind will always be downloaded with the make target `download-tools` on first use.

```bash
make serve           # build, then http://localhost:1313/usp-core-waap/ with live reload
make build           # build into public/, search index included
make update-theme    # move to the newest theme release
make clean           # remove the build output; bin/ stays
make download-tools  # fetch the toolchain without building
make clean-tools     # remove the toolchain from bin/
```

## Updating the theme

The theme is a Hugo module. One command moves it to the newest release and
writes `go.mod` and `go.sum`:

```bash
make update-theme                        # newest release
make update-theme THEME_VERSION=v0.3.0   # a specific one
```

Review the resulting diff, build once, and commit `go.mod` and `go.sum`.

## Making a release

A version is a directory. `latest` is the documentation under development, and a
release is a frozen copy of it beside it, named after the release. The version
selector in the header is built from the directories that exist.

1. Freeze the current documentation as the release:

```bash
make prepare-release RELEASE=2.2.x
```

2. Review the changes and then commit it to `main`:

```bash
git add content/en/2.2.x
git commit -m "Release the documentation as 2.2.x"
git push
```

Every push to `main` runs the `Publish` workflow, which builds the site and replaces the
`gh-pages` branch with it. Pull requests and pushes to other branches only run the `Build`
workflow, which checks that the site still builds.

## Generated content

Four things on a version's pages do not come from this repository and have to be
refreshed when a release is prepared, before `make prepare-release` freezes them:

- `configuration/crd-doc.md`, the API reference, generated from the operator CRD with
  [crdoc](https://github.com/fybrik/crdoc). It is the only page that carries raw HTML.
- `operation/helm/values.md`, generated from the operator chart's `values.yaml` with
  [helm-docs](https://github.com/norwoodj/helm-docs).
- The `--help` output of the Auto-Learning CLI at the end of `operation/autolearning.md`.
- The version numbers named in `_index.md`, `getting-started.md`, `operation/helm/usage.md`,
  `operation/autolearning.md` and `downloads.md`, plus the CLI jar under `latest/files/`.

## Retiring a release

`latest` always carries a banner saying that it is not a release, linking to the
newest one that is. Releases carry no banner until they reach their end of life,
which is a list in `hugo.toml`:

```toml
[params]
eol = ['1.2.x', '1.3.x']
```

Those versions show a banner saying they are no longer maintained, linking to the
current documentation, and visitors who arrive without naming a version are no
longer sent to them.

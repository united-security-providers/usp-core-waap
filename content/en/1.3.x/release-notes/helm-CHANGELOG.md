---
title: 'Helm Chart Changelog'
linkTitle: 'Helm Chart'
weight: 10
aliases:
  - '../helm-CHANGELOG/'
---
# Changelog {#changelog}

Breaking changes/additions may require to adapt existing configurations when updating, see [Migration Guide](../operation/upgrade.md).

## 1.3.0- 2025-07-10 {#130-2025-07-10}

### Contents {#contents}

- Operator 1.2.0

- Core WAAP 1.3.0

- icap 1.0.0 / openapi 0.0.6

### Fixed {#fixed}

- Disallow legacy "image:version" in `image` field in helm chart because would silently override a separately defined `version` field (use separate `image` and `version` fields instead) (#290982)

- See icap/openapi changelogs

## 1.2.1 - 2025-02-10 {#121-2025-02-10}

### Contents {#contents_1}

- Operator 1.1.0

- Core WAAP 1.2.0

- icap 0.0.10 / openapi 0.0.4

### Fixed {#fixed_1}

- See icap/openapi changelogs

## 1.2.0 - 2025-01-17 {#120-2025-01-17}

### Contents {#contents_2}

- Operator 1.1.0

- Core WAAP 1.2.0

- icap 0.0.8 / openapi 0.0.3

### Changed {#changed}

- Change `image` field of `waapSpecDefaults` to NOT include version anymore, use new `version` field instead (while for backwards compatibility the old format is still supported, but deprecated and will result in a warn log entry in the operator) (#289927)

### Added {#added}

- Add `version` field for `waapSpecDefaults` (#289927)

## 1.1.1 - 2024-09-23 {#111-2024-09-23}

### Contents {#contents_3}

- Operator 1.0.1

- Core WAAP 1.1.9

### Fixed {#fixed_2}

- Dependency to newer Core WAAP 1.1.9 to fix Coraza issue in 1.1.8

## 1.1.0 - 2024-09-23 {#110-2024-09-23}

### Contents {#contents_4}

- Operator 1.0.1

- Core WAAP 1.1.8

### Added {#added_1}

- Support operator replicas attribute to be configured (#289787)

- Schema validation for helm `values.yaml` (#289787)

### Removed {#removed}

- Remove `operator.namespace`: dedicate namespace creation back to helm install command and thus possibility to pre-create namespace (#289788)

## 1.0.2 - 2024-09-13 {#102-2024-09-13}

### Contents {#contents_5}

- Operator 1.0.1

- Core WAAP 1.1.8

### Changed {#changed_1}

- Improve CRD handling (#289760)

- Change misspelled variable name `operator.resources.request` to `operator.resources.requests` in `values.yaml` and variable usage in `operator-deployment.yaml` (#289751)

## 1.0.1 - 2024-09-05 {#101-2024-09-05}

### Contents {#contents_6}

- Operator 1.0.0

- Core WAAP 1.1.8

## 1.0.0 - 2024-09-05 {#100-2024-09-05}

### Contents {#contents_7}

- Operator 1.0.0

- Core WAAP 1.1.8

## 0.10.0 - 2024-08-05 {#0100-2024-08-05}

### Changed {#changed_2}

- Purely internal test release.

## 0.9.0 - 2024-07-30 {#090-2024-07-30}

### Added {#added_2}

- Initial release of Helm chart independently of operator release.

- Helm chart releases now available on Azure Helm chart repository.

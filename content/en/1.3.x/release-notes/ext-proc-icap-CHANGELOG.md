---
title: 'extProc ICAP Changelog'
linkTitle: 'extProc ICAP'
weight: 40
---
# Changelog {#changelog}

Breaking changes/additions may require to adapt existing configurations when updating, see [Migration Guide](../operation/upgrade.md).

## 1.0.0 - 2025-07-02 {#100-2025-07-02}

### Added {#added}

- Allow to increase the gRPC maxium receive message size via an additional command line option

## 0.0.11 - 2025-05-21 {#0011-2025-05-21}

### Added {#added_1}

- Provide basic metrics (processed requests, blocked requests)

## 0.0.10 - 2025-02-07 {#0010-2025-02-07}

### Fixed {#fixed}

- Fix wrong behavior in case of a non-200 status code in encapsulated HTTP response messages

## 0.0.9 - 2025-01-14 {#009-2025-01-14}

### Fixed {#fixed_1}

- Update 3rd party libs to close known vulnerabilities

## 0.0.8 - 2024-12-11 {#008-2024-12-11}

### Fixed {#fixed_2}

- Allow to set additional command line options view CLI_ARGS environment variable

## 0.0.7 - 2024-11-26 {#007-2024-11-26}

### Fixed {#fixed_3}

- Fix an issue on sending end-chunk terminator in preview mode

## 0.0.6 - 2024-11-19 {#006-2024-11-19}

### Changed {#changed}

- First alpha release

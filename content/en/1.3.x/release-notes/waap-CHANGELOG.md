---
title: 'Core WAAP Changelog'
linkTitle: 'Core WAAP'
weight: 30
aliases:
  - '../waap-CHANGELOG/'
---
# Changelog {#changelog}

Breaking changes/additions may require to adapt existing configurations when updating, see [Migration Guide](../operation/upgrade.md).

## 1.3.0 - 2025-07-10 {#130-2025-07-10}

### Contents {#contents}

- base image: alpine-3.21

- envoy version: 1.34.1

- coraza version: 3.3.3

- coreruleset version: 4.14

- coraza-envoy-go-filter version: 0.0.2

- core-waap header filter version: 1.0.2

### Added {#added}

- Provide golang filter support

- Integrate coraza-waf golang filter plugin

- Allow to set additional command line arguments for envoy via environment variable

### Changed {#changed}

- Update CRS to version 4.14.0

- Update envoy to version 1.34.1

- Update base image to alpine-3.21

- Update coraza to version 3.3.3

### Fixed {#fixed}

- Fix issue in external processing when receiving too large payloads in buffered mode

### Known Issues {#known-issues}

- A bug in Coraza results in a wrong HTTP status code returned, if `SecResponseBodyLimit` is reached and `SecResponseBodyLimitAction` is set to `Reject`. Coraza incorrectly returns HTTP 413 instead of HTTP 500. ([corazawaf/coraza#1377](https://github.com/corazawaf/coraza/issues/1377))

## 1.2.0 - 2025-01-16 {#120-2025-01-16}

### Changed {#changed_1}

- Update Envoy to version v1.32.3

- Allow to set concurrency level and log levels of Envoy using container environment variables.

## 1.1.9 - 2024-10-14 {#119-2024-10-14}

### Changed {#changed_2}

- Update Envoy to version v1.31.2

## 1.1.8 - 2024-09-05 {#118-2024-09-05}

### Added {#added_1}

- Enable the Unified Header Validator (UHV) in envoy.

## 1.1.7 - 2024-08-29 {#117-2024-08-29}

### Changed {#changed_3}

- Lua header filter: Add common WebSocket headers to the STANDARD allow class as well as to the default response headers.

## 1.1.6 - 2024-08-06 {#116-2024-08-06}

### Changed {#changed_4}

- Update CRS to version v4.3.0

- Update OS image to alpine-3.20

- Update Envoy to version v1.31.0

### Added {#added_2}

- Allow to set the general/component log level using environmet variables

- Add Lua header filter

## 1.1.5 - 2024-04-26 {#115-2024-04-26}

### Changed {#changed_5}

- Update Envoy to version v1.30.1

## 1.1.4 - 2024-04-17 {#114-2024-04-17}

### Fixed {#fixed_1}

- Fix format of version information file /etc/usp-core-waap-release

## 1.1.3 - 2024-04-17 {#113-2024-04-17}

### Changed {#changed_6}

- Update OS image to alpine-3.19

- Update Envoy to version v1.30.0

## 1.1.1 - 2024-02-29 {#111-2024-02-29}

### Changed {#changed_7}

- Update Envoy to version v1.29.1

### Added {#added_3}

- Add version information file /etc/usp-core-waap-release

## 1.1.0 - 2024-02-01 {#110-2024-02-01}

### Added {#added_4}

- Implement common changelog format ([#266949](https://redmine.u-s-p.local/issues/266949))

- Implement Core WAAP naming convention ([#258353](https://redmine.u-s-p.local/issues/258353))

## 1.0.6 - 2024-01-18 {#106-2024-01-18}

### Changed {#changed_8}

- Update Envoy to version v1.29.0

- Update Coraza Proxy WASM to version 0.0.5

## 1.0.5 - 2023-12-18 {#105-2023-12-18}

### Changed {#changed_9}

- Align JSON field names of Envoy access log and Coraza error log

### Added {#added_5}

- Support x-request-id in USP specific log format in Coraza

## 1.0.4 - 2023-12-05 {#104-2023-12-05}

### Changed {#changed_10}

- Switch to OWASP core rule set

- Update OS image to alpine-3.18

### Added {#added_6}

- Add patch for Coraza WAF to allow USP specific SecAuditLogFormat

## 1.0.3 - 2024-11-17 {#103-2024-11-17}

### Fixed {#fixed_2}

- Fix broken image with CRS 4.0.0-rc2_p1

## 1.0.2 - 2023-11-07 {#102-2023-11-07}

### Changed {#changed_11}

- Use CRS 4.0.0-rc2

## 1.0.1 - 2023-11-15 {#101-2023-11-15}

### Changed {#changed_12}

- Update envoy to 1-29-dev

## 1.0.0 - 2023-11-02 {#100-2023-11-02}

*First release.*

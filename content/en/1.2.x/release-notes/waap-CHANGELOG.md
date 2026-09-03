---
title: 'Core WAAP Changelog'
linkTitle: 'Core WAAP'
weight: 30
---
# Changelog {#changelog}

## 1.2.0 - 2025-01-16 {#120-2025-01-16}

### Changed {#changed}

- Update Envoy to version v1.32.3

- Allow to set concurrency level and log levels of Envoy using container environment variables.

## 1.1.9 - 2024-10-14 {#119-2024-10-14}

### Changed {#changed_1}

- Update Envoy to version v1.31.2

## 1.1.8 - 2024-09-05 {#118-2024-09-05}

### Added {#added}

- Enable the Unified Header Validator (UHV) in envoy.

## 1.1.7 - 2024-08-29 {#117-2024-08-29}

### Changed {#changed_2}

- Lua header filter: Add common WebSocket headers to the STANDARD allow class as well as to the default response headers.

## 1.1.6 - 2024-08-06 {#116-2024-08-06}

### Changed {#changed_3}

- Update CRS to version v4.3.0

- Update OS image to alpine-3.20

- Update Envoy to version v1.31.0

### Added {#added_1}

- Allow to set the general/component log level using environmet variables

- Add Lua header filter

## 1.1.5 - 2024-04-26 {#115-2024-04-26}

### Changed {#changed_4}

- Update Envoy to version v1.30.1

## 1.1.4 - 2024-04-17 {#114-2024-04-17}

### Fixed {#fixed}

- Fix format of version information file /etc/usp-core-waap-release

## 1.1.3 - 2024-04-17 {#113-2024-04-17}

### Changed {#changed_5}

- Update OS image to alpine-3.19

- Update Envoy to version v1.30.0

## 1.1.1 - 2024-02-29 {#111-2024-02-29}

### Changed {#changed_6}

- Update Envoy to version v1.29.1

### Added {#added_2}

- Add version information file /etc/usp-core-waap-release

## 1.1.0 - 2024-02-01 {#110-2024-02-01}

### Added {#added_3}

- Implement common changelog format (#266949(https://redmine.u-s-p.local/issues/266949))

- Implement Core WAAP naming convention (#258353(https://redmine.u-s-p.local/issues/258353))

## 1.0.6 - 2024-01-18 {#106-2024-01-18}

### Changed {#changed_7}

- Update Envoy to version v1.29.0

- Update Coraza Proxy WASM to version 0.0.5

## 1.0.5 - 2023-12-18 {#105-2023-12-18}

### Changed {#changed_8}

- Align JSON field names of Envoy access log and Coraza error log

### Added {#added_4}

- Support x-request-id in USP specific log format in Coraza

## 1.0.4 - 2023-12-05 {#104-2023-12-05}

### Changed {#changed_9}

- Switch to OWASP core rule set

- Update OS image to alpine-3.18

### Added {#added_5}

- Add patch for Coraza WAF to allow USP specific SecAuditLogFormat

## 1.0.3 - 2024-11-17 {#103-2024-11-17}

### Fixed {#fixed_1}

- Fix broken image with CRS 4.0.0-rc2_p1

## 1.0.2 - 2023-11-07 {#102-2023-11-07}

### Changed {#changed_10}

- Use CRS 4.0.0-rc2

## 1.0.1 - 2023-11-15 {#101-2023-11-15}

### Changed {#changed_11}

- Update envoy to 1-29-dev

## 1.0.0 - 2023-11-02 {#100-2023-11-02}

*First release.*

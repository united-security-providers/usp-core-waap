# Changelog

Breaking changes/additions may require to adapt existing configurations when updating, see [Migration Guide](upgrade.md).

## [2.0.0] - 2025-XX-XX

_The docker image has been renamed to **usp-core-waap-proxy** in this release._

### Contents
- base image: gcr.io/distroless/cc-debian13
- envoy version: 1.37.0
- coraza version: 3.3.3
- coreruleset version: 4.18.0
- coraza-envoy-go-filter version: 1.1.1
- core-waap header filter version: 1.0.2
- core-waap openapi filter version: X.X.X
- core-waap icap av filter version: X.X.X

### Changed
- Improve image security by migrating the base image from alpine to distroless

### Added
- Integrate DoS prevention golang filter
- Integrate ICAP AV golang filter
- Integrate OpenAPI validation golang filter
- Introduce a debug image with a debug build of envoy

### OpenAPI Validation

#### Added
- Supports OpenAPI 3.0 now

#### Changed
- Migrate to Go filter

### DOS Prevention

#### Added
- Simplified configuration
- New super duper feature enabled


## 1.4.1 - 2025-10-22
### Contents
- base image: alpine-3.21
- envoy version: 1.35.6
- coraza version: 3.3.3
- coreruleset version: 4.18.0
- coraza-envoy-go-filter version: 1.1.1
- core-waap header filter version: 1.0.2

## 1.4.0 - 2025-10-08
### Contents
- base image: alpine-3.21
- envoy version: 1.35.3
- coraza version: 3.3.3
- coreruleset version: 4.18.0
- coraza-envoy-go-filter version: 1.1.1
- core-waap header filter version: 1.0.2

### Changed
- Update envoy to version 1.35.3
- Update CRS to version 4.18.0
- Update coraza-envoy-go-filter to version 1.1.1

## 1.3.0 - 2025-07-10
### Contents
- base image: alpine-3.21
- envoy version: 1.34.1
- coraza version: 3.3.3
- coreruleset version: 4.14
- coraza-envoy-go-filter version: 0.0.2
- core-waap header filter version: 1.0.2

### Added
- Provide golang filter support
- Integrate coraza-waf golang filter plugin
- Allow to set additional command line arguments for envoy via environment variable

### Changed
- Update CRS to version 4.14.0
- Update envoy to version 1.34.1
- Update base image to alpine-3.21
- Update coraza to version 3.3.3

### Fixed
- Fix issue in external processing when receiving too large payloads in buffered mode

### Known Issues
- A bug in Coraza results in a wrong HTTP status code returned, if `SecResponseBodyLimit` is reached and `SecResponseBodyLimitAction` is set to `Reject`. Coraza incorrectly returns HTTP 413 instead of HTTP 500. ([corazawaf/coraza#1377](https://github.com/corazawaf/coraza/issues/1377))

## 1.2.0 - 2025-01-16
### Changed
- Update Envoy to version v1.32.3
- Allow to set concurrency level and log levels of Envoy using container environment variables.

## 1.1.9 - 2024-10-14
### Changed
- Update Envoy to version v1.31.2

## 1.1.8 - 2024-09-05
### Added
- Enable the Unified Header Validator (UHV) in envoy.

## 1.1.7 - 2024-08-29
### Changed
- Lua header filter: Add common WebSocket headers to the STANDARD allow class as well as to the default response headers.

## 1.1.6 - 2024-08-06
### Changed
- Update CRS to version v4.3.0
- Update OS image to alpine-3.20
- Update Envoy to version v1.31.0

### Added
- Allow to set the general/component log level using environmet variables
- Add Lua header filter

## 1.1.5 - 2024-04-26
### Changed
- Update Envoy to version v1.30.1

## 1.1.4 - 2024-04-17
### Fixed
- Fix format of version information file /etc/usp-core-waap-release

## 1.1.3 - 2024-04-17
### Changed
- Update OS image to alpine-3.19
- Update Envoy to version v1.30.0

## 1.1.1 - 2024-02-29
### Changed
- Update Envoy to version v1.29.1

### Added
- Add version information file /etc/usp-core-waap-release

## 1.1.0 - 2024-02-01
### Added
- Implement common changelog format ([#266949](https://redmine.u-s-p.local/issues/266949))
- Implement Core WAAP naming convention ([#258353](https://redmine.u-s-p.local/issues/258353))

## 1.0.6 - 2024-01-18
### Changed
- Update Envoy to version v1.29.0
- Update Coraza Proxy WASM to version 0.0.5

## 1.0.5 - 2023-12-18
### Changed
- Align JSON field names of Envoy access log and Coraza error log

### Added
- Support x-request-id in USP specific log format in Coraza

## 1.0.4 - 2023-12-05
### Changed
- Switch to OWASP core rule set
- Update OS image to alpine-3.18

### Added
- Add patch for Coraza WAF to allow USP specific SecAuditLogFormat

## 1.0.3 - 2024-11-17
### Fixed
- Fix broken image with CRS 4.0.0-rc2_p1

## 1.0.2 - 2023-11-07
### Changed
- Use CRS 4.0.0-rc2

## 1.0.1 - 2023-11-15
### Changed
- Update envoy to 1-29-dev

## 1.0.0 - 2023-11-02
_First release._






















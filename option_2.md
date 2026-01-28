# Changelog

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

## [1.4.1] - 2025-10-22
### Contents

base image: alpine-3.21
envoy version: 1.35.6
coraza version: 3.3.3
coreruleset version: 4.18.0
coraza-envoy-go-filter version: 1.1.1
core-waap header filter version: 1.0.2

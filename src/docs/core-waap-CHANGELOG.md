# Changelog

## [2.0.0] - 2025-MM-DD

### Contents
- base image: gcr.io/distroless/cc-debian13
- envoy version: 1.37.0
- helm chart version: 2.0.0 
- operator version: 2.0.0
  - Envoy config 1.37.0, 
  - CRS 4.18.0
- coraza version: 3.3.3
- coreruleset version: 4.18.0
- coraza filter version: 1.2.1
- header filter version: 1.0.2
- openapi filter version: 1.0.0
- icap av filter version: 2.0.0
- DoS prevention filter version: 1.0.0

## New features and improvements

Newly added capabilities/functionality or enhancements to existing features, such as better performance, usability, stability, or efficiency.

- Improve image security by migrating the base image from alpine to distroless
- Use envoy binary as entrypoint instead of hot-restarter python script as entrypoint and use envoy binary directly.
- Replaced external filters (Coraza, DoS, ICAP AV, OpenAPI, headers) with internal Go filters to reduce memory footprint and improve performance.
- **helmchart**: Reduced permissions for the default `ClusterRole` used by the operator to enhance security and align
  with the principle of least privilege.
- **helmchart**: Add the ability to configure `securityContext` for the operator.
- **operator**: Add the ability to configure `securityContext` for all containers through
  the operator's YAML configuration file.
- **operator**: Add rate limiting feature for repeat offenders,
  see `spec.operation.rateLimiting.repeatOffender`
- **operator**: Add support for Core WAAP debug image
- **operator**: Add support for disabling performance optimizations for coraza
- **openapi**: Added support for OpenAPI 3.2 and OpenAPI Overlays 1.1.0
- **header_filter**: Add new configuration option `denyPatternsResponse` to filter response headers based on regular expressions.
- **header_filter**: Add support for per-route filter configuration
- **header_filter**: Add option to explicitly deny headers for requests / responses
- **header_filter**: Add option to deny header values by pattern for responses
- **header_filter**: Make global header filter optional (default is off)
- **dos_prevention**: First release
- **coraza**: Improve performance when dealing with larger HTTP bodies
- **coraza**: Update go to version 1.25.7


## Bug fixes

Changes expected to improve the state of the world and are unlikely to have negative effects.

- **header_filter**: Fix typo in default response header class


## Incompatible behavior changes

Changes that are expected to cause an incompatibility if applicable; deployment changes are likely required.

- _The Core-WAAP docker image has been renamed to **usp-core-waap-proxy** in this release._
- **helmchart**: The docker image has been renamed to **usp-core-waap-proxy**.
- **helmchart**: Removed all traffic processing related settings.
- **helmchart**: Removed all metrics related settings.
- **operator**: Removed legacy CRS settings under `spec.crs`;
  use the newer `spec.coraza.crs` settings instead
- **operator**: ICAP and OpenAPI validations have been improved:
  No longer need to create sidecar containers and accordingly configuration
  has been simplified, performance and memory footprint have been improved,
  see the [Core WAAP Migration Guide](https://docs.united-security-providers.ch/usp-core-waap/2.0.x/upgrade/) for details
- **operator**: Improved and extended header filtering, now also configurable per route.
  See the new settings under `spec.headerFilter` and per-route references at `spec.routes[].headerFilterRef`.
  Please consult the documentation for details on filter operation and merge behavior.
- **operator**: The type of `spec.operation.startup.additionalCliArgs` changed from `string` to `[]string`
- **operator**: The envoy admin interface now binds to localhost (127.0.0.1) by default.
  It will only bind to 0.0.0.0 when explicitly enabled.
- **operator**: Removed metrics sidecar and all related settings; all metrics are now handled in the main container.


## Minor behavior changes

Changes that may cause incompatibilities for some users, but should not for most.

- ...


## Deprecated

Typically marked for removal in a future release. Customers are advised to migrate to a newer alternative.

- ...

## Removed config or runtime

Normally occurs at the end of the deprecation period.

- ...

## Known Issues

- **coraza**: A bug in Coraza results in a wrong HTTP status code returned, if `SecResponseBodyLimit` is reached and 
`SecResponseBodyLimitAction` is set to `Reject`. Coraza incorrectly returns HTTP 413 instead of HTTP 500.


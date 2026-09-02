---
title: 'Operator Changelog'
weight: 20
---
# Changelog {#changelog}

Breaking changes/additions may require to adapt existing configurations when updating.

## 1.1.0 - 2025-01-17 {#110-2025-01-17}

### Contents {#contents}

- Envoy config 1.32.3 CRS 4.3.0

- Core WAAP 1.2.0 (Envoy 1.32.3 CRS 4.3.0)

### Changed {#changed}

- Change `image` field of `waapSpecDefaults` to NOT include version anymore use new `version` field instead (while for backwards compatibility the old format is still supported but deprecated and will result in a warn log entry in the operator) (#289927)

- Access log logs `http.req_headers.fowarded_host` (`X-Forwarded-Host` header) instead of `http.req_headers.authority` because the `:authority` pseudo HTTP header already has a modified value when logged (#290369)

### Added {#added}

- Add traffic processing for ICAP antivirus checks via extProc to sidecar container and from there to external ICAP server (#289689)

- Add traffic processing for OpenAPI validation via extProc to sidecar container (#289845)

- Add setting `customRequestBlockingRules` to `crs` to be able to apply a virtual patch for zero-day vulnerability (#289563)

- Add startup parameters for Core WAAP Envoy under `operation.startup` (#290332)

- Add `version` field for `waapSpecDefaults` (#289927)

### Fixed {#fixed}

- Fix native config post-processing (NCPP) error messages in native operator image (#289848)

## 1.0.1 - 2024-09-13 {#101-2024-09-13}

### Contents {#contents_1}

- Spec library 1.0.1 (Envoy config 1.31.0 CRS 4.3.0)

- Core WAAP 1.1.8 (Envoy 1.31.0 CRS 4.3.0)

### Added {#added_1}

- Add setting `logOnly` (default `false`) to `headerFiltering` to allow to determine headers to allow more conveniently (#289744)

### Fixed {#fixed_1}

- Operator config default considered for expose admin interface or not (#289741)

## 1.0.0 - 2024-09-05 {#100-2024-09-05}

### Contents {#contents_2}

- Spec library 1.0.0 (Envoy config 1.31.0 CRS 4.3.0)

- Core WAAP 1.1.8 (Envoy 1.31.0 CRS 4.3.0)

### Changed {#changed_1}

- **Breaking**: Move almost all operator settings and annotations to Core WAAP spec under `operation` with default settings definable in the operator config map under `config.waapSpecDefaults` (#282449)

- Only a single operator config setting remains of the old settings: `watchedNamespaces` (list of watched namespaces optional default empty which means to watch all namespaces).

- No annotations remain.

- In the Core WAAP spec under `operation` as well as in the defaults in the operator config map under `config.waapSpecDefaults` there are also Kubernetes settings (`replicas` `resources` `tolerations` `priorityClassName` and `affinity`) see CRD for full detail.

- **NOTE**: Previous operator config for `resources` mistakenly used `request` (singular) instead of `requests` (plural) please correct when migrating settings.

- **Breaking**: CRS 4.3.0 (#288942)

- **Breaking**: Change various CRS defaults (#287832)

- Change `enabledRequestRules` and `enabledResponseRules` now enums instead of numbers

- Rename `requestBodyLimit` and `responseBodyLimit` to `requestBodyLimitKb` resp. `responseBodyLimitKb`

- `hostnames` setting optional defaults to `*` (#287832)

### Added {#added_2}

- **Breaking**: Add CSRF protection filter `csrfPolicy` active by default (#289461)

- **Breaking**: Add global HTTP header filtering `headerFiltering` active by default (#286882)

- **Breaking**: Add universal HTTP header validator (UHV) active by default (#289581)

- Add mappable custom error pages with dynamic content and static file resources `webResources` (#289442)

- Add settings to expose Envoy admin interface as Kubernetes service `operation.adminInterfaceServices` (#289346)

- Allow to skip CRS body scanning per location / HTTP methods `crs.requestBodyAccessExceptions` (#289373)

- Allow to disable the CRS engine per Core WAAP route `routesindex.crs` (#289373)

- Add Kubernetes scheduling properties (`replicas` `resources` `tolerations` `priorityClassName` and `affinity`) to `operation` as well as in the defaults in the operator config map under `config.waapSpecDefaults` see CRD for full detail (#282449)

### Fixed {#fixed_2}

- Operator properly compares actual & desired values of cpu & memory resource requests to avoid endless reconcile loop (#289318).

- CRS autolearning removes the query part of the location and URL-decodes the location (#289357)

- CRS settings `requestBodyLimit` and `responseBodyLimit` are now interpreted as kb as documented no longer as bytes (plus renamed to `requestBodyLimitKb` and `responseBodyLimitKb` for clarity) (#287832)

- If allowed methods are specified and a request comes in with a method that is not allowed no longer responds with 404 (Not Found) but with a 405 (Method not allowed) (#256147)

- Fix bug with authentication with public superlocations (#289691)

## 0.10.1 - 2024-08-05 {#0101-2024-08-05}

### Contents {#contents_3}

- Spec library 0.8.1 (Envoy config 1.31.0 CRS 4.3.0)

- Core WAAP 1.1.6 (Envoy 1.31.0 CRS 4.3.0)

## 0.10.0 - 2024-08-05 {#0100-2024-08-05}

### Contents {#contents_4}

- Spec library 0.8.0 (Envoy config 1.30.1 CRS 4.3.0)

- Core WAAP 1.1.6 (Envoy 1.31.0 CRS 4.3.0)

### Changed {#changed_2}

- Fixed spec lib version for internal release.

## 0.8.0 - 2024-05-23 {#080-2024-05-23}

### Contents {#contents_5}

- Core WAAP 1.1.5 (Envoy 1.30.1)

- Spec library 0.7.0 (Envoy config 1.30.1 CRS 4.0.0-RC2)

- Helm Charts 0.8.0

### Changed {#changed_3}

- Publish to `uspregistry.azurecr.io/usp/core/waap/usp-core-waap-operator` no longer to `quay.io/usp/usp-core-waap-operator` (#289345)

### Fixed {#fixed_3}

- Fix CRS in mode detect (#289258)

### Added {#added_3}

- JavaScripts for post-processing generated Envoy config (#289260)

## 0.7.0 - 2024-04-29 {#070-2024-04-29}

### Contents {#contents_6}

- Core WAAP 1.1.5 (Envoy 1.30.1)

- Spec library 0.6.0 (Envoy config 1.30.1 CRS 4.0.0-RC2)

- Helm Charts 0.7.4

### Changed {#changed_4}

- **Breaking**: Default upstream protocol HTTP/2 (previously HTTP/1.1) (#285763)

### Added {#added_4}

- Add "serviceAnnotations" config setting and corresponding "service-annotations" annotation (#285763)

- Add origin IP allow/deny (#286876)

- Add allowed HTTP methods per route (#256147)

- Add autoHostRewrite configurable (if true set X-Forwarded-Host header) (#287831 #288623)

- Add downstream automatic preference of HTTP/2; upstream HTTP/2 (default) HTTP/1.1 or automatic selection via ALPN (requires TLS) (#285763)

- Add features to CRS autolearn CLI (#288611)

### Fixed {#fixed_4}

- At JWT-only authentication forward JWT upstream if configured (#288135)

- Add missing CRS rules (#288611)

## 0.6.1 - 2024-03-28 {#061-2024-03-28}

### Contents {#contents_7}

- Core WAAP 1.1.2

- Spec library 0.5.0 (Envoy config 1.29.x)

### Fixed {#fixed_5}

- Missing version suffix (e.g. ":1.1.2") in the "envoy.image" configuration setting could lead to an invalid version

    label in the generated ConfigMap object leading to a failed deployment. Now the version will fall back to "latest"

    if no version is specified for the image.

## 0.6.0 - 2024-03-25 {#060-2024-03-25}

### Contents {#contents_8}

- Core WAAP 1.1.2

- Spec library 0.5.0 (Envoy config 1.29.x)

### Changed {#changed_5}

- **Breaking**: Use plural for lists in WAAP Spec (authentications audiences) (#285960)

- **Breaking:** Default for "replicas" is no longer 1 but to not set it so that an HPA (Horizontal Pod Autoscaler) can manage it (#282428)

- **Breaking:** The name in the operator CR (custom resource) is ignored as well as the corresponding annotation instead uses the metadata name of the resource "CoreWaapService" (the Core WAAP CR) as name for Pods Service ReplicaSets etc. (#284588)

- **Breaking**: Replace authentication tokenEndpointAuthType QUERY with BODY (#285777)

- Improve validation of WAAP Spec and more info in generated CRD (#282608)

### Added {#added_5}

- Add header match for routes (#285016)

- Add authentication useRefreshToken flag (#285777)

- Allow plain http jwksEndpoint in JWT-auth-only use case (#285962)

### Fixed {#fixed_6}

- Support multiple instances in same namespace (#284588)

## 0.5.0 - 2024-03-05 {#050-2024-03-05}

### Contents {#contents_9}

- Core WAAP 1.1.0

- Spec library 0.4.0 (Envoy config 1.29.x)

### Changed {#changed_6}

- **Breaking:** If `caCertificatesConfigMapName` is set also `caCertificateKeyInConfigMap` must be set (or corresponding annotations) (#282762)

### Added {#added_6}

- Set service account name and whether to automount token (#282286)

### Fixed {#fixed_7}

- Mounted CA certificates always under `/etc/ssl/certs/ca-certificates.crt` (#282762)

## 0.4.1 - 2024-02-27 {#041-2024-02-27}

### Contents {#contents_10}

- Core WAAP 1.1.0

- Spec library 0.3.0 (Envoy config 1.29.x)

### Fixed {#fixed_8}

- Fixed build problem.

## 0.4.0 - 2024-02-26 {#040-2024-02-26}

### Contents {#contents_11}

- Core WAAP 1.1.0

- Spec library 0.2.2

### Added {#added_7}

- TLS support for upstream backends.

## 0.3.0 - 2024-02-23 {#030-2024-02-23}

### Contents {#contents_12}

- Core WAAP 1.1.0

- Spec library 0.2.

### Changed {#changed_7}

- **Breaking:** The "podName" operator setting has been renamed to just "name". The custom annotation to override 

    this setting has been adapted accordingly from "core.waap.u-s-p.ch/pod-name" to "core.waap.u-s-p.ch/name".

### Added {#added_8}

- New operator setting "envoy/labels" (or annotation "core.waap.u-s-p.ch/labels") allows to define one or multiple

    custom labels for the Envoy pods.

### Fixed {#fixed_9}

- The "name" operator configuration setting (formerly "podName") is now also properly used for the name of the "Service"

    and the "ConfigMap" objects of the Core WAAP deployment. This allows to have multiple Core WAAP deployments within the same

    application namespace.

## 0.2.0 - 2024-02-12 {#020-2024-02-12}

### Contents {#contents_13}

- Core WAAP 1.1.0

- Spec library 0.2.0

### Changed {#changed_8}

- **Breaking:** Renamed everything to "core-waap-operator".

## 0.1.1 - 2024-01-25 {#011-2024-01-25}

### Contents {#contents_14}

- Core WAAP 1.0.6

- Spec library 0.0.8

### Added {#added_9}

- Added Envoy configuration for custom CA certificates.

## 0.1.0 - 2024-01-18 {#010-2024-01-18}

### Contents {#contents_15}

- Core WAAP 1.0.6

- Spec library 0.0.7

### Added {#added_10}

- Added configuration option and annotation for custom CA truststore.

## 0.0.9 - 2024-01-11 {#009-2024-01-11}

### Changed {#changed_9}

- Updated CRD (obsolete status fields replaced with single message).

### Added {#added_11}

- Added configuration option and annotation for number of replicas.

- Added support for mounting secrets for OIDC authentication.

## 0.0.8 - 2024-01-03 {#008-2024-01-03}

### Fixed {#fixed_10}

- Fixed invalid resource format handling

## 0.0.7 - 2024-12-19 {#007-2024-12-19}

### Fixed {#fixed_11}

- Fixed invalid CR annotation name for image override

## 0.0.6 - 2024-12-16 {#006-2024-12-16}

### Fixed {#fixed_12}

- Fixed copy-paste error with "limits" resources.

## 0.0.5 {#005}

### Added {#added_12}

- Operator config map template with resources

- Operator config support for envoy resources (cpu memory)

- Operator config support for envoy pod name

- Envoy log format supports auto-learning CLI tool.

## 0.0.4 {#004}

- Internal testing release.

## 0.0.3 {#003}

- First usable native build.

- Uses Envoy 1.29 (no hot reload for normal config changes)

## 0.0.2 {#002}

- Minor extensions.

## 0.0.1 {#001}

- Experimental release for Envoy 1.28.

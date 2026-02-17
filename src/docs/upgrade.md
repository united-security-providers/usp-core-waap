# Updating Core WAAP Operator

To run a newer version of the Core WAAP Operator the corresponding helm chart can be used. Please check in the release notes what has changed and which settings may affect your deployed CoreWaapServices. In case of breaking changes, it is recommended to follow these instructions:

1. Stop the Core WAAP Operator by scaling the deployment down to 0 replicas (i.e. `kubectl scale deployment --replicas 0 -l app.kubernetes.io/name=core-waap-operator -n <operator-namespace>`).
1. Manually update the CRD (see [upgrade operator](./helm.md#upgrade-operator)).
1. Align the CoreWaapServices with the new schema according to the breaking changes in the release notes.
1. Update the Core WAAP Operator by upgrading the helm chart (ensure the CoreWaapService CustomResourceDefinition was updated, see [upgrade operator](./helm.md#upgrade-operator)).
1. Check the Core WAAP Operator Logs, to ensure that no error due to incompatibility occurs. Fix the remaining issues in the CoreWaapServices Custom Resources if required.

**Note:** This procedure should prevent any downtime of a CoreWaapService. In case a new Core WAAP Version is included too, the pods will restart accordingly. **Upgrade from helm chart versions < 1.0.2 will have an increased risk by helm upgrade commands to remove the CRD** (and by this any custom resource) in case the upgrade command fails (due to any not core-waap specific reason like not enough resources to start a POD etc)

## Core WAAP Migration Guide

### Core WAAP Operator 1.4.x to >=2.0.0

- TODO other migrations...
- **OpenAPI Validation**<br/>
  Migration is easy. The settings stay the same, but `trafficProcessing` is no longer needed.
  External processing related settings (operation, extProc) are no longer needed/available.
  Example old configuration:
  ```yaml
  spec:
    trafficProcessing:
      openapi:
        - name: "openapi-pets-v3"
          config:
            schemaSource:
              configMap: test-data
              key: pet_store_v3.json
            scope:
              requestBody: true
              responseBody: true
  ```
  it used to be referenced via `trafficProcessingRefs` on route level:
  ```yaml
  spec:
    routes:
      - match:
          path: /
          pathType: PREFIX
        trafficProcessingRefs:
        - "openapi-pets-v3"
        backend:
          address: backend
          port: 4433
  ```
  Corresponding migrated config:
  ```yaml
  spec:
    openapi:
      - name: "openapi-pets-v3"
        schemaSource:
          configMap: test-data
          key: pet_store_v3.json
        scope:
          requestBody: true
          responseBody: true
  ```
  and new reference via `openapiRefs`:
  ```yaml
  spec:
    routes:
      - match:
          path: /
          pathType: PREFIX
        openapiRefs:
          - "openapi-pets-v3"
        backend:
          address: backend
          port: 4433
  ```
- **ICAP Antivirus (AV) Scanning**<br/>
  Migration is easy. The settings stay the same, but `trafficProcessing` is no longer needed.
  External processing related settings (operation, extProc) are no longer needed/available.
  Example old configuration:
  ```yaml
  spec:
    trafficProcessing:
      icap:
        - name: "icap-trendmicro"
          operation: ...
          extProc: ...
          config:
            url: "icap://some.host:1344/some/path"
  ```
  it used to be referenced via `trafficProcessingRefs` on route level:
  ```yaml
  spec:
    routes:
      - match:
          path: /
          pathType: PREFIX
        trafficProcessingRefs:
        - "icap-trendmicro"
        backend:
          address: backend
          port: 4433
  ```
  Corresponding migrated config:
  ```yaml
  spec:
    icap:
      - name: "icap-trendmicro"
        url: "icap://some.host:1344/some/path"
  ```
  and new reference via `icapRefs`:
  ```yaml
  spec:
    routes:
      - match:
          path: /
          pathType: PREFIX
        icapRefs:
          - "icap-trendmicro"
        backend:
          address: backend
          port: 4433
  ```
- **Header filtering**<br/>
  Migration is quite straightforward, only tiny changes,
  except that value patterns have to be converted from Lua patterns
  to Regular Expression (regex) patterns.<br/>
  Example old config:<br/>
  ```yaml
  spec:
    headerFiltering:
      logOnly: false
      request:
        enabled: true
        allowClass: STANDARD
        allow:
        - X-Header-1
        - X-Header-2
        deny:
        - Content-Md5
        - name: X-Evil
          valuePattern: "^evil%d+$" # NOTE: Lua pattern
      response:
        enabled: true
        allow:
        - X-Header-1
        - X-Header-2
        deny:
        - X-Evil
  ```
  Corresponding migrated config:<br/>
  ```yaml
  spec:
  headerFilter:
    defaultFilterRef: "default"
    filters:
    - name: "default" # NOTE: name can be freely chosen, but ref above must match
      logOnly: false
      request:
        enabled: true
        allowClass: STANDARD
        allow:
        - X-Header-1
        - X-Header-2
        deny:
        - Content-Md5
        denyPatterns:
        - name: X-Evil
          pattern: "^evil\\d+$" # NOTE: converted to corresponding regex
      reponse:
        enabled: true
        allow:
        - X-Header-1
        - X-Header-2
        deny:
        - X-Evil
  ```
  Note that the new implementation has additional features,
  esp. header filtering can now also be adjusted on route level,
  see [Header filtering](header-filtering.md).

### Core WAAP Operator 1.3.x to >=1.4.0

- The field `spec.operation.startup.additionalCliArgs` has changed from a single `string` to `[]string`.
  To migrate existing configurations, split the `string` into individual arguments and specify them in a an array.
  Example: `additionalCliArgs: "--service-cluster cluster-name --base-id-path 5 --log-format-escaped"`
  becomes `additionalCliArgs: ["--service-cluster", "cluster-name", "--base-id-path", "5", "--log-format-escaped"]`

### Core WAAP Operator 1.2.0 to >=1.3.0

- The CRS version has been upgraded from 4.14.0 to 4.17.1.
  Accordingly, testing / auto-learning esp. for false positives is recommended.
- Optional but recommended:
  The `spec.crs` settings are now marked as deprecated (resulting also in a warn log entry if still used);
  they are still fully supported, but should be migrated to the new `spec.coraza` settings as soon as possible,
  because upcoming minor releases might no longer support them.

### Core WAAP Operator 1.1.0 to >=1.2.0

- The CRS version has been upgraded from 4.3.0 to 4.14.0.
  Accordingly, testing / auto-learning esp. for false positives is recommended.
- In the Helm chart, legacy "image:version" in the `image` field is now disallowed,
  because it would silently override a separately defined `version` field:
  Use separate `image` and `version` fields instead.
- Optional: Use the list of rule ids in CRS rule exception, new field `ruleIds`,
  instead of the now deprecated field `ruleId` for a single rule id.

### Core WAAP Operator 1.0.0 to >=1.1.0

There are no mandatory migrations, but it is recommended to migrate the following deprecated settings, also in order to avoid deprecation warnings in the operator log:

- Split up the `config.operation.image` field in the form "{image}:{version}" into `config.operation.image` without the version and the version separately in the new field `config.operation.version`.

### Core WAAP Operator 0.8.0 to >=1.0.0

#### Operation-related settings

The following kinds of settings have been regularized:

- Instead of using annotations, use settings in the CoreWaapService CR under `spec.operation`.<br>
  **Note:** This means that all Core WAAP annotations have to be removed during migration.
- The exact same settings can also be provided as defaults in the operator helm chart under `config.waapSpecDefaults`, replacing a number of previous operator settings.<br>
  **Note:** All previous settings in the operator helm chart have to be moved to the new structure, even the ones that have no equivalent under `spec.operation`; best use the provided new helm chart as a basis.

Generally, see the CoreWaapService CRD under `spec.operation` for all possible settings.

Migration setting-by-setting:

- operator `envoy.image` / annotation `image` => `*.image`<br>
  (where `*.image` stands for `spec.operation.image` in the CoreWaapService CR, plus default in the operator helm chart at `config.waapSpecDefaults.image`, and similary in the following lines)
- annotations `version` and `registry` => no longer supported, specify in `*.image`
- operator `envoy.labels` / annotation `labels` => `*.labels` (key/value)
- operator `serviceAnnotations` / annotation `service-annotations` => `*.serviceAnnotations` (key/value)
- operator `envoy.servicePort` and `envoy.listenerPort` / annotation `service-port` and `listener-port` => `*.port` (can no longer be set to different values, no use case)
- operator `envoy.serviceAdminPort` and `envoy.listenerAdminPort` / annotation `admin-service-port` and `admin-listener-port` => `*.adminInterfaceService.port` (can also no longer be set to different values, no use case)
- `envoy.replicas` / annotation `replicas` => `*.replicas`
- operator `envoy.resources.*` / annotations `request-cpu`, `request-memory`, `limits-cpu`, `limits-memory` => `*.respources` (standard Kubernetes format; note that `request` in the old settings was wrong, in Kubernetes is plural `requests`)
- operator `operator.caCertificatesConfigMapName` / annotation `custom-cacerts` => `*.caCertificates.configMap`
- operator `operator.caCertificateKeyInConfigMap` / annotation `custom-cacerts-key` => `*.caCertificates.key`

The setting `operator.watchedNamespaces` is now `config.watchedNamespaces`.

#### CRS rules are now enums

- CRS request and response rules are no longer integers but enums, see the CRD for values.
- **Note**: Because the default for request rules has changed to all activated by default, if you previously had listed all of them, there is need to list them now all as enum values, just omit the setting.

#### General

- The new security features `csrfPolicy` and `headerFiltering` are introduced and enabled by default. To ensure the upgrade runs smoothly in the sense that the new features do not block any request unintentionally, these features can be disabled first. After a successful upgrade, it is recommended to enable this features and add exceptions where required.
- The upgrade also includes a new OWASP Core Rule Set which may require configuration changes like adding rule exceptions to prevent false positive alerts. Therefore a new testing phase is recommended. For non productive/non public environments this can be done simplest with setting `crs.mode` to `DETECT` temporarily. For productive/public environments without previous testing stage it is recommended to keep the `crs.mode` to `BLOCK` and fix possible false positive blocks according to demand.

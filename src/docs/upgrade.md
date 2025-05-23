# Updating Core WAAP Operator

To run a newer version of the Core WAAP Operator the corresponding helm chart can be used. Please check in the release notes what has changed and which settings may affect your deployed CoreWaapServices. In case of breaking changes, it is recommended to follow these instructions:

1. Stop the Core WAAP Operator by scaling the deployment down to 0 replicas (i.e. `kubectl scale deployment --replicas 0 -l app.kubernetes.io/name=core-waap-operator -n <operator-namespace>`).
1. Manually update the CRD (see [upgrade operator](./helm.md#upgrade-operator)).
1. Align the CoreWaapServices with the new schema according to the breaking changes in the release notes.
1. Update the Core WAAP Operator by upgrading the helm chart (ensure the CoreWaapService CustomResourceDefinition was updated, see [upgrade operator](./helm.md#upgrade-operator)).
1. Check the Core WAAP Operator Logs, to ensure that no error due to incompatibility occurs. Fix the remaining issues in the CoreWaapServices Custom Resources if required.

**Note:** This procedure should prevent any downtime of a CoreWaapService. In case a new Core WAAP Version is included too, the pods will restart accordingly. **Upgrade from helm chart versions < 1.0.2 will have an increased risk by helm upgrade commands to remove the CRD** (and by this any custom resource) in case the upgrade command fails (due to any not core-waap specific reason like not enough resources to start a POD etc)

## Core WAAP Migration Guide

### Core WAAP Operator 1.1.0 to >=1.2.0

The CRS version has been upgraded from 4.3.0 to 4.14.0.
Accordingly, testing / auto-learning esp. for false positives is recommended.

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
# Updating Core WAAP Operator

To run a newer version of the Core WAAP Operator the corresponding helm chart can be used. Please check in the release notes what has changed and which settings may affect your deployed CoreWaapServices. In case of breaking changes, it is recommended to follow these instructions:

1. Stop the Core WAAP Operator by scaling the deployment down to 0 replicas.
2. Update the Core WAAP Operator by installing the new helm chart (ensure the CoreWaapService CustomResourceDefinition was updated.)
3. Align the CoreWaapServices with the new schema according to the breaking changes in the release notes.
4. Scale up the Core WAAP Operator deployment to 1 replica.
5. Check the Core WAAP Operator Logs, to ensure that no error due to incompatibility occurs. Fix the remaining issues in the CoreWaapServices Custom Resources if required.

**Note:** This procedure should prevent any downtime of a CoreWaapService. In case also a new Core WAAP Version is set, the pods will restart accordingly.

## Core WAAP Migration Guide

### Core WAAP Operator 0.8.0 to 1.0.0

#### Operation-related settings

The following kinds of settings have been regularized:

- Instead of using annotations, use settings in the CoreWaapService CR under `spec.operation`.<br>
  **Note:** This means that all Core WAAP annotations have to be removed during migration.
- The exact same settings can also be provided as defaults in the operator helm chart under `config.coreWaapDefaults`, replacing a number of previous operator settings.<br>
  **Note:** All previous settings in the operator helm chart have to be moved to the new structure, even the ones that have no equivalent under `spec.operation`; best use the provided new helm chart as a basis.

Generally, see the CoreWaapService CRD under `spec.operation` for all possible settings.

Migration setting-by-setting:

- operator `envoy.image` / annotation `image` => `*.image`<br>
  (where `*.image` stands for `spec.operation.image` in the CoreWaapService CR, plus default in the operator helm chart at `config.coreWaapDefaults.image`, and similary in the following lines)
- annotations `version` and `registry` => no longer supported, specify in `*.image`
- operator `envoy.labels` / annotation `labels` => `*.labels` (key/value)
- operator `serviceAnnotations` / annotation `service-annotations` => `*.serviceAnnotations` (key/value)
- operator `envoy.servicePort` and `envoy.listenerPort` / annotation `service-port` and `listener-port` => `*.port` (can no longer be set to different values, no use case)
- operator `envoy.serviceAdminPort` and `envoy.listenerAdminPort` / annotation `admin-service-port` and `admin-listener-port` => `*.adminInterfaceService.port` (can also no longer be set to different values, no use case)
- `envoy.replicas` / annotation `replicas` => `*.replicas`
- operator `envoy.resources.*` / annotations `request-cpu`, `request-memory`, `limits-cpu`, `limits-memory` => `*.respources` (standard Kubernetes format; note that `request` in the old settings was wrong, in Kubernetes is plural `requests`)
- operator `operator.caCertificatesConfigMapName` / annotation `custom-cacerts` => `*.caCertificates.configMap`
- operator `operator.caCertificateKeyInConfigMap` / annotation `custom-cacerts-key` => `*.caCertificates.key`

The setting `operator.watchedNamespaces` is now simply `watchedNamespaces`.

#### CRS rules are now enums
- ***TODO**
[//]: # (Notes: CRS Request Rules now enums, if previously are were enabled, setting can be omitted &#40;all request rules active by default&#41; [Todo])

-----------------------------------------

[//]: # (- All CoreWaapService CR annotations have to be removed. The settings are now applied within the CoreWaapService `spec.operation` or in the Core WAAP Operator configuration &#40;`values.yaml` of the Operator helm chart within `config.coreWaapDefaults`&#41;)
[//]: # (     - Annotation `core.waap.u-s-p.ch/custom-cacerts` has to be moved to `spec.operation.caCertificates.configMap`)
[//]: # (     - core.waap.u-s-p.ch/custom-cacerts-key custom-cacerts-key)

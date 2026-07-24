# OCI Image Sources

Some Core WAAP resources — the CRS rule set as well as OpenAPI and GraphQL
schemas — can be loaded from an **OCI image** instead of being bundled with the
proxy or provided through a `ConfigMap`. The referenced image is mounted as a
read-only volume into the Core WAAP deployment, and Core WAAP reads the rules or
schema from a path inside it.

This is useful to:

* ship and version CRS rules or API schemas as regular OCI artifacts through
  your CI/CD pipeline,
* update them independently of the Core WAAP release, and
* avoid the size limits of `ConfigMap` objects for larger schemas.

!!! note

    Loading resources from OCI images relies on Kubernetes
    [image volumes](https://kubernetes.io/docs/tasks/configure-pod-container/image-volumes/)
    and requires **Kubernetes 1.36 or newer**. The image must be pullable by the
    cluster; use image pull secrets as you would for any other image.

## Common settings

All OCI image sources share the following settings:

| Setting | Description |
|---------|-------------|
| `reference` | The OCI image reference, e.g. `registry.example.com/schemas/my-api:v1.0`. Required. |
| `pullPolicy` | Image pull policy for the OCI volume: `Always`, `Never` or `IfNotPresent`. Defaults to `IfNotPresent`. |
| `filePath` | Path to the file to read within the image, e.g. `schemas/petstore.yaml`. Required for OpenAPI and GraphQL schemas (not used for CRS rules). |

## CRS rules

Instead of the CRS rule set that is built into the proxy, you can point Core WAAP
at an OCI image containing a different (e.g. newer) CRS version. Configure it at
`spec.coraza.crs.crsOciImageSource`.

For CRS, no `filePath` is needed — the whole rule set is mounted from the image.
The CRS version is taken from the image reference's tag, so the reference
must end with a numeric version (e.g. `:4.27.0`). If no OCI image source is set,
the built-in CRS rules are used (currently version `4.25.0`).

## OpenAPI and GraphQL schemas

OpenAPI and GraphQL schemas can be provided either from a `ConfigMap`
(`schemaSource`) or from an OCI image (`ociImageSource`) — exactly one of the
two must be set per config.

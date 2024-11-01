# OpenAPI Validation

Core WAAP has an ability to validate incoming requests and outgoing responses against the [OpenAPI Specification schema](https://www.openapis.org/).

The OpenAPI Specification (OAS) defines a standard, programming language-agnostic interface description for HTTP APIs, which allows both humans and computers to discover and understand the capabilities of a service without requiring access to source code, additional documentation, or inspection of network traffic.

Currently supported levels of the specification are OpenAPI 3.0 and 3.1.

Currently supported formats of the specification are JSON and YAML.


## Configuration

OpenAPI validation is a part of the more general Traffic Processing of Core WAAP. As such, the configuration of schema and processing options is located in 'openapi' section of 'spec.trafficProcessing'.

```yaml
spec:
  trafficProcessing:
    openapi:
      - name: "openapi-petstore-v3" 
        operation: ...
        grpc: ...
        config: ...
```

Each configuration must have a 'name' that could be used to reference this particular configuration in a route configuration under 'trafficProcessingRefs'.

```yaml
spec:
  routes:
    - match:
        path: "/petstore" 
      trafficProcessingRefs:
        - "openapi-petstore-v3" 
```

The 'operation' section of the configuration contains settings that will be used for Kubernetes deployment of the OpenAPI validation sidecar.

```yaml
spec:
  trafficProcessing:
    openapi:
      - ...
        operation:
          image: "uspregistry.azurecr.io/usp/core/waap/usp-core-waap-grpc-openapi:1.0.0"
          version: 0.0.1
          resources:
            claims: ...
            limits: ...
            requests: ...
            additionalProperties: ...
```

This section is optional and might be used to make some resource-related adjustments to the default settings, if they are specified in the ['waapSpecTrafficProcessingDefaults.openapi'](helm-values.md) section of the operator's configuration.

The 'grpc' section contains gRPC-related settings used for communications to the OpenAPI sidecar.

```yaml
spec:
  trafficProcessing:
    openapi:
      - ... 
        grpc:
          messageTimeout: 30s
```

The 'config' section contains the actual validation configuration.


```yaml
spec:
  trafficProcessing:
    openapi:
      - ... 
        config:
          schemaSource:
            configMap: openapi-petstore-v3
            key: openapi-petstore-v3.json
          scope:
            requestBody: true
            responseBody: false
```

'schemaSource' section specifies a Kubernetes ConfigMap resource that contains the OAS schema that will be used for validation.

'scope' section allows to turn on or off the validation for request and/or response bodies. Request headers are always validated.

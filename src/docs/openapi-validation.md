# API Security

APIs are the backbone of today's digital economy, enabling seamless interaction and integration between different software systems. They support the development of new applications and services by allowing third-party developers to build on existing platforms. This fosters innovation and drives business growth by making data and functionality more accessible. In essence, APIs are crucial for efficiency, scalability, and staying competitive in a fast-paced, digital world.

Because APIs are like doorways between different software systems, they can potentially be exploited if not well-secured. Ensuring API security means safeguarding the data that flows through these connections. In today's interconnected world, a breach in one system could cascade into others. By securing APIs, businesses protect against data breaches, unauthorized access, and other cyber threats, forming a critical layer in a comprehensive defense strategy.

# OpenAPI Validation

Open API schema validation ensures that the API adheres to a predefined structure. This means it checks if the data being sent or received is in the correct format and follows the rules set out in the schema. It's like having a gatekeeper that only allows the right kind of data through. This reduces the risk of injecting harmful or invalid data, which could potentially exploit vulnerabilities or cause the system to behave unexpectedly. Validating API payload is a crucial element in security in depth for APIs. In essence, it helps to maintain the integrity and security of the API.

Core WAAP has an ability to validate incoming requests and outgoing responses against the [OpenAPI Specification schema](https://www.openapis.org/).

The OpenAPI Specification (OAS) defines a standard, programming language-agnostic interface description for HTTP APIs, which allows both humans and computers to discover and understand the capabilities of a service without requiring access to source code, additional documentation, or inspection of network traffic. Core WAAP OAS schema validation can be activated selectively for API requests and response. If a request/response is not compliant to the schema, the transaction is blocked with a status `400 Bad Request`.


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

# OpenAPI Validation

## API Security

APIs are the backbone of today's digital economy, enabling seamless interaction and integration between different software systems. They support the development of new applications and services by allowing third-party developers to build on existing platforms. This fosters innovation and drives business growth by making data and functionality more accessible. In essence, APIs are crucial for efficiency, scalability, and staying competitive in a fast-paced, digital world.

Because APIs are like doorways between different software systems, they can potentially be exploited if not well-secured. Ensuring API security means safeguarding the data that flows through these connections. In today's interconnected world, a breach in one system could cascade into others. By securing APIs, businesses protect against data breaches, unauthorized access, and other cyber threats, forming a critical layer in a comprehensive defense strategy.

## Open API Schema Validation

Open API schema validation ensures that the API adheres to a predefined structure. This means it checks if the data being sent or received is in the correct format and follows the rules set out in the schema. It's like having a gatekeeper that only allows the right kind of data through. This reduces the risk of injecting harmful or invalid data, which could potentially exploit vulnerabilities or cause the system to behave unexpectedly. Validating API payload is a crucial element in security in depth for APIs. In essence, it helps to maintain the integrity and security of the API.

Core WAAP has an ability to validate incoming requests and outgoing responses against the [OpenAPI Specification schema](https://www.openapis.org/).

The OpenAPI Specification (OAS) defines a standard, programming language-agnostic interface description for HTTP APIs, which allows both humans and computers to discover and understand the capabilities of a service without requiring access to source code, additional documentation, or inspection of network traffic. Core WAAP OAS schema validation can be activated selectively for API requests and response. If a request/response is not compliant to the schema, the transaction is blocked with a status `400 Bad Request`.

Currently supported levels of the specification are OpenAPI 3.0 and 3.1.

Currently supported formats of the specification are JSON and YAML.

## Configuration

```yaml
spec:
  openapi:
    - name: "openapi-petstore-v3"
      config: ...
```

### Exceptions

Sometimes, you may want certain subpaths of a route to skip OpenAPI validation.
For example when the OpenAPI specification has not yet been updated, or
you still need to support some deprecated endpoints temporarily.

To make such an exception you have to:

1. Duplicate the existing route configuration for the path you want to exempt
2. Remove the OpenAPI validation settings in that duplicate
3. Place the duplicate route before the original route (order matters)

Here is an example of how this could look like:

```yaml
spec:
  routes:
    # Match all requests that go through /path1 and /path2 (including subpaths)
    # and forward them to the backend
    - match:
        path: ^/(path1|path2)(?:\?.*)$
        pathType: REGEX
      backend:
        address: backend
        port: 4433
        protocol:
          selection: h1
    # Match all remaining requests, run the openapi validation and forward all
    # valid requests to the backend
    - match:
        path: /
        pathType: PREFIX
      openapiRefs:
        - backend-openapi
      backend:
        address: backend
        port: 4433
        protocol:
          selection: h1
```

See the [API reference](crd-doc.md#corewaapservicespecopenapiindex) for more information on how the config looks like.

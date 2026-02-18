# GraphQL Basic Usage

(This section assumes you have read the section [What is Coraza?](what-is-coraza.md))

* By default, GraphQL validation is not active on any route.
* GraphQL related settings are at `spec.coraza.graphql` and
  `spec.routes[].coraza.graphql`, plus general Coraza settings
  at `spec.coraza` and `spec.routes[].coraza`
  in the [API Reference](crd-doc.md#corewaapservicespeccoraza).
* To activate GraphQL on a route, you have to first define
  a config and then reference it at a route,
  see the above settings.
* You can turn GraphQL validation off and on in various ways,
  by disabling Coraza and/or GraphQL globally or per route,
  see the above settings.
* You can configure limits for complexity, depth and batch size,
  and allow introspection or not,
  also with the above settings.
* Regarding size limits,
  see also the section [Large Payloads](large-payloads.md).
* To use auto-learning,
  it is recommended to first use GraphQL in mode DETECT,
  and then auto-learn using the [Auto-Learning CLI](autolearning.md)
  with processing argument `graphql`.

## Basic Example

Here's a basic example
with GraphQL with default maxima for complexity, depth and batch size
(and introspection not allowed by default),
active in mode BLOCK on the route `/anything`,
and some limits on request and response body,
and with CRS disabled.

```yaml
spec:
  [...]
  coraza:
    requestBodyAccess: true
    requestBodyLimitKb: 1024
    responseBodyAccess: false
    responseBodyLimitKb: 128
    crs:
      defaultEnabled: false
    graphql:
      configs:
      - name: "graphql-book"
        schemaSource:
          configMap: "graphql-book-config-map"
          key: "schema.graphql"
  routes:
    - match:
        path: /anything
        pathType: "PREFIX"
      coraza:
        graphql:
          enabled: true
          ref: "graphql-book"
          mode: "BLOCK"
      backend:
        address: httpbin
        port: 8000
        protocol:
          selection: h1
```
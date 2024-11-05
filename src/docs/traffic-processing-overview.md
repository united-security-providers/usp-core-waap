# Traffic Processing

## Overview

Traffic processing is a Core WAAP feature that allows to "outsource" features that require complex validations of a specific kind.

A concrete example is ICAP antivirus (AV) scanning, which is usually performed on a dedicated server, usually from commercial company.

Another example is API validation using an OpenAPI Specification (OAS).

In both cases it is better to have the actual validation done outside the Core WAAP container in separate so-called sidecar containers, which can have independent resource settings.

Here is an overview of the architecture with ICAP AV and OpenAPI as examples:

![Traffic Processing Components](assets/images/traffic-processing-components.png)

In case of OpenAPI, the sidecar does perform the actual validation, while in the case of ICAP AV the sidecar provides the bridge to the ICAP protocol with which an external ICAP server is contacted.

The connection from the Core WAAP to the sidecars is always via gRPC ("Google" Remote Procedure Call), a very performant mechanism based on HTTP/2, here in a specific form that the Enovy Proxy provides for the purpose of what it calls "external processing" (extProc).

## Configuration

The Core WAAP configuration shields you from most details, basically all you have to do there is specify the desired functionality and optionally set desired resources for the sidecars (memory, CPU, etc.), the rest is handled automatically by the operator, as usual.

The configuration is essentially under 'spec.trafficProcessing'.

```yaml
spec:
  trafficProcessing:
    icap:
      - name: "icap-mcafee"
        operation: ...
        grpc: ...
        config: ...
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
    icap:
      - ...
        operation:
          image: "uspregistry.azurecr.io/usp/core/waap/usp-core-waap-grpc-icap"
          version: 0.0.1
          resources:
            claims: ...
            limits: ...
            requests: ...
            additionalProperties: ...
    openapi:
      - ...
        operation:
          image: "uspregistry.azurecr.io/usp/core/waap/usp-core-waap-grpc-openapi"
          version: 0.0.1
          resources:
            claims: ...
            limits: ...
            requests: ...
            additionalProperties: ...
```

The 'operation' sections is optional and might be used to make some resource-related adjustments to the default settings, if those have been specified in the ['waapSpecTrafficProcessingDefaults.openapi'](helm-values.md) section of the operator's configuration per type of traffic processor.

The 'grpc' section contains gRPC-related settings used for communication with the respective sidecar.

```yaml
spec:
  trafficProcessing:
    icap:
      - ...
        grpc:
          messageTimeout: 30s
    openapi:
      - ...
        grpc:
          messageTimeout: 30s
```

Finally, the 'config' section contains settings specific to the type of traffic processing, i.e. [config settings for ICAP AV](icap-antivirus-scanning.md) and [config settings for OpenAPI](openapi-validation.md) are different. These settings are described on the respective pages in this documentation.





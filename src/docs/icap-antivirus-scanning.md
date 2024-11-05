# ICAP Antivirus Scanning

## Internet Content Adaptation Protocol (ICAP)

ICAP is a protocol very similar to HTTP/1.1 designed to validate HTTP requests and responses and optionally to modify them. HTTP requests and responses can be sent to an ICAP server wrapped into ICAP requests and get back an OK or a modified HTTP request or response.

In practice ICAP has established itself for the purpose of antivirus scanning, typically only of HTTP requests and not modifying 

## ICAP Antivirus Scanning

TODO

Currently supported is ... TODO

## Configuration

OpenAPI validation is a part of the more general Traffic Processing of Core WAAP. As such, the configuration of schema and processing options is located in 'openapi' section of 'spec.trafficProcessing'.

```yaml
spec:
  trafficProcessing:
    icap:
      - name: "icap-mcafee-3" 
        operation: ...
        grpc: ...
        config: ...
```

See the [Traffic Processing Overview](traffic-processing-overview.md) for settings that have the same structure for all types of traffic processing, namely 'operation' (plus its defaults in the operator configuration) and 'grpc'.

The 'config' section contains the actual validation configuration.

```yaml
spec:
  trafficProcessing:
    icap:
      - ... 
        config:
          TODO: TODO
```

TODO


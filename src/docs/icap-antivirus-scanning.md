# ICAP Antivirus Scanning

## Internet Content Adaptation Protocol (ICAP)

ICAP is a protocol very similar to the original HTTP/1.x protocol, designed to validate HTTP requests and responses and optionally modify them. HTTP requests and responses can be wrapped into ICAP requests and sent to an ICAP server and the server sends back an ICAP response that signals an OK or contains a modified HTTP request or response.

ICAP has practically never been widely used in its full flexibility and would technologically be slightly outdated by now, but for the following use case it is still the de-facto standard today:

## ICAP Antivirus (AV) Scanning

The Core WAAP allows to send HTTP requests via ICAP to an ICAP server, typically to make sure that uploaded content does not contain any viruses or similar malware. (Modification of HTTP requests or scanning/modification of HTTP responses is, however, not a common use case and is currently not supported.)

Technically, the Core WAAP ICAP AV scanning uses OPTIONS and REQMOD ICAP requests to the ICAP server, the former to query abilities/preferences of the ICAP server, the latter to scan HTTP requests for viruses and similar malware. 

## Configuration

Providing ICAP AV scanning via an external ICAP server is a part of the more general Traffic Processing of Core WAAP. As such, its configuration is located in the 'icap' section of 'spec.trafficProcessing':

```yaml
spec:
  trafficProcessing:
    icap:
      - name: "icap-trendmicro-2" 
        operation: ...
        extProc: ...
        config: ...
```

See the Traffic Processing [Overview](traffic-processing-overview.md) for settings that have the same structure for all types of traffic processing, namely 'operation' and 'extProc' above.

The 'config' section contains the ICAP-specific configuration:

```yaml
spec:
  trafficProcessing:
    icap:
      - ... 
        config:
          url: "icap://some.host:1344/some/path"
```

The 'url' setting defines:

- Whether to use TLS to the ICAP server ("icaps://") or not ("icap://")
- Host, port and location to send the ICAP request to

TLS uses the same CA certificates as for HTTP backend routes, i.e. the settings under 'spec.operation.caCertificates' (and corresponding operator defaults).
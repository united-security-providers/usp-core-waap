# ICAP Antivirus Scanning

## Internet Content Adaptation Protocol (ICAP)

ICAP is a protocol very similar to the original HTTP/1.x protocol, designed to validate HTTP requests and responses and optionally modify them. HTTP requests and responses can be wrapped into ICAP requests and sent to an ICAP server and the server sends back an ICAP response that signals an OK or contains a modified HTTP request or response.

ICAP has practically never been widely used in its full flexibility and would technologically be slightly outdated by now, but for the following use case it is still the de-facto standard today:

## ICAP Antivirus (AV) Scanning

The Core WAAP allows to send HTTP requests via ICAP to an ICAP server, typically to make sure that uploaded content does not contain any viruses or similar malware. (Modification of HTTP requests or scanning/modification of HTTP responses is, however, not a common use case and is currently not supported.)

Technically, the Core WAAP ICAP AV scanning uses OPTIONS and REQMOD ICAP requests to the ICAP server, the former to query abilities/preferences of the ICAP server, the latter to scan HTTP requests for viruses and similar malware.

## Configuration


```yaml
spec:
  icap:
    - name: "icap-trendmicro-2"
      config: ...
```

See the [API reference](crd-doc.md#corewaapservicespecicapindex) for more information on how the config looks like.

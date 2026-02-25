# CRS Basic Usage

(This section assumes you have read the section [What is Coraza?](coraza.md#what-is-coraza))

* By default, CRS is active on all routes,
  with OWASP CRS rule sets for request validation,
  i.e. the default is the usually desired protection
  in a case where the backend is essentially trusted.
* CRS related settings are at `spec.coraza.crs` and
  `spec.routes[].coraza.crs`, plus general Coraza settings
  at `spec.coraza` and `spec.routes[].coraza`
  in the [API Reference](crd-doc.md).
* You can turn CRS off and on in various ways,
  by disabling Coraza and/or CRS globally or per route,
  see the above settings.
* And you can configure various limits and features
  with also the above settings.
* Regarding size limits,
  see also the section [Large Payloads](large-payloads.md).
* To use auto-learning,
  it is recommended to first use CRS in mode DETECT,
  and then auto-learn using the [Auto-Learning CLI](autolearning.md)
  with processing argument `crs`.

## Basic Example

Here's a basic example
with CRS with some specific rules,
active (by default)
in mode BLOCK on the route `/`,
and some limits on request and response body.

```yaml
spec:
  [...]
  coraza:
    requestBodyAccess: true
    requestBodyLimitKb: 1024
    responseBodyAccess: false
    responseBodyLimitKb: 128
    crs:
      mode: BLOCK
      securityLevel: 5
      paranoiaLevel: 1
      enabledRequestRules:
        - REQUEST_913_SCANNER_DETECTION
        - REQUEST_921_PROTOCOL_ATTACK
        - REQUEST_922_MULTIPART_ATTACK
        - REQUEST_930_APPLICATION_ATTACK_LFI
        - REQUEST_931_APPLICATION_ATTACK_RFI
        - REQUEST_932_APPLICATION_ATTACK_RCE
        - REQUEST_933_APPLICATION_ATTACK_PHP
        - REQUEST_934_APPLICATION_ATTACK_GENERIC
        - REQUEST_941_APPLICATION_ATTACK_XSS
        - REQUEST_942_APPLICATION_ATTACK_SQLI
        - REQUEST_943_APPLICATION_ATTACK_SESSION_FIXATION
        - REQUEST_944_APPLICATION_ATTACK_JAVA
  routes:
    - match:
        path: "/"
        pathType: "PREFIX"
      backend:
        address: httpbin
        port: 8000
        protocol:
          selection: h1
```

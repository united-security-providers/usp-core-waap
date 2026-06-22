# Handling large request and response payloads with OWASP CRS attack detection

In USP Core WAAP, [OWASP CRS](https://owasp.org/www-project-modsecurity-core-rule-set) attack detection and prevention capabilities, as well as GraphQL protection, are provided by the [Coraza Web Application Firewall (WAF)](https://coraza.io). This WAF is deployed as an [Envoy Golang Filter](https://github.com/united-security-providers/coraza-envoy-go-filter) (with an additional, proprietary plugin for GraphQL) which, contingent on its specific configuration, necessitates data buffering to perform thorough analysis of requests and responses for potential attack vectors.

For the WAF to effectively inspect substantial data volumes, including extensive request bodies and large file uploads, precise configuration is paramount. Misconfigured limits can result in the erroneous blocking of legitimate requests, whereas excessively high thresholds can cause significant memory overhead, elevated CPU utilization, and a heightened risk of performance bottlenecks or denial-of-service (DoS) vulnerabilities. The same considerations apply to handling responses with large bodies.

Optimizing WAF settings is crucial to maintain both security efficacy and system stability.

## Three levels of limits

Core WAAP applies payload limits at three distinct levels. They are complementary and serve different purposes, so it is important to understand which one applies to a given situation and how they interact:

1. **Core WAAP proxy connection buffer limit** *(applies to requests and responses)*: the outermost limit. It is configured through `spec.operation.bufferLimitBytes` and is rendered as Envoy's [`perConnectionBufferLimitBytes`](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/listener/v3/listener.proto) on the listener. This is a *soft limit* (a high-watermark) on the size of the connection's read and write buffers, used for flow control and backpressure; it is **not** in itself a hard request-size limit. For payloads that stream straight through, exceeding it merely applies backpressure (Core WAAP proxy pauses reading until the buffer drains). It becomes a hard ceiling only for filters that must buffer the *full* body before they can act, such as the WAF body inspection or OpenAPI request body validation: a buffered **request** body that exceeds the limit is rejected with a 413 (Payload Too Large), and a buffered **response** body that exceeds it fails with a 500 (Internal Server Error). The default is 1 MiB. Because every buffering filter is bounded by this limit, it effectively bounds the two levels below it: the WAF can never scan more of a body than fits within this buffer. It is described in [`CoreWaapService.spec.operation.bufferLimitBytes`](#corewaapservicespecoperationbufferlimitbytes) below.

2. **WAF (Coraza) body scanning limits** *(applies to requests and responses)*: these settings govern *how much* of a payload the Coraza WAF parses and scans for threats. They are configured through `spec.coraza.requestBodyLimitKb` / `spec.coraza.responseBodyLimitKb` (default 128 KB resp. 256 KB) and the corresponding `spec.coraza.requestBodyLimitAction` / `spec.coraza.responseBodyLimitAction`, which decide whether bytes beyond the limit are let through unscanned (`ProcessPartial`) or cause the payload to be rejected (`Reject`). These limits operate *within* the Core WAAP proxy connection buffer limit and therefore cannot exceed it effectively. They are described in [Level 2: WAF body scanning limits](#level-2-waf-body-scanning-limits) below.

3. **Route-level request size enforcement** *(applies to requests only)*: a hard, per-route cap on the request body size, configured through `spec.routes[].sizeEnforcement`. It enforces a maximum request body size with a configurable HTTP status code and a `DETECT` or `REJECT` behaviour, and is independent of whether the WAF is enabled on the route. Crucially, it can enforce the limit by *streaming* (counting bytes as they pass) without buffering the body, so, unlike the two levels above, it does not incur the per-connection memory cost. It is described in [Level 3: Route-level request size enforcement](#level-3-route-level-request-size-enforcement) below.

Levels 1 and 2 are about *inspecting* payloads safely within a memory budget; level 3 is about *bounding* request size, with or without inspection. They can be used independently or together. When levels 2 and 3 are combined on the same route, take care to keep their limits consistent (see [Interaction with WAF buffering limits](#interaction-with-waf-buffering-limits)).

The three chapters below detail the Core WAAP settings behind each level, in the same order. For a comprehensive description of all available settings, please refer to the [Core WAAP API Reference](./crd-doc.md).

## Level 1: Core WAAP proxy connection buffer limit

### CoreWaapService.spec.operation.bufferLimitBytes

The parameter *CoreWaapService.spec.operation.bufferLimitBytes* is rendered as Envoy's *perConnectionBufferLimitBytes* on the listener and is the outermost of the [three levels of limits](#three-levels-of-limits). It is a *soft limit* (a high-watermark) on the size of each connection's read and write buffers: Core WAAP proxy uses it for flow control, applying backpressure (pausing reads until the buffer drains) rather than rejecting data outright. As long as no filter needs to buffer the body, payloads of any size stream through without being limited by this setting.

It only becomes an effective size ceiling when a filter must buffer the *full* body before it can act, such as the WAF body inspection (`spec.coraza` with body access) or OpenAPI request body validation. In that case, such a filter cannot complete once the buffered body exceeds the limit, so Core WAAP returns a local reply:

* When an incoming request body that must be buffered surpasses this configured limit, Core WAAP rejects the request and returns a 413 (Payload Too Large) HTTP status code (also increments the *downstream_rq_too_large* metric).

* Conversely, if a response body that must be buffered exceeds the limit, the operation is terminated, leading to an internal server error (500).

The default of *CoreWaapService.spec.operation.bufferLimitBytes* is 1 MiB (1048576 bytes). While increasing this limit can accommodate larger data transfers, it introduces the significant risk of extensive memory consumption. Setting this limit excessively high can lead to Core WAAP allocating and holding large amounts of memory when processing substantial request or response payloads. This increased memory usage can, in turn, result in:

* Degraded Performance: The system may slow down due to increased paging, garbage collection, or a general strain on available RAM.

* Resource Exhaustion: In severe cases, the Core WAAP service (or even the underlying system) could run out of memory, leading to crashes, instability, or other critical failures.

* Increased Latency: Larger buffer sizes can mean that more data needs to be processed and held in memory before the scanning can complete, potentially increasing the time taken for requests and responses.

Therefore, while aiming to support larger payloads, it is crucial to balance the limit with available system resources and typical data processing patterns to prevent detrimental memory-related issues.

## Level 2: WAF body scanning limits

The Coraza WAF body scanning limits operate *within* the Core WAAP proxy connection buffer limit (level 1) and govern whether (and how much of) a request or response body is parsed and scanned for threats.

### CoreWaapService.spec.coraza.enabled

Coraza Web Application Firewall functionality within Core WAAP is governed by the *CoreWaapService.spec.coraza.enabled* setting. Request and/or response payload scanning, and subsequent data buffering, are only enabled when this setting is enabled.

### CoreWaapService.spec.coraza.requestBodyAccess

The *CoreWaapService.spec.coraza.requestBodyAccess* setting provides control over whether Core WAAP performs scanning of incoming request payloads. Request data buffering is only activated if this setting is enabled.

### CoreWaapService.spec.coraza.responseBodyAccess

The *CoreWaapService.spec.coraza.responseBodyAccess*  setting provides control over whether Core WAAP performs scanning of outgoing response payloads. Response data buffering is only activated if this setting is enabled.

### CoreWaapService.spec.coraza.requestBodyLimitKb

*CoreWaapService.spec.coraza.requestBodyLimitKb* defines the maximum size (in kilobytes) of an incoming HTTP request body that Core WAAP's WAF is aiming to buffer and scan for security threats.

* Within Limit: If an incoming request payload's size is less than or equal to the configured limit, the entire request data is buffered and subjected to comprehensive WAF scanning. This behavior is contingent on *CoreWaapService.spec.coraza.requestBodyAccess* being enabled.

* Exceeding Limit: If an incoming request payload's size exceeds this defined limit, Core WAAP does not buffer or scan the portion of the request body that extends beyond the limit. This implies that any potential security threats or malicious content present in the truncated part of the request can bypass inspection.

A low limit may create security blind spots. Larger, legitimate request payloads that might contain embedded threats (e.g., in JSON or XML payloads) are not be fully scanned if they exceed the configured size, allowing potential malicious content to pass undetected. Whereas a high limit ensures more comprehensive scanning of very large request payloads, it can significantly increase the memory consumption within the Core WAAP service.

It is recommended to configure *CoreWaapService.spec.coraza.requestBodyLimitKb* based on a thorough understanding of the typical and maximum expected sizes of legitimate request payloads within the application landscape. This should be balanced against the available memory and processing capabilities of the Core WAAP deployment. Continuous monitoring of memory usage and performance metrics after adjusting this setting is advisable.

> Please note that *CoreWaapService.spec.coraza.requestBodyLimitKb* is limited by the *CoreWaapService.spec.operation.bufferLimitBytes* setting. Therefore, any value set for requestBodyLimitKb that is higher than the bufferlimitbytes is ineffective, as requests with payloads exceeding the buffer limit will be rejected before the requestBodyLimitKb can be applied.

### CoreWaapService.spec.coraza.responseBodyLimitKb

*CoreWaapService.spec.coraza.responseBodyLimitKb* functions similarly to *CoreWaapService.spec.coraza.requestBodyLimitKb*, but its application is specifically for outgoing response data. This limit is only taken into account if *CoreWaapService.spec.coraza.responseBodyAccess* is enabled.

### Changing partial processing of oversized payload to rejection

*CoreWaapService.spec.coraza.requestBodyLimitKb* and *CoreWaapService.spec.coraza.responseBodyLimitKb* are configured by default to perform partial processing of oversized payloads. This can be changed by explicitly setting *CoreWaapService.spec.coraza.requestBodyLimitAction* resp. *CoreWaapService.spec.coraza.responseBodyLimitAction* to *Reject*.

Setting the action to *Reject* immediately blocks any payload data that exceeds the limits defined by *CoreWaapService.spec.coraza.requestBodyLimitKb* or *CoreWaapService.spec.coraza.responseBodyLimitKb*, respectively. This is a significant security improvement as it prevents attackers from embedding threats in the remaining, unprocessed part of an oversized payload.

However, adopting this *Reject* behavior means operators must set more precise and adequate payload limits. If the limits are too low, legitimate traffic might be unnecessarily blocked, leading to service disruption. Conversely, overly generous limits could still allow very large, albeit ultimately rejected, payloads to consume resources.

## Level 3: Route-level request size enforcement

In addition to the proxy connection buffer limit and the WAF body scanning limits described above, Core WAAP can enforce a hard limit on the request body size *per route*, independently of whether the WAF is enabled on that route. This is configured under `spec.routes[].sizeEnforcement` and applies to **request bodies only** (there is no response size enforcement).

The limit is enforced in two stages:

* **Content-Length header inspection**: if the request carries a `Content-Length` header whose declared value already exceeds *maxSize*, the request is rejected immediately, before any body is received.

* **Stream monitoring**: for chunked transfers, or whenever the `Content-Length` header is absent or unreliable, Core WAAP tracks the actual number of bytes received and acts as soon as the threshold is crossed.

Unlike the WAF body scanning limits, route-level size enforcement does not normally require the request body to be buffered: when no other filter needs the body (see [Interaction with WAF buffering limits](#interaction-with-waf-buffering-limits)), Core WAAP enforces the limit by *streaming* the request and counting bytes as they arrive. As a result, even large limits can be enforced without the memory cost incurred by buffering. Note that in streaming mode the bytes received before the threshold is crossed may already have been forwarded upstream; the request is then terminated to prevent any further data transfer. When the body is buffered anyway (because the WAF or OpenAPI validation needs it), enforcement reuses that buffered body instead. Different routes can be configured with different limits.

### CoreWaapService.spec.routes[].sizeEnforcement.request.body.maxSize

*maxSize* defines the maximum allowed request body size **in bytes**. It is a required field and must be between 1 and 4294967295 (≈ 4 GB). A request whose body exceeds this value triggers the configured *limitBehaviour*.

### CoreWaapService.spec.routes[].sizeEnforcement.request.body.maxSizeStatusCode

*maxSizeStatusCode* defines the HTTP status code that Core WAAP returns when a request body exceeds *maxSize* and *limitBehaviour* is *REJECT*. It is a required field and must be a valid HTTP error status code between 400 and 599. A typical value is 413 (Payload Too Large).

### CoreWaapService.spec.routes[].sizeEnforcement.request.limitBehaviour

*limitBehaviour* controls what happens when a request body exceeds *maxSize*:

* **REJECT** (default): the request is blocked and Core WAAP returns the configured *maxSizeStatusCode*.

* **DETECT**: the request is *not* blocked and is forwarded to the backend, but the limit violation is written to the log. This is useful for observing real traffic and sizing the limit before switching to enforcement.

The following example configures a route that rejects any request with a body larger than 2048 bytes, returning a 413 status code:

```yaml
spec:
  routes:
    - match:
        path: /loc
        pathType: PREFIX
      backend:
        address: somewhere.not
        port: 5555
      sizeEnforcement:
        request:
          body:
            maxSize: 2048
            maxSizeStatusCode: 413
          limitBehaviour: REJECT
```

### Interaction with WAF buffering limits

Route-level size enforcement and the WAF buffering limits are independent mechanisms, but their limits should be kept consistent when both are used on the same route:

* `spec.coraza.requestBodyLimitKb` governs how much of the request body is *scanned* by the WAF, whereas *maxSize* governs the maximum request body size that is *allowed*. The `spec.operation.bufferLimitBytes` limit continues to apply whenever the request body is buffered.

* When the request body is buffered anyway (that is, when the WAF accesses the request body on the route via `spec.coraza.enabled` together with `spec.coraza.requestBodyAccess`, or when OpenAPI request body validation is active on the route), size enforcement reuses the buffered body. Otherwise it operates in streaming mode.

* If `spec.coraza.requestBodyLimitKb` (converted to bytes) is smaller than the route's *maxSize* while WAF request body access is enabled, Coraza may block requests that are actually within the allowed *maxSize*. In this case Core WAAP emits a configuration warning. To avoid this, set `spec.coraza.requestBodyLimitKb` to at least *maxSize* (expressed in KB) when combining both mechanisms.

## Common use cases

Next, typical use cases are shown to illustrate how the settings mentioned above interact.

### No request and response inspection

In the following use case, both scanning of requests and responses is disabled. For illustrative purposes, the default buffer size limit is reduced to 1024 bytes.

| **Setting**                     | **Value** |
|---------------------------------|-----------|
| spec.operation.bufferLimitBytes | 1024      |
| spec.coraza.requestBodyAccess   | false     |
| spec.coraza.requestBodyLimitKb  | -         |
| spec.coraza.responseBodyAccess  | false     |
| spec.coraza.responseBodyLimitKb | -         |

When either the request or response payload exceed the 1024 byte buffer limit, the transaction still proceeds successfully as the WAF is not configured to access any data. Core WAAP processes the large payloads by streaming them directly between the client and the backend, without attempting to hold the entire body in memory, thus avoiding any size-based limitations that would otherwise apply if accessing were enabled.

| request payload | response payload | HTTP status code | result/explanation |
| --- | --- | --- | --- |
| ```payload <= spec.operation.bufferLimitBytes``` | ```payload <= spec.operation.bufferLimitBytes``` |  200 OK | • backend receives full request payload | |
| ```payload > spec.operation.bufferLimitBytes``` | ```payload > spec.operation.bufferLimitBytes``` |  200 OK | • payload size is not limited as no buffering needed |

### Request inspection with partial processing mode

In the next use case, scanning of up to 1024 bytes is enabled, with a maximum allowable payload size of 10 KB. The “_SecRequestBodyLimitAction_” option is set to “_ProcessPartial_” by default. Response scanning is deactivated.

| **Setting**                     | **Value**                |
|---------------------------------|--------------------------|
| spec.operation.bufferLimitBytes | 10240                    |
| spec.coraza.requestBodyAccess   | true                     |
| spec.coraza.requestBodyLimitKb  | 1                        |
| spec.coraza.responseBodyAccess  | false                    |
| spec.coraza.responseBodyLimitKb | -                        |
| spec.coraza.requestBodyLimitAction      | ProcessPartial (default) |

With these configurations options provided, the WAF is configured to partially inspect request payloads, scanning only the first 1024 bytes for threats. While it blocks any malicious requests found within that initial section, larger payloads are forwarded to the backend without scanning the rest of the content. Any threat located beyond the first 1024 bytes is missed. The WAF rejects any request that exceeds the overall 10 KB buffer limit.

| request payload                                                                                                                                                                                           | HTTP status code | result/explanation |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.requestBodyLimitKb```                                                                                                                                                           | 200 OK | • backend receives full request payload | |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes```                                                                                                | 200 OK | • ProcessPartial does not reject </br>• backend receives full request payload |
| ```payload > spec.operation.bufferLimitBytes```                                                                                                                                                           | 413 Payload Too Large | • insufficient buffer capacity to fully store the incoming request payload |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.coraza.requestBodyLimitKb bytes``` | 403 Forbidden | • backend receives no request payload </br>• malicious content found within first 1024 bytes |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious after spec.coraza.requestBodyLimitKb bytes```          | 200 OK | • only first 1024 bytes are scanned </br>• backend receives full request payload |

### Request inspection with reject processing mode

The following use case is similar to the previous one, with the difference that the action for requests whose payload exceeds the WAF body limit is set to _Reject_.

| **Setting**                     | **Value** |
|---------------------------------|-----------|
| spec.operation.bufferLimitBytes | 10240     |
| spec.coraza.requestBodyAccess   | true      |
| spec.coraza.requestBodyLimitKb  | 1         |
| spec.coraza.responseBodyAccess  | false     |
| spec.coraza.responseBodyLimitKb | -         |
| spec.coraza.requestBodyLimitAction      | Reject    |

With these configurations, the WAF is set to perform strict inspection on request payloads up to a 1 KB limit. If a request payload is within this limit and is free of malicious content, it is successfully forwarded to the backend. However, if a request payload is found to contain malicious content within this limit, it is immediately blocked with a 403 Forbidden error. Any request with a payload exceeding the 1 KB request body limit will be rejected with a 413 Payload Too Large error.

| request payload                                                                                                                        | HTTP status code | result/explanation |
|----------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.requestBodyLimitKb```                                                                                        | 200 OK | • backend receives full request payload | |
| ```payload > spec.coraza.requestBodyLimitKb```                                                                                            | 413 Payload Too Large | • request is rejected as limit of *spec.coraza.requestBodyLimitKb* is exceeded |
| ```payload < spec.coraza.requestBodyLimitKb``` </br>and</br>```payload contains malicious content within spec.coraza.requestBodyLimitKb```   | 403 Forbidden | • backend receives no request payload </br>• malicious content found |
| ```payload > spec.operation.bufferLimitBytes```</br>and</br>```payload contains malicious content after spec.coraza.requestBodyLimitKb``` | 413 Payload Too Large | • insufficient buffer capacity to fully store the incoming request payload and to detect the malicious content  |

### Response inspection with partial processing mode

The next use case deals exclusively with response inspection and is subject to the same restrictions as the previous cases for scanning requests.

| **Setting**                          | **Value**                    |
|--------------------------------------|------------------------------|
| spec.operation.bufferLimitBytes      | 10240                        |
| spec.coraza.requestBodyAccess        | false                        |
| spec.coraza.requestBodyLimitKb       | -                            |
| spec.coraza.responseBodyAccess       | true                         |
| spec.coraza.crs.enabledResponseRules | - RESPONSE_950_DATA_LEAKAGES |
| spec.coraza.responseBodyLimitKb      | 1                            |
| spec.coraza.responseBodyLimitAction            | ProcessPartial (default)     |

| response payload                                                                                                                                | HTTP status code | result/explanation |
|-------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.responseBodyLimitKb```                                                                                                | 200 OK | • client receives full response payload | |
| ```payload < spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.coraza.responseBodyLimitKb bytes``` | 403 Forbidden | • malicious content found within first 1024 bytes |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes```                                     | 200 OK | • ProcessPartial does not reject </br>• client receives full response payload |
| ```payload > spec.operation.bufferLimitBytes```                                                                                                 | 500 Internal Server Error | • insufficient buffer capacity to fully store the outgoing response payload |

The WAF scans the first 1024 bytes of any response for malicious content. If a response is within this 1 KB limit and is safe, it's passed on to the client. Similarly, for larger responses up to the 10 KB buffer limit, the WAF scans the initial 1 KB and, finding no threats, allows the entire response to pass through. If malicious content is found within that initial 1 KB section, the WAF blocks the response and returns a 403 Forbidden error to the client. Any response payload exceeding the overall 10 KB buffer limit causes the WAF to abort, resulting in a 500 Internal Server Error.

### Response inspection with reject processing mode

And finally, the use case for response inspection with action _Reject_ for oversized response data.

| **Setting** | **Value** |
| --- | --- |
| spec.operation.bufferLimitBytes | 10240 |
| spec.coraza.requestBodyAccess | false |
| spec.coraza.requestBodyLimitKb | - |
| spec.coraza.responseBodyAccess       | true                         |
| spec.coraza.crs.enabledResponseRules | - RESPONSE_950_DATA_LEAKAGES |
| spec.coraza.responseBodyLimitKb | 1 |
| spec.coraza.responseBodyLimitAction | Reject |

If a response is under the 1 KB limit and is found to be clean, it's delivered to the client without issue. However, if a response exceeds this limit, the WAF immediately rejects it with a 500 Internal Server Error. The WAF won't process or allow any response larger than its 1 KB inspection size, regardless of whether it contains malicious content or not.

| response payload | HTTP status code | result/explanation |
| --- | --- | --- |
| ```payload <= spec.coraza.responseBodyLimitKb``` | 200 OK | • client receives full response payload | |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` | 500 Internal Server Error | • request is rejected as limit of *spec.coraza.responseBodyLimitKb* is exceeded |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.coraza.responseBodyLimitKb bytes```| 500 Internal Server Error | • request is rejected as limit of *spec.coraza.responseBodyLimitKb* is exceeded |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content after spec.coraza.responseBodyLimitKb bytes```| 500 Internal Server Error | • request is rejected as limit of *spec.coraza.responseBodyLimitKb* is exceeded |

### Route-level request size enforcement with reject behaviour

This use case uses route-level request size enforcement to cap the request body at 2048 bytes, rejecting oversized requests with a 413 status code. It is independent of the WAF settings shown above.

| **Setting**                                              | **Value** |
|----------------------------------------------------------|-----------|
| spec.routes[].sizeEnforcement.request.body.maxSize           | 2048      |
| spec.routes[].sizeEnforcement.request.body.maxSizeStatusCode | 413       |
| spec.routes[].sizeEnforcement.request.limitBehaviour         | REJECT    |

| request payload                                    | HTTP status code      | result/explanation |
|----------------------------------------------------| --- | --- |
| ```payload <= maxSize```                           | 200 OK | • backend receives full request payload |
| ```payload > maxSize```                            | 413 Payload Too Large | • request is rejected with the configured *maxSizeStatusCode* |

### Route-level request size enforcement with detect behaviour

The same limit configured with *limitBehaviour* set to *DETECT*. Oversized requests are not blocked but are logged, which is useful for sizing the limit against real traffic before enforcing it.

| **Setting**                                              | **Value** |
|----------------------------------------------------------|-----------|
| spec.routes[].sizeEnforcement.request.body.maxSize           | 2048      |
| spec.routes[].sizeEnforcement.request.body.maxSizeStatusCode | 413       |
| spec.routes[].sizeEnforcement.request.limitBehaviour         | DETECT    |

| request payload          | HTTP status code | result/explanation |
|--------------------------| --- | --- |
| ```payload <= maxSize``` | 200 OK | • backend receives full request payload |
| ```payload > maxSize```  | 200 OK | • request is not blocked </br>• backend receives full request payload </br>• limit violation is written to the log |

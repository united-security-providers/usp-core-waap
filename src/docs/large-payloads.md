# Handling large request and response payloads with OWASP CRS attack detection

In USP Core WAAP, [OWASP CRS](https://owasp.org/www-project-modsecurity-core-rule-set) attack detection and prevention capabilities, was well as GraphQL protection, are provided by the [Coraza Web Application Firewall (WAF)](https://coraza.io). This WAF is deployed as an [Envoy Golang Filter](https://github.com/united-security-providers/coraza-envoy-go-filter) (with an additional, proprietary plugin for GraphQL) which, contingent on its specific configuration, necessitates data buffering to perform thorough analysis of requests and responses for potential attack vectors.

For the WAF to effectively inspect substantial data volumes, including extensive request bodies and large file uploads, precise configuration is paramount. Misconfigured limits can result in the erroneous blocking of legitimate requests, whereas excessively high thresholds can cause significant memory overhead, elevated CPU utilization, and a heightened risk of performance bottlenecks or denial-of-service (DoS) vulnerabilities. The same considerations apply to handling responses with large bodies.

Optimizing WAF settings is crucial to maintain both security efficacy and system stability.

## Settings

This section details the specific Core WAAP settings that impact the handling of large payloads. For a comprehensive description of all available settings, please refer to the [Core WAAP API Reference](./crd-doc.md).

### CoreWaapService.spec.coraza.enabled

Coraza Web Application Firewall functionality within Core WAAP is governed by the *CoreWaapService.spec.coraza.enabled* setting. Request and/or response payload scanning, and subsequent data buffering, are only enabled when this setting is enabled.

### CoreWaapService.spec.coraza.requestBodyAccess

The *CoreWaapService.spec.coraza.requestBodyAccess* setting provides control over whether Core WAAP performs scanning of incoming request payloads. Request data buffering is only activated if this setting is enabled.

### CoreWaapService.spec.coraza.responseBodyAccess

The *CoreWaapService.spec.coraza.responseBodyAccess*  setting provides control over whether Core WAAP performs scanning of outgoing response payloads. Response data buffering is only activated if this setting is enabled.

### CoreWaapService.spec.operation.bufferLimitBytes

The parameter *CoreWaapService.spec.operation.bufferLimitBytes* sets the upper limit for the size of both request and response payloads handled by Core WAAP. Specifically:

* When an incoming request body surpasses this configured limit, Core WAAP will promptly reject the request and return a 413 (Payload Too Large) HTTP status code.

* Conversely, if the response data being processed exceeds the defined limit, the operation is terminated, leading to an internal server error (500).

The default of *CoreWaapService.spec.operation.bufferLimitBytes* is 1 MB. While increasing this limit can accommodate larger data transfers, it introduces the significant risk of extensive memory consumption. Setting this limit excessively high can lead to Core WAAP allocating and holding large amounts of memory when processing substantial request or response payloads. This increased memory usage can, in turn, result in:

* Degraded Performance: The system may slow down due to increased paging, garbage collection, or a general strain on available RAM.

* Resource Exhaustion: In severe cases, the Core WAAP service (or even the underlying system) could run out of memory, leading to crashes, instability, or other critical failures.

* Increased Latency: Larger buffer sizes can mean that more data needs to be processed and held in memory before the scanning can complete, potentially increasing the time taken for requests and responses.

Therefore, while aiming to support larger payloads, it is crucial to balance the limit with available system resources and typical data processing patterns to prevent detrimental memory-related issues.

### CoreWaapService.spec.coraza.requestBodyLimitKb

*CoreWaapService.spec.coraza.requestBodyLimitKb* defines the maximum size (in kilobytes) of an incoming HTTP request body that Core WAAP's WAF is aiming to buffer and scan for security threats.

* Within Limit: If an incoming request payload's size is less than or equal to the configured limit, the entire request data is buffered and subjected to comprehensive WAF scanning. This behavior is contingent on *CoreWaapService.spec.coraza.requestBodyAccess* being enabled.

* Exceeding Limit: If an incoming request payload's size exceeds this defined limit, Core WAAP does not buffer or scan the portion of the request body that extends beyond the limit. This implies that any potential security threats or malicious content present in the truncated part of the request can bypass inspection.

A low limit may create security blind spots. Larger, legitimate request payloads that might contain embedded threats (e.g., in JSON or XML payloads) are not be fully scanned if they exceed the configured size, allowing potential malicious content to pass undetected. Whereas a high limit ensures more comprehensive scanning of very large responses, it can significantly increase the memory consumption within the Core WAAP service.

It is recommended to configure *CoreWaapService.spec.coraza.requestBodyLimitKb* based on a thorough understanding of the typical and maximum expected sizes of legitimate request payloads within the application landscape. This should be balanced against the available memory and processing capabilities of the Core WAAP deployment. Continuous monitoring of memory usage and performance metrics after adjusting this setting is advisable.

> Please note that *CoreWaapService.spec.coraza.requestBodyLimitKb* is limited by the *CoreWaapService.spec.operation.bufferLimitBytes* setting. Therefore, any value set for requestBodyLimitKb that is higher than the bufferlimitbytes is ineffective, as requests with payloads exceeding the buffer limit will be rejected before the requestBodyLimitKb can be applied.

### CoreWaapService.spec.coraza.responseBodyLimitKb

*CoreWaapService.spec.coraza.responseBodyLimitKb* functions similarly to *CoreWaapService.spec.coraza.requestBodyLimitKb*, but its application is specifically for outgoing response data. This limit is only taken into account if *CoreWaapService.spec.coraza.responseBodyAccess* is enabled.

### Changing partial processing of oversized payload to rejection

*CoreWaapService.spec.coraza.requestBodyLimitKb* and *CoreWaapService.spec.coraza.responseBodyLimitKb* are configured by default to perform partial processing of oversized payloads. While Core WAAP does not offer a direct setting to alter this, the [Native Config Post Processing (NCPP)](./native-config-post-processing.md) feature can be leveraged to modify the Coraza WAF's behavior to outright rejection. Specifically, the SecRequestBodyLimitAction and SecResponseBodyLimitAction settings of Coraza WAF must be changed from *ProcessPartial* to *Reject*, as outlined in the subsequent example.

<pre>
spec:
  nativeConfigPostProcessing:
    - |
      const httpFilters = lds.resources[0].filterChains[0].filters[0].typedConfig.httpFilters
      for (var i = 0; i < httpFilters.length; i++) {
        var httpFilter = httpFilters[i]
        if (httpFilter.name === 'core.waap.listener.filters.http.httpFilter.golang.coraza') {
          var updatedDirectives = httpFilter.typedConfig.pluginConfig.value.directives.replace("SecRequestBodyLimitAction ProcessPartial", "SecRequestBodyLimitAction Reject")
          httpFilter.typedConfig.pluginConfig.value.directives = updatedDirectives
        }
      }
</pre>
	  
Setting the action to *Reject* immediately blocks any payload data that exceeds the limits defined by *CoreWaapService.spec.crs.requestBodyLimitKb* or *CoreWaapService.spec.crs.responseBodyLimitKb*, respectively. This is a significant security improvement as it prevents attackers from embedding threats in the remaining, unprocessed part of an oversized payload.

However, adopting this *Reject* behavior means operators must set more precise and adequate payload limits. If the limits are too low, legitimate traffic might be unnecessarily blocked, leading to service disruption. Conversely, overly generous limits could still allow very large, albeit ultimately rejected, payloads to consume resources.

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

In the next use case, scanning of up to 1024 bytes is enabled, with a maximum allowable payload size of 10 KB. The “_SecRequesteBodyLimitAction_” option is set to “_ProcessPartial_” by default. Response scanning is deactivated.

| **Setting**                     | **Value**                |
|---------------------------------|--------------------------|
| spec.operation.bufferLimitBytes | 10240                    |
| spec.coraza.requestBodyAccess   | true                     |
| spec.coraza.requestBodyLimitKb  | 1                        |
| spec.coraza.responseBodyAccess  | false                    |
| spec.coraza.responseBodyLimitKb | -                        |
| SecRequesteBodyLimitAction      | ProcessPartial (default) |

With these configurations options provided, the WAF is configured to partially inspect request payloads, scanning only the first 1024 bytes for threats. While it blocks any malicious requests found within that initial section, larger payloads are forwarded to the backend without scanning the rest of the content. Any threat located beyond the first 1024 bytes is missed. The WAF rejects any request that exceeds the overall 10 KB buffer limit.

| request payload                                                                                                                                                                                           | HTTP status code | result/explanation |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.requestBodyLimitKb```                                                                                                                                                           | 200 OK | • backend receives full request payload | |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes```                                                                                                | 200 OK | • ProcessPartial does not reject </br>• backend receives full request payload |
| ```payload > spec.operation.bufferLimitBytes```                                                                                                                                                           | 413 Payload Too Large | • insufficient buffer capacity to fully store the incoming request payload |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.coraza.requestBodyLimitKb bytes``` | 403 Forbidden | • backend receives no request payload </br>• malicious content found within first 1024 bytes |
| ```payload > spec.coraza.requestBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious after spec.crs.requestBodyLimitKb bytes```          | 200 OK | • only first 1024 bytes are scanned </br>• backend receives full request payload |

### Request inspection with reject processing mode

The following use case is similar to the previous one, with the difference that the action for requests whose payload exceeds the WAF body limit is set to _Reject_.

| **Setting**                     | **Value** |
|---------------------------------|-----------|
| spec.operation.bufferLimitBytes | 10240     |
| spec.coraza.requestBodyAccess   | true      |
| spec.coraza.requestBodyLimitKb  | 1         |
| spec.coraza.responseBodyAccess  | false     |
| spec.coraza.responseBodyLimitKb | -         |
| SecRequesteBodyLimitAction      | Reject    |

With these configurations, the WAF is set to perform strict inspection on request payloads up to a 1 KB limit. If a request payload is within this limit and is free of malicious content, it is successfully forwarded to the backend. However, if a request payload is found to contain malicious content within this limit, it is immediately blocked with a 403 Forbidden error. Any request with a payload exceeding the 1 KB request body limit will be rejected with a 413 Payload Too Large error.

| request payload                                                                                                                        | HTTP status code | result/explanation |
|----------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.requestBodyLimitKb```                                                                                        | 200 OK | • backend receives full request payload | |
| ```payload > spec.coraza.requestBodyLimitKb```                                                                                            | 413 Payload Too Large | • request is rejected as limit of *spec.crs.requestBodyLimitKb* is exceeded |
| ```payload < spec.coraza.requestBodyLimitKb``` </br>and</br>```payload contains malicious content within spec.crs.requestBodyLimitKb```   | 403 Forbidden | • backend receives no request payload </br>• malicious content found |
| ```payload > spec.operation.bufferLimitBytes```</br>and</br>```payload contains malicious content after spec.crs.requestBodyLimitKb``` | 413 Payload Too Large | • insufficient buffer capacity to fully store the incoming request payload and to detect the malicious content  |

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
| SecReponseBodyLimitAction            | ProcessPartial (default)     |

| response payload                                                                                                                                | HTTP status code | result/explanation |
|-------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| ```payload <= spec.coraza.responseBodyLimitKb```                                                                                                | 200 OK | • client receives full response payload | |
| ```payload < spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.crs.responseBodyLimitKb bytes``` | 403 Forbidden | • malicious content found within first 1024 bytes |
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
| SecReponseBodyLimitAction | Reject |

If a response is under the 1 KB limit and is found to be clean, it's delivered to the client without issue. However, if a response exceeds this limit, the WAF immediately rejects it with a 500 Internal Server Error. The WAF won't process or allow any response larger than its 1 KB inspection size, regardless of whether it contains malicious content or not.

| response payload | HTTP status code | result/explanation |
| --- | --- | --- |
| ```payload <= spec.coraza.responseBodyLimitKb``` | 200 OK | • client receives full response payload | |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` | 500 Internal Server Error | • request is rejected as limit of *spec.crs.responseBodyLimitKb* is exceeded |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content within spec.crs.responseBodyLimitKb bytes```| 500 Internal Server Error | • request is rejected as limit of *spec.crs.responseBodyLimitKb* is exceeded |
| ```payload > spec.coraza.responseBodyLimitKb``` </br>and</br> ```payload <= spec.operation.bufferLimitBytes``` </br>and</br>```payload contains malicious content after spec.crs.responseBodyLimitKb bytes```| 500 Internal Server Error | • request is rejected as limit of *spec.crs.responseBodyLimitKb* is exceeded |

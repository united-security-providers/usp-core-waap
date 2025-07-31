# Handling large request and response payloads with OWASP CRS attack detection

In USP Core WAAP, [OWASP CRS](https://owasp.org/www-project-modsecurity-core-rule-set) attack detection and prevention capabilities are provided by the [Coraza Web Application Firewall (WAF)](https://coraza.io). This WAF is deployed as an [Envoy Golang Filter](https://github.com/united-security-providers/coraza-envoy-go-filter), which, contingent on its specific configuration, necessitates data buffering to perform thorough analysis of requests and responses for potential attack vectors.

For the WAF to effectively inspect substantial data volumes, including extensive request bodies and large file uploads, precise configuration is paramount. Misconfigured limits can result in the erroneous blocking of legitimate requests, whereas excessively high thresholds can cause significant memory overhead, elevated CPU utilization, and a heightened risk of performance bottlenecks or denial-of-service (DoS) vulnerabilities. Optimizing these settings is crucial to maintain both security efficacy and system stability.

## Settings

This section details the specific Core WAAP settings that impact the handling of large payloads. For a comprehensive description of all available settings, please refer to the [Core WAAP API Reference](https://docs.united-security-providers.ch/usp-core-waap/crd-doc).

### CoreWaapService.spec.crs.mode

Coraza Web Application Firewall functionality within Core WAAP is governed by the _CoreWaapService.spec.crs.mode_ setting. Request and/or response payload scanning, and subsequent data buffering, are only enabled when the mode is set to BLOCK or DETECT.

### CoreWaapService.spec.crs.requestBodyAccess, CoreWaapService.spec.crs.responseBodyAccess

The *CoreWaapService.spec.crs.requestBodyAccess* and *CoreWaapService.spec.crs.responseBodyAccess* settings provide control over whether Core WAAP performs scanning of incoming request payloads and outgoing response payloads, respectively.

Data buffering is only activated if the corresponding access setting is enabled: *CoreWaapService.spec.crs.requestBodyAccess* for incoming data, and *CoreWaapService.spec.crs.responseBodyAccess* for outgoing data.

### CoreWaapService.spec.operation.bufferlimitbytes

The parameter *CoreWaapService.spec.operation.bufferlimitbytes* sets the upper limit for the size of both request and response payloads handled by Core WAAP. Specifically:

* When an incoming request body surpasses this configured limit, Core WAAP will promptly reject the request and return a 413 (Payload Too Large) HTTP status code.

* Conversely, if the response data being processed exceeds the defined limit, the operation is terminated, leading to an internal server error (500).

The default of *CoreWaapService.spec.operation.bufferlimitbytes* is 1 MB. While increasing this limit can accommodate larger data transfers, it introduces the significant risk of extensive memory consumption. Setting this limit excessively high can lead to Core WAAP allocating and holding large amounts of memory when processing substantial request or response payloads. This increased memory usage can, in turn, result in:

* Degraded Performance: The system may slow down due to increased paging, garbage collection, or a general strain on available RAM.

* Resource Exhaustion: In severe cases, the Core WAAP service (or even the underlying system) could run out of memory, leading to crashes, instability, or other critical failures.

* Increased Latency: Larger buffer sizes can mean that more data needs to be processed and held in memory before the scanning can complete, potentially increasing the time taken for requests and responses.

Therefore, while aiming to support larger payloads, it is crucial to balance the limit with available system resources and typical data processing patterns to prevent detrimental memory-related issues.

### CoreWaapService.spec.crs.requestBodyLimitKb

*CoreWaapService.spec.crs.requestBodyLimitKb* defines the maximum size (in kilobytes) of an incoming HTTP request body that Core WAAP's WAF is aiming to buffer and scan for security threats.

* Within Limit: If an incoming requesst payload's size is less than or equal to the configured limit, the entire request data is buffered and subjected to comprehensive WAF scanning. This behavior is contingent on *CoreWaapService.spec.crs.responseBodyAccess* being enabled.

* Exceeding Limit: If an incoming request payload's size exceeds this defined limit, Core WAAP does not buffer or scan the portion of the request body that extends beyond the limit. This implies that any potential security threats or malicious content present in the truncated part of the request can bypass inspection.

A low limit may create security blind spots. Larger, legitimate request payloads that might contain embedded threats (e.g., in JSON or XML payloads) are not be fully scanned if they exceed the configured size, allowing potential malicious content to pass undetected. Whereas a high limit ensures more comprehensive scanning of very large responses, it can significantly increase the memory consumption within the Core WAAP service.

It is recommended to configure *CoreWaapService.spec.crs.requestBodyLimitKb* based on a thorough understanding of the typical and maximum expected sizes of legitimate request payloads within the application landscape. This should be balanced against the available memory and processing capabilities of the Core WAAP deployment. Continuous monitoring of memory usage and performance metrics after adjusting this setting is advisable.

> Please note that *CoreWaapService.spec.crs.requestBodyLimitKb* is limited by the *CoreWaapService.spec.operation.bufferlimitbytes* setting. Therefore, any value set for requestBodyLimitKb that is higher than the bufferlimitbytes is ineffective, as requests with payloads exceeding the buffer limit will be rejected before the requestBodyLimitKb can be applied.

### CoreWaapService.spec.crs.responseBodyLimitKb

*CoreWaapService.spec.crs.responseBodyLimitKb* functions similarly to *CoreWaapService.spec.crs.requestBodyLimitKb*, but its application is specifically for outgoing response data.

### Changing partial processing of oversized payload to rejection

*CoreWaapService.spec.crs.requestBodyLimitKb* and *CoreWaapService.spec.crs.responseBodyLimitKb* are configured by default to perform partial processing of oversized payloads. While Core WAAP does not offer a direct setting to alter this, the [Native Config Post Processing (NCPP)](https://github.com/united-security-providers/usp-core-waap/blob/main/src/docs/native-config-post-processing.md) feature can be leveraged to modify the Coraza WAF's behavior to outright rejection. Specifically, the SecRequestBodyLimitAction and SecResponseBodyLimitAction settings of Coraza WAF must be changed from *ProcessPartial* to *Reject*, as outlined in the subsequent example.

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

## Scenarios

* inspection-req-on-resp-off

| spec.operation.bufferLimitBytes | spec.crs.requestBodyAccess | spec.crs.requestBodyLimitKb | spec.crs.responseBodyAccess | spec.crs.responseBodyLimitKb | request payload| response payload | HTTP status code | backend | explanation |
| 1024 | true | 1 | - | - | payload < spec.crs.requestBodyLimitKb | - |  200 | backend receives full request payload ||
| 1024 | true | 1 | - | - | payload >= spec.crs.requestBodyLimitKb | - |  200 | backend receives full request payload | SecResonseBodyLimitAction set to ProcessPartial by default |
| 1024 | true | 1 | - | - | payload contains malicious content with spec.crs.requestBodyLimitKb bytes| backend receives no request payload |  403 | | SecResonseBodyLimitAction set to ProcessPartial by default |
| 1024 | true | 1 | - | - | payload contains malicious after spec.crs.requestBodyLimitKb bytes| backend receives full request payload |  200| | SecResonseBodyLimitAction set to ProcessPartial by default |













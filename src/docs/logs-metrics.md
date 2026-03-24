# Logs and Metrics

Logs about Core WAAP's http request / response processing and possible security policy violation events are crucial for the
visibility of the target web application or API operation.
Core WAAP Operator logs allow to monitor configuration change events. Besides logs, metrics offer quantitative data on
aspects like traffic volume, response times, and blocked threats, enabling the monitoring of Core WAAP effectiveness over
time and identifying trends or anomalies.

All Core WAAP components log to standard error in either JSON format for text format.
To process logs via a dedicated log stack for further processing and visualization, it is recommended to use the JSON format.
Metrics are exposed in Prometheus format via a dedicated Kubernetes service which is named after Core WAAP CRD with `metrics-` prefix.
The port of this service can be configured in `spec.operation.metrics` section of the
CRD (see [API Description](crd-doc.md#corewaapservicespecoperationmetrics) for it). The URL is `/metrics`.

How the log and monitoring stack can look like is beyond the scope of this documentation.

## Core WAAP filter metrics

The following metrics are exposed to help you monitor and observe the behavior of several filters.
Each metric captures a specific aspect of traffic processing giving you full visibility into both allowed and blocked transactions across all policy layers.

| Metric | Description |
|--------|-------------|
| `header_filter_tx_total` | Total number of requests processed by the header filter. |
| `header_filter_request_headers_removed_total` | Total number of request headers removed by the header filter. |
| `header_filter_response_headers_removed_total` | Total number of response headers removed by the header filter. |
| `icap_tx_allowed` | Total number of requests allowed after ICAP inspection. |
| `icap_tx_blocked` | Total number of requests blocked by ICAP inspection. |
| `icap_tx_processing_errors` | Total number of errors encountered during ICAP processing. |
| `icap_tx_total` | Total number of requests submitted for ICAP inspection. |
| `dos_tx_total` | Total number of requests evaluated by the DoS protection policy. |
| `dos_blocked_tx_total` | Total number of requests blocked by the DoS protection policy. |
| `openapi_tx_allowed` | Total number of requests allowed after OpenAPI schema validation. |
| `openapi_tx_blocked` | Total number of requests blocked by OpenAPI schema validation. |
| `openapi_responses_tx_allowed` | Total number of responses allowed after OpenAPI schema validation. |
| `openapi_responses_tx_blocked` | Total number of responses blocked by OpenAPI schema validation. |
| `openapi_tx_total` | Total number of requests evaluated against the OpenAPI schema. |

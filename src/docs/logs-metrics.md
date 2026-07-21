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

## Log format

The log format is selected with `spec.operation.startup.logFormat` and applies to all Core WAAP components.

Core WAAP emits two kinds of log lines: regular component logs and access logs.

### Component logs

Component log lines start with a series of bracketed fields, followed by the message and, optionally,
additional `key=value` attributes providing context for the message.

In text format:

```
[<time>][<level>][<worker>][<logger>][<source>][<component>] msg="<message>" <key>=<value> ...
```

In JSON format:

```json
{"time":"<time>","level":"<level>","workerId":"<worker>","logger":"<logger>","source":"<source>","component":"<component>","msg":"<message>", ...}
```

The bracketed fields are:

| Field | Description |
|-------|-------------|
| `time` | Timestamp of the log event (e.g. `2026-01-31 12:00:00.123456`). |
| `level` | Log level, e.g. `info`, `warning`, `error`, `debug`. |
| `worker` | Envoy worker (thread) id. |
| `logger` | Name of the logger that emitted the line. |
| `source` | Source location as `file:line`. |
| `component` | Core WAAP component that emitted the line (e.g. `proxy`). |

The message follows in `msg`. Depending on the component, additional attributes may be appended as
`key=value` pairs (text format) or as extra fields (JSON format).

### Access logs

Access log lines describe a single processed HTTP request / response. They are identified by the
`access` component and, instead of a message, carry a fixed set of request, response, upstream and client fields.

In text format:

```
[<time>][access] request.id="<...>" request.protocol="<...>" ... client.direct_address="<...>" hostname="<...>"
```

In JSON format:

```json
{
  "time": "<time>",
  "component": "access",
  "request": {
    "id": "<...>",
    "protocol": "<...>",
    "method": "<...>",
    "path": "<...>",
    "total_duration": <...>,
    "body_bytes_received": <...>,
    "headers": {
      "referer": "<...>",
      "forwarded_proto": "<...>",
      "forwarded_host": "<...>",
      "forwarded_for": "<...>",
      "useragent": "<...>"
    }
  },
  "response": {
    "status": <...>,
    "details": "<...>",
    "flags": "<...>",
    "body_bytes_sent": <...>
  },
  "upstream": {
    "connection_id": "<...>",
    "duration": "<...>",
    "host": "<...>",
    "route": "<...>",
    "cluster": "<...>",
    "bytes_sent": <...>,
    "bytes_received": <...>
  },
  "client": {
    "id": "<...>",
    "address": "<...>",
    "local_address": "<...>",
    "direct_address": "<...>"
  },
  "hostname": "<...>"
}
```

The fields are:

| Field | Description |
|-------|-------------|
| `time` | Start time of the request. |
| `request.id` | Request id (`X-Request-ID` header). |
| `request.protocol` | Request protocol, e.g. `HTTP/1.1`. |
| `request.method` | HTTP request method. |
| `request.path` | Request path (original path if it was rewritten). |
| `request.total_duration` | Total request duration in milliseconds. |
| `request.body_bytes_received` | Number of request body bytes received. |
| `request.headers.referer` | `Referer` request header. |
| `request.headers.forwarded_proto` | `X-Forwarded-Proto` request header. |
| `request.headers.forwarded_host` | `X-Forwarded-Host` request header. |
| `request.headers.forwarded_for` | `X-Forwarded-For` request header. |
| `request.headers.useragent` | `User-Agent` request header. |
| `response.status` | HTTP response status code. |
| `response.details` | Envoy response code details. |
| `response.flags` | Envoy response flags. |
| `response.body_bytes_sent` | Number of response body bytes sent. |
| `upstream.connection_id` | Downstream connection id. |
| `upstream.duration` | Upstream service time (`X-Envoy-Upstream-Service-Time` header). |
| `upstream.host` | Upstream host that served the request. |
| `upstream.route` | Name of the matched route. |
| `upstream.cluster` | Upstream cluster that served the request. |
| `upstream.bytes_sent` | Bytes sent to the upstream (on the wire). |
| `upstream.bytes_received` | Bytes received from the upstream (on the wire). |
| `client.id` | Client trace id (`X-Client-Trace-ID` header). |
| `client.address` | Downstream remote address. |
| `client.local_address` | Downstream local address. |
| `client.direct_address` | Downstream direct remote address. |
| `hostname` | Hostname of the Core WAAP instance. |

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

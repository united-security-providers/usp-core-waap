# Rate Limiting

## Repeat offender

Repeat Offender is designed to handle clients that repeatedly cause issues within a short period of time.
It monitors repeated behavior, such as triggering specific error responses, within a configurable time window. Each violation is counted per client using a configurable identifier.
When a client exceeds the allowed number of violations, enforcement is applied automatically. The client is temporarily blocked for the configured duration.
Once the duration expires, the client can send requests again. This allows clients to return to normal behavior after the window has passed.
Repeat Offender helps protect your system from sustained misuse, automated traffic, and repeated backend strain, while still giving clients a clear path to recover.

### Configuration

The repeat offender feature is configured globally and applies to all routes.
When enabled, it requires that the client identification, defined in `clientIdentification`, be included in every incoming request.
If it is missing, then the system responds with `clientIdentification.statusCodeIfMissing`.

There is also the option of excluding clients from this protection. Simply add their IP addresses to the `excludedClientIPs` list and they will never be blocked.

The remaining configuration defines what qualifies as a violation. You can specify either:

* a list of individual HTTP status codes
* a range of status codes (for example, 4xx to represent 400–499).

The `violations.threshold` setting determines how many violations are allowed within the configured time window (`violations.durationSecs`).
If no additional violations occur within this time window, the client’s violation counter resets to 0.
However, if the number of violations exceeds the defined threshold within the time window, then the client will be blocked for the same amount of time (`violations.durationSecs`).
During the block period, all requests from that client will receive the response code defined in `violation.statusCode`.

```yaml
spec:
  routes:
    - match:
        path: /
        pathType: PREFIX
      backend:
        address: backend
        port: 4433
  rateLimiting:
    repeatOffender:
      enabled: true
      clientIdentification:
        headerName: "X-Custom-Id-Header"
        statusCodeIfMissing: 404
      excludedClientIPs:
      - "1.2.3.4"
      - "9.8.7.6"
      violation:
        httpCodes:
        - "404"
        - "5xx"
        threshold: 10
        statusCode: 401
        durationSecs: 30
```

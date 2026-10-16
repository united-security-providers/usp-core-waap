> For AI agents: this documentation is indexed at https://docs.united-security-providers.ch/usp-core-waap/llms.txt, and every page is available as markdown at its own address plus index.md.

# Error Mapping

The main purpose of error mapping is to hide internals of the web application backend from potential attackers who could otherwise gather information about vulnerabilities. HTML error status codes (e.g. 403, 500) can be mapped to generic error pages. The error pages can be enriched with meta information like request-id, timestamp etc. to ease analysis for support staff. Furthermore the companies corporate design can easily be applied on such error pages across different backends.

Example of an error page:

![Sample 404 Error Page](../assets/images/error-page-usp-404.jpg)

## HTML error page for all 4xx errors with style and logo

A simple HTML error page with some info about the request is configured as follows.

In the CoreWaapService custom resource specify something like this:

```yaml
webResources:
  configMap: "web-resources-config-map"
  path: "/resources/"
  errorPages:
  - key: "error4xx.html"
    statusCode: "4xx"
```
Note: This will map all backend errors in the range 400-499 to the HTML page `error4xx.html`


The HTML Page can now be specified in a config map like this:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: "web-resources-config-map"
  namespace: "your-namespace"
data:
  error4xx.html: |
    <html>
      <head>
        <title>Error Page 4xx</title>
      </head>
      <body>
        <h1>Error Page 4xx</h1>
        <p>Backend status code: %RESPONSE_CODE%</p>
        <p>Request ID: %REQ(X-REQUEST-ID)%</p>
      </body>
    </html>
```

Note that you could use any of the [Envoy "%...%" variables](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage) in the error page.

Since `%` is used to mark these variables, a literal `%` character in the error page (e.g. in inline CSS like `width: 100%`) has to be escaped as `%%`:

```html
<div style="width: 100%%">...</div>
```

As described in the [API Reference](crd-doc/#corewaapservicespecwebresources) it is actually possible to directly serve other static files directly from Core WAAP. Anyhow, since Core WAAP is not a web server, there are strict size limitations. Therefore it is recommended to serve static files like JavaScript, CSS or images from a different web server and only reference them in HTML in Core WAAP. In order to avoid dependency to existing backend server for serving such static resources, one possible approach is to set up a dedicated pod to serve only such content. This is beyond the scope of this documentation. If the required static resources (e.g a CSS like w3.css) are publicly available over a CDN, they can also directly be fetched on browser side.

## JSON error document for 504 error mapped to 500

In the CoreWaapService custom resource specify something like this:

```yaml
webResources:
  configMap: "web-resources-config-map"
  path: "/resources/"
  errorPages:
  - key: "error504.json"
    statusCode: "504"
    mappedStatusCode: 500
```

And specify the resources in a config map like this:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: "web-resources-config-map"
  namespace: "your-namespace"
data:
  error504.json: |
    {
      "request_id":"%REQ(X-REQUEST-ID)%",
      "message":"Gateway Timeout"
    }
```

## Error pages depending on request and response headers

An error page can additionally be restricted to requests and backend responses with certain headers.

A typical use case is an API backend that returns JSON error documents:
API clients should still get the JSON document from the backend,
but a user who navigates there directly with a browser should see an HTML error page.

In the CoreWaapService custom resource specify something like this:

```yaml
webResources:
  configMap: "web-resources-config-map"
  path: "/resources/"
  errorPages:
  - key: "error5xx.html"
    statusCode: "5xx"
    requestHeaders:
    - name: "sec-fetch-dest"
      value: "document"
    responseHeaders:
    - name: "content-type"
      value: "application/(problem\\+)?json.*"
      valueType: "REGEX"
```

Here the HTML page `error5xx.html` is only served if the backend responds with a status code in the range 500-599,
the browser has sent `sec-fetch-dest: document` (i.e. the request is a top-level navigation and not e.g. a `fetch()` call),
and the backend response is JSON (`application/json` or `application/problem+json`).
In all other cases the client gets the original response from the backend.

The following rules apply:

* All conditions of an entry have to match: the status code and every header in `requestHeaders` and `responseHeaders`.
* A header that is missing in the request or response counts as no match.
* The entries in `errorPages` are checked in the order in which they are listed, the first matching entry wins.
  So list more specific entries before more general ones with the same status code.
* If no entry matches, the client gets the original response from the backend.
* Entries without `requestHeaders` and `responseHeaders` match on the status code alone.

### Which headers are matched

> [!IMPORTANT]
> The header conditions are checked against the request and response headers **in the state they have when the error pages are mapped, which is the last step of the response phase**, see [Processing Order](processing-order.md). So changes by all other features apply, in particular by [Header Filtering](header-filtering.md) and [Header Manipulation](header-manipulation.md), both to request and to response headers. Make sure the headers you are checking for are actually present at that point.

Standard headers like `sec-fetch-dest` and `content-type` are allowed by default by the header filter.
But a custom header, for example `x-error-format` in the request or `x-backend-error` in the backend response,
is removed by the header filter by default, and an error page condition on it never matches.
To use such a header, allow it in the header filter that applies to the route, for example:

```yaml
headerFilter:
  filters:
  - name: "allow-custom-headers"
    request:
      allow:
      - "x-error-format"
    response:
      allow:
      - "x-backend-error"
webResources:
  configMap: "web-resources-config-map"
  path: "/resources/"
  errorPages:
  - key: "error403.html"
    statusCode: "403"
    requestHeaders:
    - name: "x-error-format"
      value: "html"
  - key: "error502.html"
    statusCode: "502"
    responseHeaders:
    - name: "x-backend-error"
      value: "true"
routes:
- match:
    path: "/"
    pathType: "PREFIX"
  headerFilterRef: "allow-custom-headers"
  ...: ...
```

Note that the headers are then also passed on, the request header to the backend and the response header to the client
(at least if no error page is served).

## Turning error pages off per route

By default the error pages apply to all routes.
To pass backend responses through unchanged on a route, turn error pages off for it with `errorPages.enabled: false`:

```yaml
routes:
- match:
    path: "/api/"
    pathType: "PREFIX"
  ...: ...
  errorPages:
    enabled: false
- match:
    path: "/"
    pathType: "PREFIX"
  ...: ...
```

On such a route none of the entries under `webResources.errorPages` is applied,
so the client gets the original status code and body from the backend.
Static files under `webResources.staticFiles` are not affected.

## Behavior on configuration changes

Note that changes to a config map are not directly applied by a running Core WAAP. Therefore the Core WAAP Deployment has to be restarted. e.g.:
`kubectl -n juiceshop rollout restart deployment usp-core-waap`

# Error Mapping

The main purpose of error mapping is to hide internals of the web application backend from potential attackers who could otherwise gather information about vulnerabilities. HTML error status codes (e.g. 403, 500) can be mapped to generic error pages. The error pages can be enriched with meta information like request-id, timestamp etc. to ease analysis for support staff. Furthermore the companies corporate design can easily be applied on such error pages across different backends.

Example of an error page:

![Sample 404 Error Page](assets/images/error-page-usp-404.jpg)

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

As described in the [API Reference](https://united-security-providers.github.io/usp-core-waap/crd-doc/#corewaapservicespecwebresources) it is actually possible to directly serve other static files directly from Core WAAP. Anyhow, since Core WAAP is not a web server, there are strict size limitations. Therefore it is recommended to serve static files like JavaScript, CSS or images from a different web server and only reference them in HTML in Core WAAP. In order to avoid dependency to existing backend server for serving such static resources, one possible approach is to set up a dedicated pod to serve only such content. This is beyond the scope of this documentation. If the required static resources (e.g a CSS like w3.css) are publicly available over a CDN, they can also directly be fetched on browser side.

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
## Behavior on configuration changes

Note that changes to a config map are not directly applied by a running Core WAAP. Therefore the Core WAAP Deployment has to be restarted. e.g.:
`kubectl -n juiceshop rollout restart deployment usp-core-waap`
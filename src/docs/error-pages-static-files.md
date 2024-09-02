# Error Pages / Static Files

Configuration samples that show how to configure custom error pages and static web resources.

The main purpose of custom error pages is to hide internals of the web application backend (and the Core WAAP itself) from potential attackers who could otherwise gather information about vulnerabilities. HTML error status codes (e.g. 403, 500) can be mapped to error pages that can be customized by including information relevant for support calls, and they can be designed uniformly in your corporate design.

Static web resources like a company logo or CSS style sheet can be referenced from error pages and also static web pages can be served individually.

## HTML error page for all 4xx errors with style and logo

A simple HTML error page with some info about the circumstances that caused the error with a referenced CSS style sheet and a JPEG logo.

In the CoreWaapService custom resource specify something like this:

```yaml
webResources:
  configMap: "web-resources-config-map"
  path: "/resources/"
  staticFiles:
  - key: "style.css"
  - key: "logo.jpg"
  errorPages:
  - key: "error4xx.html"
    statusCode: "4xx"
```

And specify the resources in a config map like this:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: "web-resources-config-map"
  namespace: "your-namespace"
data:
  style.css: |
    body { color: green }
  error4xx.html: |
    <html>
    <head>
    <title>Error Page 4xx</title>
    <link rel="stylesheet" type="text/css" href="/resources/style.css"/>
    </head>
    <body>
    <h1>Error Page 4xx</h1>
    <p>backend status code: %RESPONSE_CODE%</p>
    <img src="/resources/logo.jpg">
    </body>
    </html>
binaryData:
  logo.jpg: |
    <base64-encoded-jpeg-image>
```

Note that you could use any of the [Envoy "%...%" variables](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage) in the error page that can e.g. be used to configure an access log in Envoy.

Static resources are, of course, also accessible without having to define an error page, i.e. also static HTML pages could be defined and used as static resources.

## JSON error page for 504 error mapped to 500

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
      "code":"%RESPONSE_CODE%",
      "message":"Gateway Timeout"
    }
```

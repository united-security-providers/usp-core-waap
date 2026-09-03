---
title: 'API Reference'
weight: 30
aliases:
  - '../crd-doc/'
---
# API Reference {#api-reference}

Packages:

- [waap.core.u-s-p.ch/v1alpha1](#waapcoreu-s-pchv1alpha1)

# waap.core.u-s-p.ch/v1alpha1 {#waapcoreu-s-pchv1alpha1}

Resource Types:

- [CoreWaapService](#corewaapservice)

## CoreWaapService {#corewaapservice}

<sup><sup>[↩ Parent](#waapcoreu-s-pchv1alpha1)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
      <td><b>apiVersion</b></td>
      <td>string</td>
      <td>waap.core.u-s-p.ch/v1alpha1</td>
      <td>true</td>
      </tr>
      <tr>
      <td><b>kind</b></td>
      <td>string</td>
      <td>CoreWaapService</td>
      <td>true</td>
      </tr>
      <tr>
      <td><b><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#objectmeta-v1-meta">metadata</a></b></td>
      <td>object</td>
      <td>Refer to the Kubernetes API documentation for the fields of the `metadata` field.</td>
      <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespec">spec</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicestatus">status</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec {#corewaapservicespec}

<sup><sup>[↩ Parent](#corewaapservice)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindex">routes</a></b></td>
        <td>[]object</td>
        <td>
          List of routes to backends (at least one route must be defined) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindex">authentications</a></b></td>
        <td>[]object</td>
        <td>
          List of authentications (OpenID Connect / OAuth 2.0 clients and/or JWT validations)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulation">cookieManipulation</a></b></td>
        <td>object</td>
        <td>
          Cookie manipulation settings; by default no cookie manipulation is done<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccoraza">coraza</a></b></td>
        <td>object</td>
        <td>
          Coraza filter settings for Core Rule Set (CRS) and GraphQL validations<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorspolicy">corsPolicy</a></b></td>
        <td>object</td>
        <td>
          Global CORS protection (default off); any legal OPTIONS requests will be responded to directly by Core WAAP and will not be passed on to backends; other requests will not be responded to directly, but if they are accepted CORS requests that match configured allowed origins, Core WAAP will add the related headers to the response<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccsrfpolicy">csrfPolicy</a></b></td>
        <td>object</td>
        <td>
          Global CSRF protection (default on); detects and blocks CSRF attacks based on comparing the request origin (either 'Origin' or 'Referrer' header) with the request target; if the origin does not match the target and is not allowed specifically, the request will be blocked<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilter">headerFilter</a></b></td>
        <td>object</td>
        <td>
          Header filter settings; active by default with default sets of allowed request and response headers<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheadermanipulation">headerManipulation</a></b></td>
        <td>object</td>
        <td>
          Header manipulation settings; by default no header manipulation is done<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>hostnames</b></td>
        <td>[]string</td>
        <td>
          List of hostnames (append ports with ':', default is wildcard '*')<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecicapindex">icap</a></b></td>
        <td>[]object</td>
        <td>
          ICAP settings (Internet Content Adaptation Protocol); ICAP is typically used for Anti-Virus scanning of HTTP request bodies; currently only validation of the HTTP request body is supported (ICAP REQMOD) (no modifications to the scanned body, no validation of HTTP responses) (note that ICAP validation is done after OpenAPI validation)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeclua">lua</a></b></td>
        <td>object</td>
        <td>
          Lua filters settings (filter scripts plus helper scripts/files)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>nativeConfigPostProcessing</b></td>
        <td>[]string</td>
        <td>
          JavaScripts for post-processing generated Envoy config<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecopenapiindex">openapi</a></b></td>
        <td>[]object</td>
        <td>
          OpenAPI settings; OpenAPI is used for request/response validation against an OpenAPI schema (note that OpenAPI validation is done before ICAP validation)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperation">operation</a></b></td>
        <td>object</td>
        <td>
          Operation related settings to be used for the Core WAAP Kubernetes deployment; these settings typically do not affect generated Envoy config (optional, except that the operation's image/version fields must be set in the spec or via default in the operator config) [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec, e.g. resources.limits.cpu could be defined in operator config but resources.requests.cpu in the spec; exception: lists within the config tree are completely overridden by the ones in the spec if present, which affects e.g. tolerations and lists under affinity]<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoriginblocking">originBlocking</a></b></td>
        <td>object</td>
        <td>
          Origin blocking<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecratelimiting">rateLimiting</a></b></td>
        <td>object</td>
        <td>
          Rate limiting settings<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecwebresources">webResources</a></b></td>
        <td>object</td>
        <td>
          Resources from a config map to serve as static files and/or to map status codes to error pages with dynamic content<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>websocket</b></td>
        <td>boolean</td>
        <td>
          Allow websocket <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index] {#corewaapservicespecroutesindex}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindexbackend">backend</a></b></td>
        <td>object</td>
        <td>
          Backend <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatch">match</a></b></td>
        <td>object</td>
        <td>
          Matching criteria <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexauth">auth</a></b></td>
        <td>object</td>
        <td>
          Authentication<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>autoHostRewrite</b></td>
        <td>boolean</td>
        <td>
          Indicates that during forwarding, the host header will be swapped with the hostname of the upstream host <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>cookieManipulationRef</b></td>
        <td>string</td>
        <td>
          Optional reference to a cookie manipulation defined under spec.cookieManipulation.configurations; overrides the defaultManipulationRef for this route<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexcoraza">coraza</a></b></td>
        <td>object</td>
        <td>
          Coraza settings per route, including CRS and GraphQL<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>headerFilterRef</b></td>
        <td>string</td>
        <td>
          Optional reference to a header filter defined under spec.headerFilter.filters<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>headerManipulationRef</b></td>
        <td>string</td>
        <td>
          Optional reference to a header manipulation defined under spec.headerManipulation.configurations<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>icapRefs</b></td>
        <td>[]string</td>
        <td>
          References to ICAP; processing order is in the order listed under spec.icap<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexluarefs">luaRefs</a></b></td>
        <td>object</td>
        <td>
          References to Lua filters<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>openapiRefs</b></td>
        <td>[]string</td>
        <td>
          References to OpenAPI; processing order is in the order listed under spec.openapi<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexsizeenforcement">sizeEnforcement</a></b></td>
        <td>object</td>
        <td>
          Size enforcement settings per route<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>timeout</b></td>
        <td>string</td>
        <td>
          The seconds to wait for the upstream to respond with a complete response. This timeout does not start until the entire downstream request stream has been received. <br/>
          <br/>
            <i>Default</i>: 15s<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].backend {#corewaapservicespecroutesindexbackend}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

Backend

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>address</b></td>
        <td>string</td>
        <td>
          Backend hostname or IP <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>port</b></td>
        <td>integer</td>
        <td>
          Backend port number <br/>
          <br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 65535<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexbackendprotocol">protocol</a></b></td>
        <td>object</td>
        <td>
          Protocol<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexbackendtls">tls</a></b></td>
        <td>object</td>
        <td>
          TLS<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].backend.protocol {#corewaapservicespecroutesindexbackendprotocol}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexbackend)</sup></sup>

Protocol

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>selection</b></td>
        <td>enum</td>
        <td>
          Selection of upstream protocol (h2 uses HTTP/2, h1 uses HTTP/1.1, auto negotiates the protocol using ALPN (requires TLS) with HTTP/2 preferred and HTTP/1.1 as fallback) <br/>
          <br/>
            <i>Enum</i>: auto, h1, h2<br/>
            <i>Default</i>: h2<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].backend.tls {#corewaapservicespecroutesindexbackendtls}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexbackend)</sup></sup>

TLS

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>checkCertificates</b></td>
        <td>boolean</td>
        <td>
          Check trusted certificates and SAN <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Enable TLS <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match {#corewaapservicespecroutesindexmatch}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

Matching criteria

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>path</b></td>
        <td>string</td>
        <td>
          Path (depending on pathType either a regex or a prefix) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatchfilters">filters</a></b></td>
        <td>object</td>
        <td>
          Filters<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatchheadersindex">headers</a></b></td>
        <td>[]object</td>
        <td>
          List of header matchers (logical AND between header matchers and with path)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>pathType</b></td>
        <td>enum</td>
        <td>
          Path type <br/>
          <br/>
            <i>Enum</i>: PREFIX, REGEX<br/>
            <i>Default</i>: REGEX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match.filters {#corewaapservicespecroutesindexmatchfilters}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexmatch)</sup></sup>

Filters

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>allowedMethods</b></td>
        <td>[]enum</td>
        <td>
          Allowed http methods (all methods allowed if not specified)<br/>
          <br/>
            <i>Enum</i>: ACL, BIND, CHECKOUT, CONNECT, COPY, DELETE, GET, HEAD, LINK, LOCK, MERGE, MKACTIVITY, MKCALENDAR, MKCOL, MOVE, MSEARCH, NOTIFY, OPTIONS, PATCH, POST, PROPFIND, PROPPATCH, PURGE, PUT, REBIND, REPORT, SEARCH, SOURCE, SUBSCRIBE, TRACE, UNBIND, UNLINK, UNLOCK, UNSUBSCRIBE<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatchfiltersoriginblocking">originBlocking</a></b></td>
        <td>object</td>
        <td>
          Origin blocking<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatchfiltersrewrite">rewrite</a></b></td>
        <td>object</td>
        <td>
          Rewrite request<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match.filters.originBlocking {#corewaapservicespecroutesindexmatchfiltersoriginblocking}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexmatchfilters)</sup></sup>

Origin blocking

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>ips</b></td>
        <td>[]string</td>
        <td>
          Allowed or denied IP addresses (CIDR notation or single IP, e.g. 1.2.3.4/32 or 1.2.3.4) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>policy</b></td>
        <td>enum</td>
        <td>
          Policy (ALLOW or DENY access depending on origin) <br/>
          <br/>
            <i>Enum</i>: ALLOW, DENY<br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match.filters.rewrite {#corewaapservicespecroutesindexmatchfiltersrewrite}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexmatchfilters)</sup></sup>

Rewrite request

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindexmatchfiltersrewriteurl">url</a></b></td>
        <td>object</td>
        <td>
          URL to set upstream<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match.filters.rewrite.url {#corewaapservicespecroutesindexmatchfiltersrewriteurl}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexmatchfiltersrewrite)</sup></sup>

URL to set upstream

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>path</b></td>
        <td>string</td>
        <td>
          Path to rewrite (if regex path can use \1, \2 etc. to replace matched regex groups) <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].match.headers[index] {#corewaapservicespecroutesindexmatchheadersindex}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexmatch)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Request header name (supported are regular header names as well as the pseudo-headers ':authority' and ':method') <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Request header value (exact match of full string or regex match) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>valueType</b></td>
        <td>enum</td>
        <td>
          Value type <br/>
          <br/>
            <i>Enum</i>: EXACT, REGEX<br/>
            <i>Default</i>: EXACT<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].auth {#corewaapservicespecroutesindexauth}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

Authentication

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>ref</b></td>
        <td>string</td>
        <td>
          Reference to name of corresponding authentication setting <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].coraza {#corewaapservicespecroutesindexcoraza}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

Coraza settings per route, including CRS and GraphQL

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindexcorazacrs">crs</a></b></td>
        <td>object</td>
        <td>
          OWASP Core Rule Set (CRS) settings per route<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether to enable Coraza for the route or not <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecroutesindexcorazagraphql">graphql</a></b></td>
        <td>object</td>
        <td>
          GraphQL settings per route<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].coraza.crs {#corewaapservicespecroutesindexcorazacrs}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexcoraza)</sup></sup>

OWASP Core Rule Set (CRS) settings per route

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether to enable Coraza CRS for the route or not, effective default is spec.coraza.crs.defaultEnabled<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>skipBody</b></td>
        <td>boolean</td>
        <td>
          Whether to skip request body validation or not (requestBodyAccess on/off) <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].coraza.graphql {#corewaapservicespecroutesindexcorazagraphql}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexcoraza)</sup></sup>

GraphQL settings per route

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether to enable Coraza GraphQL for the route or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mode</b></td>
        <td>enum</td>
        <td>
          Mode (DETECT = traffic identified as suspicious is logged but not blocked; BLOCK = traffic identified as suspicious is blocked) <br/>
          <br/>
            <i>Enum</i>: BLOCK, DETECT<br/>
            <i>Default</i>: BLOCK<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>ref</b></td>
        <td>string</td>
        <td>
          Reference to name of corresponding GraphQL setting; required if GraphQL is enabled on the route<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].luaRefs {#corewaapservicespecroutesindexluarefs}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

References to Lua filters

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>first</b></td>
        <td>[]string</td>
        <td>
          Lua filters to run first, i.e. before other types of filters (more precisely, run first for request and run last for response); Lua filters listed here are run in the order defined under spec.lua<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>last</b></td>
        <td>[]string</td>
        <td>
          Lua filters to run last, i.e. after other types of filters (more precisely, run last for request and run first for response); Lua filters listed here are run in the order defined under spec.lua<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].sizeEnforcement {#corewaapservicespecroutesindexsizeenforcement}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

Size enforcement settings per route

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindexsizeenforcementrequest">request</a></b></td>
        <td>object</td>
        <td>
          Request size enforcement settings <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].sizeEnforcement.request {#corewaapservicespecroutesindexsizeenforcementrequest}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexsizeenforcement)</sup></sup>

Request size enforcement settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecroutesindexsizeenforcementrequestbody">body</a></b></td>
        <td>object</td>
        <td>
          Request body size enforcement settings <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>limitBehaviour</b></td>
        <td>enum</td>
        <td>
          Behaviour when a limit is exceeded (DETECT only logs, REJECT blocks the request) <br/>
          <br/>
            <i>Enum</i>: DETECT, REJECT<br/>
            <i>Default</i>: REJECT<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.routes[index].sizeEnforcement.request.body {#corewaapservicespecroutesindexsizeenforcementrequestbody}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindexsizeenforcementrequest)</sup></sup>

Request body size enforcement settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>maxSize</b></td>
        <td>integer</td>
        <td>
          Maximum allowed request body size in bytes <br/>
          <br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 4.294967295e+09<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>maxSizeStatusCode</b></td>
        <td>integer</td>
        <td>
          HTTP status code returned when the request body exceeds maxSize <br/>
          <br/>
            <i>Default</i>: 413<br/>
            <i>Minimum</i>: 400<br/>
            <i>Maximum</i>: 599<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index] {#corewaapservicespecauthenticationsindex}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexbackend">backend</a></b></td>
        <td>object</td>
        <td>
          Settings for propagation to backend <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>jwksEndpoint</b></td>
        <td>string</td>
        <td>
          OIDC JWKS endpoint URL, offers credentials to verify JWTs (normally use https) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>audiences</b></td>
        <td>[]string</td>
        <td>
          List of accepted JWT audiences (if none is specified the JWT is not matched against the audience list)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>authorizationEndpoint</b></td>
        <td>string</td>
        <td>
          OIDC OP authorization endpoint URL (omit to mark JWT-only authentication; note that tokenEndpoint and credentials must always also be defined resp. omitted accordingly)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurations">cookieConfigurations</a></b></td>
        <td>object</td>
        <td>
          Settings for OAuth2 cookies<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcredentials">credentials</a></b></td>
        <td>object</td>
        <td>
          OIDC credentials (client_id and client_secret, omit if only using JWT validation)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexdenyredirectmatcher">denyRedirectMatcher</a></b></td>
        <td>object</td>
        <td>
          If set, converts 302 redirect responses to 401 unauthorized responses for clients that should not handle redirects, typically Single-Page Applications (SPAs) that use JavaScript (note that if set, the configured (or default) header must also be whitelisted in the request header filter)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>endSessionEndpoint</b></td>
        <td>string</td>
        <td>
          Optional OIDC OP endpoint URL to end the session at the OP (logout at OP); note that logout is initiated at '/core-waap/oauth/{spec.authentications[].name}/signout', which always logs out the client (i.e. the Core WAAP itself), plus, if an end session endpoint is defined in this setting here, subsequently also attempts to log out at the OP<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>issuer</b></td>
        <td>string</td>
        <td>
          OIDC OP issuer (mandatory for OIDC authentication, optional if JWT-only authentication)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>postLogoutRedirectUri</b></td>
        <td>string</td>
        <td>
          Optional URL where the OIDC OP would redirect to after ending the session; defaults to the root location at the RP's host<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>scopes</b></td>
        <td>[]string</td>
        <td>
          List of scopes to be claimed in the authorization request<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>tokenEndpoint</b></td>
        <td>string</td>
        <td>
          OIDC OP token endpoint URL (omit if JWT-only authentication)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>tokenEndpointAuthType</b></td>
        <td>enum</td>
        <td>
          How to pass the client_id to the OP (BODY for URL-encoded body parameter, BASIC for basic auth) <br/>
          <br/>
            <i>Enum</i>: BASIC, BODY<br/>
            <i>Default</i>: BODY<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>useRefreshToken</b></td>
        <td>boolean</td>
        <td>
          Whether to allow automatic access token refresh using the associated refresh token <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].backend {#corewaapservicespecauthenticationsindexbackend}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindex)</sup></sup>

Settings for propagation to backend

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>forwardJwt</b></td>
        <td>boolean</td>
        <td>
          Whether to forward the JWT to the upstream server; if OIDC authentication is configured this option will be ignored <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexbackendjwtclaimtoheaderindex">jwtClaimToHeader</a></b></td>
        <td>[]object</td>
        <td>
          Translations of JWT claims to HTTP headers<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].backend.jwtClaimToHeader[index] {#corewaapservicespecauthenticationsindexbackendjwtclaimtoheaderindex}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexbackend)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>claim</b></td>
        <td>string</td>
        <td>
          Claim to set as header <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>headerName</b></td>
        <td>string</td>
        <td>
          Name of the header to set to the claim <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations {#corewaapservicespecauthenticationsindexcookieconfigurations}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindex)</sup></sup>

Settings for OAuth2 cookies

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationsbearertoken">bearerToken</a></b></td>
        <td>object</td>
        <td>
          Configuration for the bearer token cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationscodeverifiercookie">codeVerifierCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the code verifier cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationsexpirescookie">expiresCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the OAuth expires cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationshmaccookie">hmacCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the OAuth HMAC cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationsidtokencookie">idTokenCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the ID token cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationsnoncecookie">nonceCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the OAuth nonce cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecauthenticationsindexcookieconfigurationsrefreshtokencookie">refreshTokenCookie</a></b></td>
        <td>object</td>
        <td>
          Configuration for the refresh token cookie<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.bearerToken {#corewaapservicespecauthenticationsindexcookieconfigurationsbearertoken}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the bearer token cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.codeVerifierCookie {#corewaapservicespecauthenticationsindexcookieconfigurationscodeverifiercookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the code verifier cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.expiresCookie {#corewaapservicespecauthenticationsindexcookieconfigurationsexpirescookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the OAuth expires cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.hmacCookie {#corewaapservicespecauthenticationsindexcookieconfigurationshmaccookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the OAuth HMAC cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.idTokenCookie {#corewaapservicespecauthenticationsindexcookieconfigurationsidtokencookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the ID token cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.nonceCookie {#corewaapservicespecauthenticationsindexcookieconfigurationsnoncecookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the OAuth nonce cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].cookieConfigurations.refreshTokenCookie {#corewaapservicespecauthenticationsindexcookieconfigurationsrefreshtokencookie}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindexcookieconfigurations)</sup></sup>

Configuration for the refresh token cookie

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>sameSite</b></td>
        <td>enum</td>
        <td>
          Value used for the SameSite cookie attribute<br/>
          <br/>
            <i>Enum</i>: DISABLED, LAX<br/>
            <i>Default</i>: LAX<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].credentials {#corewaapservicespecauthenticationsindexcredentials}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindex)</sup></sup>

OIDC credentials (client_id and client_secret, omit if only using JWT validation)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>clientId</b></td>
        <td>string</td>
        <td>
          OIDC client_id <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>clientSecret</b></td>
        <td>string</td>
        <td>
          OIDC client_secret by value (either this or clientSecretRef is mandatory)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>clientSecretRef</b></td>
        <td>string</td>
        <td>
          OIDC client_secret via reference to Kubernetes secret (recommended, either this or clientSecret is mandatory)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>hmacSecret</b></td>
        <td>string</td>
        <td>
          HMAC secret by value (either this or hmacSecretRef is mandatory)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>hmacSecretRef</b></td>
        <td>string</td>
        <td>
          HMAC secret via reference to Kubernetes secret (recommended, either this or hmacSecret is mandatory)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.authentications[index].denyRedirectMatcher {#corewaapservicespecauthenticationsindexdenyredirectmatcher}

<sup><sup>[↩ Parent](#corewaapservicespecauthenticationsindex)</sup></sup>

If set, converts 302 redirect responses to 401 unauthorized responses for clients that should not handle redirects, typically Single-Page Applications (SPAs) that use JavaScript (note that if set, the configured (or default) header must also be whitelisted in the request header filter)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether response mapping is enabled or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>expectedHeaderValue</b></td>
        <td>string</td>
        <td>
          Header value <br/>
          <br/>
            <i>Default</i>: empty<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>headerName</b></td>
        <td>string</td>
        <td>
          Header name <br/>
          <br/>
            <i>Default</i>: Sec-Fetch-Dest<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>headerValueType</b></td>
        <td>enum</td>
        <td>
          Whether to match the exact value or to treat the value as a REGEX <br/>
          <br/>
            <i>Enum</i>: EXACT, REGEX<br/>
            <i>Default</i>: EXACT<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation {#corewaapservicespeccookiemanipulation}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Cookie manipulation settings; by default no cookie manipulation is done

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulationconfigurationsindex">configurations</a></b></td>
        <td>[]object</td>
        <td>
          List of named cookie manipulation configurations; these configurations can be referenced via defaultManipulationRef and on individual routes<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>defaultManipulationRef</b></td>
        <td>string</td>
        <td>
          Optional reference to a default cookie manipulation configuration defined under configurations; applied to all routes unless overridden by a per-route cookieManipulationRef<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation.configurations[index] {#corewaapservicespeccookiemanipulationconfigurationsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccookiemanipulation)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name that can be used to reference this manipulation configuration <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>logOnly</b></td>
        <td>boolean</td>
        <td>
          If true, log cookie manipulation actions but do not apply them <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulationconfigurationsindexrequestindex">request</a></b></td>
        <td>[]object</td>
        <td>
          Cookie manipulation for HTTP request 'Cookie' headers; see https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cookie<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulationconfigurationsindexresponseindex">response</a></b></td>
        <td>[]object</td>
        <td>
          Cookie manipulation for HTTP response 'Set-Cookie' headers; see https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation.configurations[index].request[index] {#corewaapservicespeccookiemanipulationconfigurationsindexrequestindex}

<sup><sup>[↩ Parent](#corewaapservicespeccookiemanipulationconfigurationsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (ADD_IF_ABSENT = Add the cookie only if no cookie with the same name is present; OVERWRITE_IF_EXISTS_OR_ADD = Replace the cookie value if it exists, otherwise add it; OVERWRITE_IF_EXISTS = Replace the cookie value if it exists, otherwise do nothing; REMOVE = Remove all cookies with the given name; value must be omitted; MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT = For response only: do not change the cookie value but modify its attributes if it is present, value must be omitted) <br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Cookie name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulationconfigurationsindexrequestindexattributesindex">attributes</a></b></td>
        <td>[]object</td>
        <td>
          Attribute manipulation for response Set-Cookie entries (only applicable with action MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Cookie value; must be set for all actions except REMOVE and MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation.configurations[index].request[index].attributes[index] {#corewaapservicespeccookiemanipulationconfigurationsindexrequestindexattributesindex}

<sup><sup>[↩ Parent](#corewaapservicespeccookiemanipulationconfigurationsindexrequestindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (ADD_IF_ABSENT = Add the attribute only if no attribute with the same name is present; OVERWRITE_IF_EXISTS_OR_ADD = Replace the attribute value if it exists, otherwise add it; OVERWRITE_IF_EXISTS = Replace the attribute value if it exists, otherwise do nothing; REMOVE = Remove the attribute, value must be omitted) <br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Attribute name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Attribute value; must be set for all actions except REMOVE<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation.configurations[index].response[index] {#corewaapservicespeccookiemanipulationconfigurationsindexresponseindex}

<sup><sup>[↩ Parent](#corewaapservicespeccookiemanipulationconfigurationsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (ADD_IF_ABSENT = Add the cookie only if no cookie with the same name is present; OVERWRITE_IF_EXISTS_OR_ADD = Replace the cookie value if it exists, otherwise add it; OVERWRITE_IF_EXISTS = Replace the cookie value if it exists, otherwise do nothing; REMOVE = Remove all cookies with the given name; value must be omitted; MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT = For response only: do not change the cookie value but modify its attributes if it is present, value must be omitted) <br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Cookie name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccookiemanipulationconfigurationsindexresponseindexattributesindex">attributes</a></b></td>
        <td>[]object</td>
        <td>
          Attribute manipulation for response Set-Cookie entries (only applicable with action MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Cookie value; must be set for all actions except REMOVE and MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.cookieManipulation.configurations[index].response[index].attributes[index] {#corewaapservicespeccookiemanipulationconfigurationsindexresponseindexattributesindex}

<sup><sup>[↩ Parent](#corewaapservicespeccookiemanipulationconfigurationsindexresponseindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (ADD_IF_ABSENT = Add the attribute only if no attribute with the same name is present; OVERWRITE_IF_EXISTS_OR_ADD = Replace the attribute value if it exists, otherwise add it; OVERWRITE_IF_EXISTS = Replace the attribute value if it exists, otherwise do nothing; REMOVE = Remove the attribute, value must be omitted) <br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Attribute name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Attribute value; must be set for all actions except REMOVE<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza {#corewaapservicespeccoraza}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Coraza filter settings for Core Rule Set (CRS) and GraphQL validations

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespeccorazacrs">crs</a></b></td>
        <td>object</td>
        <td>
          OWASP Core Rule Set (CRS) settings<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>debugLogLevel</b></td>
        <td>integer</td>
        <td>
          Debug log level (0:off 1:error 2:warn 3:info 4-8:debug, 9:trace)  <br/>
          <br/>
            <i>Default</i>: 0<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Enables the Coraza filter; must be enabled if any CRS or GraphQL validations should be done; if set to false here (or at 'spec.routes[].coraza.enabled'), the coraza filter is not inserted globally (resp. at that route) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazagraphql">graphql</a></b></td>
        <td>object</td>
        <td>
          GraphQL settings<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>parseJson</b></td>
        <td>boolean</td>
        <td>
          Whether to apply CRS protection rules for JSON payloads or not; must be true if GraphQL is enabled on any route <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>parseXml</b></td>
        <td>boolean</td>
        <td>
          Whether to apply CRS protection rules for XML payloads or not <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestBodyAccess</b></td>
        <td>boolean</td>
        <td>
          Whether to scan request bodies or not, must be true if GraphQL is enabled on any route (if this setting is disabled, POST parameters and other content submitted in the request body will not be inspected) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestBodyLimitAction</b></td>
        <td>enum</td>
        <td>
          How to handle requests with a larger body than specified in coraza.requestBodyLimitKb; when spec.coraza.crs.mode is set to DETECT then this setting will unconditionally be changed to ProcessPartial to prevent disruptions (ProcessPartial = validate request body up to limit, let additional bytes through unchecked; Reject = reject request if body is larger than limit) <br/>
          <br/>
            <i>Enum</i>: ProcessPartial, Reject<br/>
            <i>Default</i>: Reject<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestBodyLimitKb</b></td>
        <td>integer</td>
        <td>
          Request body limit in KB, body bytes beyond the limit are not parsed (also make sure that operation.bufferLimitBytes is set accordingly) <br/>
          <br/>
            <i>Default</i>: 128<br/>
            <i>Minimum</i>: 0<br/>
            <i>Maximum</i>: 1.048576e+06<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>responseBodyAccess</b></td>
        <td>boolean</td>
        <td>
          Whether to scan response bodies or not; only allowed to set to false if coraza.crs.enabledResponseRules is empty (GraphQL does so far not parse response bodies, the backend is trusted) <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>responseBodyLimitAction</b></td>
        <td>enum</td>
        <td>
          How to handle responses with a larger body than specified in coraza.responseBodyLimitKb (ProcessPartial = validate response body up to limit, let additional bytes through unchecked; Reject = reject response if body is larger than limit) <br/>
          <br/>
            <i>Enum</i>: ProcessPartial, Reject<br/>
            <i>Default</i>: Reject<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>responseBodyLimitKb</b></td>
        <td>integer</td>
        <td>
          Response body limit in KB, body bytes beyond the limit are not parsed(also make sure that operation.bufferLimitBytes is set accordingly) <br/>
          <br/>
            <i>Default</i>: 256<br/>
            <i>Minimum</i>: 0<br/>
            <i>Maximum</i>: 1.048576e+06<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>useLibinjection</b></td>
        <td>boolean</td>
        <td>
          When enabled, coraza uses libinjection instead of the default implementation <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>useRe2</b></td>
        <td>boolean</td>
        <td>
          When enabled, coraza uses the RE2 regex engine instead of the default implementation <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>validateJson</b></td>
        <td>boolean</td>
        <td>
          DEPRECATED: Use spec.coraza.validateParsedBody instead;When enabled, only JSON bodies are validated(has no effect on graphql) <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>validateParsedBody</b></td>
        <td>boolean</td>
        <td>
          Enables body validation after parsing(if the syntax is invalid and the current mode is BLOCK, such requests are blocked); if set to true, across all routes with effectively enabled CRS and/or GraphQL only either mode BLOCK or DETECT must be used <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs {#corewaapservicespeccorazacrs}

<sup><sup>[↩ Parent](#corewaapservicespeccoraza)</sup></sup>

OWASP Core Rule Set (CRS) settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespeccorazacrscustomrequestblockingrulesindex">customRequestBlockingRules</a></b></td>
        <td>[]object</td>
        <td>
          Custom request blocking rules<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>defaultEnabled</b></td>
        <td>boolean</td>
        <td>
          If true enabled on all routes unless disabled there, if false disabled on all routes unless enabled there (note that if disabled here (or on a route) but Coraza is enabled globally or on a route, the Coraza filter will still be inserted, but it will not perform any of the validations defined here at 'spec.coraza.crs'; this is so because GraphQL might be active, which also requires the Coraza filter) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabledRequestRules</b></td>
        <td>[]enum</td>
        <td>
          Set of request rule classes (default is to include all rules, rules REQUEST_901_INITIALIZATION and REQUEST_949_BLOCKING_EVALUATION are always included, see https://github.com/coreruleset/coreruleset/tree/v4.25.1/rules for all configurable values, just replace '-' by '_' and omit '.conf')<br/>
          <br/>
            <i>Enum</i>: REQUEST_913_SCANNER_DETECTION, REQUEST_920_PROTOCOL_ENFORCEMENT, REQUEST_921_PROTOCOL_ATTACK, REQUEST_922_MULTIPART_ATTACK, REQUEST_930_APPLICATION_ATTACK_LFI, REQUEST_931_APPLICATION_ATTACK_RFI, REQUEST_932_APPLICATION_ATTACK_RCE, REQUEST_933_APPLICATION_ATTACK_PHP, REQUEST_934_APPLICATION_ATTACK_GENERIC, REQUEST_941_APPLICATION_ATTACK_XSS, REQUEST_942_APPLICATION_ATTACK_SQLI, REQUEST_943_APPLICATION_ATTACK_SESSION_FIXATION, REQUEST_944_APPLICATION_ATTACK_JAVA<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabledResponseRules</b></td>
        <td>[]enum</td>
        <td>
          Set of response rule classes (default is to include no rules, rules RESPONSE_959_BLOCKING_EVALUATION and RESPONSE_980_CORRELATION are always included, see https://github.com/coreruleset/coreruleset/tree/v4.25.1/rules for all configurable values, just replace '-' by '_' and omit '.conf')<br/>
          <br/>
            <i>Enum</i>: RESPONSE_950_DATA_LEAKAGES, RESPONSE_951_DATA_LEAKAGES_SQL, RESPONSE_952_DATA_LEAKAGES_JAVA, RESPONSE_953_DATA_LEAKAGES_PHP, RESPONSE_954_DATA_LEAKAGES_IIS, RESPONSE_955_WEB_SHELLS, RESPONSE_956_DATA_LEAKAGES_RUBY<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mode</b></td>
        <td>enum</td>
        <td>
          Mode (DETECT = traffic identified as suspicious is logged but not blocked; BLOCK = traffic identified as suspicious is blocked) <br/>
          <br/>
            <i>Enum</i>: BLOCK, DETECT<br/>
            <i>Default</i>: BLOCK<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazacrsociimagesource">ociImageSource</a></b></td>
        <td>object</td>
        <td>
          Optional OCI image source of the CRS rules that will be used; by default the hard-coded CRS rules of version4.25.1 are used; requires Kubernetes >= 1.36<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>paranoiaLevel</b></td>
        <td>integer</td>
        <td>
          Paranoia level (the higher the level the better the protection but also more likely false positives, see OWASP CRS for details) <br/>
          <br/>
            <i>Default</i>: 1<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 4<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazacrsrequestruleexceptionsindex">requestRuleExceptions</a></b></td>
        <td>[]object</td>
        <td>
          Conditionally disable request rules to avoid false positive alerts/blocks<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazacrsresponseruleexceptionsindex">responseRuleExceptions</a></b></td>
        <td>[]object</td>
        <td>
          Conditionally disable response rules to avoid false positive alerts/blocks<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>securityLevel</b></td>
        <td>integer</td>
        <td>
          Defines under which conditions suspicious requests are blocked; only has an effect if the mode is set to BLOCK (security level 5 blocks already if 1 (or more) critical anomalies, 4 if 2, 3 if 3, 2 if 5, 1 if 10) <br/>
          <br/>
            <i>Default</i>: 5<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 5<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.customRequestBlockingRules[index] {#corewaapservicespeccorazacrscustomrequestblockingrulesindex}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrs)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Rule name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>secLangExpression</b></td>
        <td>string</td>
        <td>
          SecLang expression. Rule id range must be [300000,399999] <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.ociImageSource {#corewaapservicespeccorazacrsociimagesource}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrs)</sup></sup>

Optional OCI image source of the CRS rules that will be used; by default the hard-coded CRS rules of version4.25.1 are used; requires Kubernetes >= 1.36

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>reference</b></td>
        <td>string</td>
        <td>
          OCI image reference containing the CRS rules, e.g. 'registry.example.com/crs/usp-core-waap-crs:4.27.0' <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>pullPolicy</b></td>
        <td>string</td>
        <td>
          Image pull policy for the OCI volume <br/>
          <br/>
            <i>Default</i>: IfNotPresent<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.requestRuleExceptions[index] {#corewaapservicespeccorazacrsrequestruleexceptionsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrs)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>location</b></td>
        <td>string</td>
        <td>
          Location<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazacrsrequestruleexceptionsindexmetadata">metadata</a></b></td>
        <td>object</td>
        <td>
          Metadata (no impact on native config)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>regEx</b></td>
        <td>boolean</td>
        <td>
          Whether the location is indicated as a regex or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartName</b></td>
        <td>string</td>
        <td>
          Request part name (e.g. 'User-Agent'; only has an effect if request rule exception)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartType</b></td>
        <td>enum</td>
        <td>
          Request part type (only has an effect if request rule exception)<br/>
          <br/>
            <i>Enum</i>: ARGS, ARGS_COMBINED_SIZE, ARGS_GET, ARGS_GET_NAMES, ARGS_NAMES, ARGS_POST, ARGS_POST_NAMES, AUTH_TYPE, DURATION, ENV, FILES, FILES_COMBINED_SIZE, FILES_NAMES, FILES_SIZES, FILES_TMPNAMES, FILES_TMP_CONTENT, FULL_REQUEST, FULL_REQUEST_LENGTH, GEO, HIGHEST_SEVERITY, INBOUND_DATA_ERROR, MATCHED_VAR, MATCHED_VARS, MATCHED_VARS_NAMES, MATCHED_VAR_NAME, MODSEC_BUILD, MULTIPART_CRLF_LF_LINES, MULTIPART_FILENAME, MULTIPART_NAME, MULTIPART_PART_HEADERS, MULTIPART_STRICT_ERROR, MULTIPART_UNMATCHED_BOUNDARY, OUTBOUND_DATA_ERROR, PATH_INFO, PERF_COMBINED, PERF_GC, PERF_LOGGING, PERF_PHASE1, PERF_PHASE2, PERF_PHASE3, PERF_PHASE4, PERF_PHASE5, PERF_RULES, PERF_SREAD, PERF_SWRITE, QUERY_STRING, REMOTE_ADDR, REMOTE_HOST, REMOTE_PORT, REMOTE_USER, REQBODY_ERROR, REQBODY_ERROR_MSG, REQBODY_PROCESSOR, REQUEST_BASENAME, REQUEST_BODY, REQUEST_BODY_LENGTH, REQUEST_COOKIES, REQUEST_COOKIES_NAMES, REQUEST_FILENAME, REQUEST_HEADERS, REQUEST_HEADERS_NAMES, REQUEST_LINE, REQUEST_METHOD, REQUEST_PROTOCOL, REQUEST_URI, REQUEST_URI_RAW, RESPONSE_BODY, RESPONSE_CONTENT_LENGTH, RESPONSE_CONTENT_TYPE, RESPONSE_HEADERS, RESPONSE_HEADERS_NAMES, RESPONSE_PROTOCOL, RESPONSE_STATUS, RULE, SCRIPT_BASENAME, SCRIPT_FILENAME, SCRIPT_GID, SCRIPT_GROUPNAME, SCRIPT_MODE, SCRIPT_UID, SCRIPT_USERNAME, SDBM_DELETE_ERROR, SERVER_ADDR, SERVER_NAME, SERVER_PORT, SESSION, SESSIONID, STREAM_INPUT_BODY, STREAM_OUTPUT_BODY, TIME, TIME_DAY, TIME_EPOCH, TIME_HOUR, TIME_MIN, TIME_MON, TIME_SEC, TIME_WDAY, TIME_YEAR, TX, UNIQUE_ID, URLENCODED_ERROR, USERAGENT_IP, USERID, WEBAPPID, WEBSERVER_ERROR_LOG, XML<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>ruleId</b></td>
        <td>integer</td>
        <td>
          (deprecated, use ruleIds instead) Rule ID<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>ruleIds</b></td>
        <td>[]integer</td>
        <td>
          A list of Rule IDs (required if ruleId is not specified and must then contain at least one rule ID) <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.requestRuleExceptions[index].metadata {#corewaapservicespeccorazacrsrequestruleexceptionsindexmetadata}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrsrequestruleexceptionsindex)</sup></sup>

Metadata (no impact on native config)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>comment</b></td>
        <td>string</td>
        <td>
          Comment why the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>createdBy</b></td>
        <td>string</td>
        <td>
          By whom the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>date</b></td>
        <td>string</td>
        <td>
          Date when the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.responseRuleExceptions[index] {#corewaapservicespeccorazacrsresponseruleexceptionsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrs)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>location</b></td>
        <td>string</td>
        <td>
          Location<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazacrsresponseruleexceptionsindexmetadata">metadata</a></b></td>
        <td>object</td>
        <td>
          Metadata (no impact on native config)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>regEx</b></td>
        <td>boolean</td>
        <td>
          Whether the location is indicated as a regex or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartName</b></td>
        <td>string</td>
        <td>
          Request part name (e.g. 'User-Agent'; only has an effect if request rule exception)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartType</b></td>
        <td>enum</td>
        <td>
          Request part type (only has an effect if request rule exception)<br/>
          <br/>
            <i>Enum</i>: ARGS, ARGS_COMBINED_SIZE, ARGS_GET, ARGS_GET_NAMES, ARGS_NAMES, ARGS_POST, ARGS_POST_NAMES, AUTH_TYPE, DURATION, ENV, FILES, FILES_COMBINED_SIZE, FILES_NAMES, FILES_SIZES, FILES_TMPNAMES, FILES_TMP_CONTENT, FULL_REQUEST, FULL_REQUEST_LENGTH, GEO, HIGHEST_SEVERITY, INBOUND_DATA_ERROR, MATCHED_VAR, MATCHED_VARS, MATCHED_VARS_NAMES, MATCHED_VAR_NAME, MODSEC_BUILD, MULTIPART_CRLF_LF_LINES, MULTIPART_FILENAME, MULTIPART_NAME, MULTIPART_PART_HEADERS, MULTIPART_STRICT_ERROR, MULTIPART_UNMATCHED_BOUNDARY, OUTBOUND_DATA_ERROR, PATH_INFO, PERF_COMBINED, PERF_GC, PERF_LOGGING, PERF_PHASE1, PERF_PHASE2, PERF_PHASE3, PERF_PHASE4, PERF_PHASE5, PERF_RULES, PERF_SREAD, PERF_SWRITE, QUERY_STRING, REMOTE_ADDR, REMOTE_HOST, REMOTE_PORT, REMOTE_USER, REQBODY_ERROR, REQBODY_ERROR_MSG, REQBODY_PROCESSOR, REQUEST_BASENAME, REQUEST_BODY, REQUEST_BODY_LENGTH, REQUEST_COOKIES, REQUEST_COOKIES_NAMES, REQUEST_FILENAME, REQUEST_HEADERS, REQUEST_HEADERS_NAMES, REQUEST_LINE, REQUEST_METHOD, REQUEST_PROTOCOL, REQUEST_URI, REQUEST_URI_RAW, RESPONSE_BODY, RESPONSE_CONTENT_LENGTH, RESPONSE_CONTENT_TYPE, RESPONSE_HEADERS, RESPONSE_HEADERS_NAMES, RESPONSE_PROTOCOL, RESPONSE_STATUS, RULE, SCRIPT_BASENAME, SCRIPT_FILENAME, SCRIPT_GID, SCRIPT_GROUPNAME, SCRIPT_MODE, SCRIPT_UID, SCRIPT_USERNAME, SDBM_DELETE_ERROR, SERVER_ADDR, SERVER_NAME, SERVER_PORT, SESSION, SESSIONID, STREAM_INPUT_BODY, STREAM_OUTPUT_BODY, TIME, TIME_DAY, TIME_EPOCH, TIME_HOUR, TIME_MIN, TIME_MON, TIME_SEC, TIME_WDAY, TIME_YEAR, TX, UNIQUE_ID, URLENCODED_ERROR, USERAGENT_IP, USERID, WEBAPPID, WEBSERVER_ERROR_LOG, XML<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>ruleId</b></td>
        <td>integer</td>
        <td>
          (deprecated, use ruleIds instead) Rule ID<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>ruleIds</b></td>
        <td>[]integer</td>
        <td>
          A list of Rule IDs (required if ruleId is not specified and must then contain at least one rule ID) <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.crs.responseRuleExceptions[index].metadata {#corewaapservicespeccorazacrsresponseruleexceptionsindexmetadata}

<sup><sup>[↩ Parent](#corewaapservicespeccorazacrsresponseruleexceptionsindex)</sup></sup>

Metadata (no impact on native config)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>comment</b></td>
        <td>string</td>
        <td>
          Comment why the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>createdBy</b></td>
        <td>string</td>
        <td>
          By whom the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>date</b></td>
        <td>string</td>
        <td>
          Date when the rule exception was added<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.graphql {#corewaapservicespeccorazagraphql}

<sup><sup>[↩ Parent](#corewaapservicespeccoraza)</sup></sup>

GraphQL settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespeccorazagraphqlconfigsindex">configs</a></b></td>
        <td>[]object</td>
        <td>
          Config settings for referencing by name on individual routes<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.graphql.configs[index] {#corewaapservicespeccorazagraphqlconfigsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccorazagraphql)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>allowIntrospection</b></td>
        <td>boolean</td>
        <td>
          Whether to allow introspection calls (these could help an attacker, while some use cases need access) <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazagraphqlconfigsindexociimagesource">ociImageSource</a></b></td>
        <td>object</td>
        <td>
          OCI image source for the GraphQL schema; exactly one of schemaSource or ociImageSource must be set; requires Kubernetes >= 1.36<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazagraphqlconfigsindexquerythresholds">queryThresholds</a></b></td>
        <td>object</td>
        <td>
          Thresholds for queries (e.g. nesting depth)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccorazagraphqlconfigsindexschemasource">schemaSource</a></b></td>
        <td>object</td>
        <td>
          ConfigMap source for the GraphQL schema; exactly one of schemaSource or ociImageSource must be set<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.graphql.configs[index].ociImageSource {#corewaapservicespeccorazagraphqlconfigsindexociimagesource}

<sup><sup>[↩ Parent](#corewaapservicespeccorazagraphqlconfigsindex)</sup></sup>

OCI image source for the GraphQL schema; exactly one of schemaSource or ociImageSource must be set; requires Kubernetes >= 1.36

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>filePath</b></td>
        <td>string</td>
        <td>
          Path to the schema file within the OCI image filesystem, e.g. 'schemas/petstore.yaml' <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>reference</b></td>
        <td>string</td>
        <td>
          OCI image reference containing the schema file, e.g. 'registry.example.com/schemas/my-api:v1.0' <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>pullPolicy</b></td>
        <td>enum</td>
        <td>
          Image pull policy for the OCI volume <br/>
          <br/>
            <i>Enum</i>: Always, IfNotPresent, Never<br/>
            <i>Default</i>: IfNotPresent<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.graphql.configs[index].queryThresholds {#corewaapservicespeccorazagraphqlconfigsindexquerythresholds}

<sup><sup>[↩ Parent](#corewaapservicespeccorazagraphqlconfigsindex)</sup></sup>

Thresholds for queries (e.g. nesting depth)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>batchSize</b></td>
        <td>integer</td>
        <td>
          Maximum batch size to allow <br/>
          <br/>
            <i>Default</i>: 5<br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>complexity</b></td>
        <td>integer</td>
        <td>
          Maximum complexity to allow <br/>
          <br/>
            <i>Default</i>: 20<br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>depth</b></td>
        <td>integer</td>
        <td>
          Maximum nesting depth to allow <br/>
          <br/>
            <i>Default</i>: 5<br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.coraza.graphql.configs[index].schemaSource {#corewaapservicespeccorazagraphqlconfigsindexschemasource}

<sup><sup>[↩ Parent](#corewaapservicespeccorazagraphqlconfigsindex)</sup></sup>

ConfigMap source for the GraphQL schema; exactly one of schemaSource or ociImageSource must be set

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>configMap</b></td>
        <td>string</td>
        <td>
          Name of the config map that contains the file <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key in the config map that contains the file, and also the name of the file <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.corsPolicy {#corewaapservicespeccorspolicy}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Global CORS protection (default off); any legal OPTIONS requests will be responded to directly by Core WAAP and will not be passed on to backends; other requests will not be responded to directly, but if they are accepted CORS requests that match configured allowed origins, Core WAAP will add the related headers to the response

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>allowedOrigins</b></td>
        <td>[]string</td>
        <td>
          Allowed origins, specified as '{hostname}[:{port}]' (no scheme!); must correspond to the request target. <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>allowCredentials</b></td>
        <td>boolean</td>
        <td>
          Specifies whether the resource allows credentials.  <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>allowHeaders</b></td>
        <td>string</td>
        <td>
          Specifies the content for the "access-control-allow-headers" header.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>allowMethods</b></td>
        <td>string</td>
        <td>
          Specifies the content for the "access-control-allow-methods" header.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>allowPrivateNetworkAccess</b></td>
        <td>boolean</td>
        <td>
          Specify whether allow requests whose target server's IP address is more private than that from which the request initiator was fetched. <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether the filter should be enforced or not. <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>exposeHeaders</b></td>
        <td>string</td>
        <td>
          Specifies the content for the "access-control-expose-headers" header.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>forwardNotMatchingPreflights</b></td>
        <td>boolean</td>
        <td>
          Specifies if preflight requests not matching the configured allowed origin should be forwarded to the upstream. <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>maxAge</b></td>
        <td>string</td>
        <td>
          Specifies the content for the "access-control-max-age" header.<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.csrfPolicy {#corewaapservicespeccsrfpolicy}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Global CSRF protection (default on); detects and blocks CSRF attacks based on comparing the request origin (either 'Origin' or 'Referrer' header) with the request target; if the origin does not match the target and is not allowed specifically, the request will be blocked

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>additionalOrigins</b></td>
        <td>[]string</td>
        <td>
          Additional allowed origin values, specified as '{hostname}[:{port}]' (no scheme!); must correspond to the request target.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether CSRF protection is enabled or not <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter {#corewaapservicespecheaderfilter}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Header filter settings; active by default with default sets of allowed request and response headers

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>defaultFilterRef</b></td>
        <td>string</td>
        <td>
          Optional reference to a default header filter applied to all routes; if not set, the implicit default applied to all routes is to filter request headers with the set of headers from the allowClass STANDARD and to filter response headers with the default set of allowed headers; the default filter can be selectively overridden per route; please consult the documentation for details on filter operation and merge behavior<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilterfiltersindex">filters</a></b></td>
        <td>[]object</td>
        <td>
          List of reusable header filter definitions; these filters can be referenced either as the global default filter or on individual routes; when a filter is referenced on a route, its settings are merged with the implicit or explicit default; please consult the documentation for details on filter operation and merge behavior<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter.filters[index] {#corewaapservicespecheaderfilterfiltersindex}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilter)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name that can be used to reference this filter, either as the global default filter or for a per-route filter <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>logOnly</b></td>
        <td>boolean</td>
        <td>
          Whether to only log the headers that would be blocked; defaults to false if not set at the default or per-route level<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilterfiltersindexrequest">request</a></b></td>
        <td>object</td>
        <td>
          Request header filtering<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilterfiltersindexresponse">response</a></b></td>
        <td>object</td>
        <td>
          Response header filtering<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter.filters[index].request {#corewaapservicespecheaderfilterfiltersindexrequest}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilterfiltersindex)</sup></sup>

Request header filtering

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>allow</b></td>
        <td>[]string</td>
        <td>
          Header names to additionally allow; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>allowClass</b></td>
        <td>enum</td>
        <td>
          A common preset of allowed headers (STANDARD, RESTRICTED or EXTENDED); defaults to STANDARD if not set at the default or per-route level; MINIMAL is DEPRECATED: it was removed and RESTRICTED is used instead; see the documentation for merge behavior and interplay with other settings here, as well as for which headers are in each common preset<br/>
          <br/>
            <i>Enum</i>: EXTENDED, MINIMAL, RESTRICTED, STANDARD<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>deny</b></td>
        <td>[]string</td>
        <td>
          Header names to additionally deny; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilterfiltersindexrequestdenypatternsindex">denyPatterns</a></b></td>
        <td>[]object</td>
        <td>
          Headers to deny if their value matches the configured regex pattern; each header name may only appear once (including '*'); defaults to an empty list if not set at the default or per-route level; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether request header filtering is enabled; defaults to true if not set at the default or per-route level<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter.filters[index].request.denyPatterns[index] {#corewaapservicespecheaderfilterfiltersindexrequestdenypatternsindex}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilterfiltersindexrequest)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Header name or '*' to match all headers (must be case-insensitively unique in list) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>pattern</b></td>
        <td>string</td>
        <td>
          Regex pattern to match header value <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter.filters[index].response {#corewaapservicespecheaderfilterfiltersindexresponse}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilterfiltersindex)</sup></sup>

Response header filtering

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>allow</b></td>
        <td>[]string</td>
        <td>
          Header names to additionally allow; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>deny</b></td>
        <td>[]string</td>
        <td>
          Header names to additionally deny; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilterfiltersindexresponsedenypatternsindex">denyPatterns</a></b></td>
        <td>[]object</td>
        <td>
          Headers to deny if their value matches the configured regex pattern; each header name may only appear once (including '*'); defaults to an empty list if not set at the default or per-route level; see the documentation for merge behavior and interplay with other settings here<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether response header filtering is enabled; defaults to true if not set at the default or per-route level<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFilter.filters[index].response.denyPatterns[index] {#corewaapservicespecheaderfilterfiltersindexresponsedenypatternsindex}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilterfiltersindexresponse)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Header name or '*' to match all headers (must be case-insensitively unique in list) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>pattern</b></td>
        <td>string</td>
        <td>
          Regex pattern to match header value <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerManipulation {#corewaapservicespecheadermanipulation}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Header manipulation settings; by default no header manipulation is done

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecheadermanipulationconfigurationsindex">configurations</a></b></td>
        <td>[]object</td>
        <td>
          List of reusable header manipulation configurations; these configurations can be referenced on individual routes<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerManipulation.configurations[index] {#corewaapservicespecheadermanipulationconfigurationsindex}

<sup><sup>[↩ Parent](#corewaapservicespecheadermanipulation)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name that can be used to reference this configuration <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheadermanipulationconfigurationsindexrequestindex">request</a></b></td>
        <td>[]object</td>
        <td>
          Request header manipulation configuration<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheadermanipulationconfigurationsindexresponseindex">response</a></b></td>
        <td>[]object</td>
        <td>
          Response header manipulation configuration<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerManipulation.configurations[index].request[index] {#corewaapservicespecheadermanipulationconfigurationsindexrequestindex}

<sup><sup>[↩ Parent](#corewaapservicespecheadermanipulationconfigurationsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (APPEND_IF_EXISTS_OR_ADD = Search for the specified header and append the value if it exists, or add it with the specified value if it does not exist; ADD_IF_ABSENT = Add header with specified value only if it does not exist yet, this action will not do anything if the header already exists; OVERWRITE_IF_EXISTS = Search for the specified header and replace its value, this action will not do anything if the header does not exist; OVERWRITE_IF_EXISTS_OR_ADD = Search for the specified header and replace its value, or add it with the specified value if it does not existREMOVE = Search for the specified header and remove it, this action will not do anything if the header does not exist)<br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, APPEND_IF_EXISTS_OR_ADD, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Header name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Header value;must be defined for all actions except REMOVE<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerManipulation.configurations[index].response[index] {#corewaapservicespecheadermanipulationconfigurationsindexresponseindex}

<sup><sup>[↩ Parent](#corewaapservicespecheadermanipulationconfigurationsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>action</b></td>
        <td>enum</td>
        <td>
          Action (APPEND_IF_EXISTS_OR_ADD = Search for the specified header and append the value if it exists, or add it with the specified value if it does not exist; ADD_IF_ABSENT = Add header with specified value only if it does not exist yet, this action will not do anything if the header already exists; OVERWRITE_IF_EXISTS = Search for the specified header and replace its value, this action will not do anything if the header does not exist; OVERWRITE_IF_EXISTS_OR_ADD = Search for the specified header and replace its value, or add it with the specified value if it does not existREMOVE = Search for the specified header and remove it, this action will not do anything if the header does not exist)<br/>
          <br/>
            <i>Enum</i>: ADD_IF_ABSENT, APPEND_IF_EXISTS_OR_ADD, OVERWRITE_IF_EXISTS, OVERWRITE_IF_EXISTS_OR_ADD, REMOVE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Header name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Header value;must be defined for all actions except REMOVE<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.icap[index] {#corewaapservicespecicapindex}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes under icapRefs <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>url</b></td>
        <td>string</td>
        <td>
          ICAP URL including protocol and port (e.g. 'icap://some.host:1344/some/path', use 'icaps://' for TLS)  <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>debug</b></td>
        <td>boolean</td>
        <td>
          Enables ICAP client internal debug logs <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>icapHeaders</b></td>
        <td>[]string</td>
        <td>
          Additional ICAP headers; each entry parsed as "Key: Value" (value optional) <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>timeoutSecs</b></td>
        <td>integer</td>
        <td>
          ICAP client socket timeout in seconds (applies to OPTIONS and REQMOD) <br/>
          <br/>
            <i>Default</i>: 10<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.lua {#corewaapservicespeclua}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Lua filters settings (filter scripts plus helper scripts/files)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>configMap</b></td>
        <td>string</td>
        <td>
          Name of the config map that contains the Lua filter scripts and helper files (must be defined if any Lua filters or helper files are defined)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecluafiltersindex">filters</a></b></td>
        <td>[]object</td>
        <td>
          Lua filter scripts; will be run in the order listed here if referenced in routes <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecluahelpersindex">helpers</a></b></td>
        <td>[]object</td>
        <td>
          Helper files that will be mounted in parallel to the Lua filter scripts; usually Lua utility scripts, but can be any file type <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.lua.filters[index] {#corewaapservicespecluafiltersindex}

<sup><sup>[↩ Parent](#corewaapservicespeclua)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Script name used both to reference in routes and as mounted filename and also the key in the 'spec.lua.configMap', must end with '.lua' <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.lua.helpers[index] {#corewaapservicespecluahelpersindex}

<sup><sup>[↩ Parent](#corewaapservicespeclua)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name of file to mount in parallel to Lua filter scripts and also the key in the 'spec.lua.configMap' <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.openapi[index] {#corewaapservicespecopenapiindex}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes under openapiRefs <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecopenapiindexociimagesource">ociImageSource</a></b></td>
        <td>object</td>
        <td>
          OCI image source of the schema that will be used for validation; exactly one of schemaSource or ociImageSource must be set; requires Kubernetes >= 1.36<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecopenapiindexschemasource">schemaSource</a></b></td>
        <td>object</td>
        <td>
          ConfigMap source of the schema that will be used for validation; exactly one of schemaSource or ociImageSource must be set<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecopenapiindexscope">scope</a></b></td>
        <td>object</td>
        <td>
          Validation scope settings<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.openapi[index].ociImageSource {#corewaapservicespecopenapiindexociimagesource}

<sup><sup>[↩ Parent](#corewaapservicespecopenapiindex)</sup></sup>

OCI image source of the schema that will be used for validation; exactly one of schemaSource or ociImageSource must be set; requires Kubernetes >= 1.36

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>filePath</b></td>
        <td>string</td>
        <td>
          Path to the schema file within the OCI image filesystem, e.g. 'schemas/petstore.yaml' <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>reference</b></td>
        <td>string</td>
        <td>
          OCI image reference containing the schema file, e.g. 'registry.example.com/schemas/my-api:v1.0' <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>pullPolicy</b></td>
        <td>enum</td>
        <td>
          Image pull policy for the OCI volume <br/>
          <br/>
            <i>Enum</i>: Always, IfNotPresent, Never<br/>
            <i>Default</i>: IfNotPresent<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.openapi[index].schemaSource {#corewaapservicespecopenapiindexschemasource}

<sup><sup>[↩ Parent](#corewaapservicespecopenapiindex)</sup></sup>

ConfigMap source of the schema that will be used for validation; exactly one of schemaSource or ociImageSource must be set

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>configMap</b></td>
        <td>string</td>
        <td>
          Name of the config map that contains the file <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key in the config map that contains the file, and also the name of the file <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.openapi[index].scope {#corewaapservicespecopenapiindexscope}

<sup><sup>[↩ Parent](#corewaapservicespecopenapiindex)</sup></sup>

Validation scope settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>mode</b></td>
        <td>enum</td>
        <td>
          Whether to block when validation fails (BLOCK) or to only log (DETECT) <br/>
          <br/>
            <i>Enum</i>: BLOCK, DETECT<br/>
            <i>Default</i>: BLOCK<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestBody</b></td>
        <td>boolean</td>
        <td>
          Indicates that request body will be validated <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>responseBody</b></td>
        <td>boolean</td>
        <td>
          Indicates that response body will be validated <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation {#corewaapservicespecoperation}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Operation related settings to be used for the Core WAAP Kubernetes deployment; these settings typically do not affect generated Envoy config (optional, except that the operation's image/version fields must be set in the spec or via default in the operator config) [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec, e.g. resources.limits.cpu could be defined in operator config but resources.requests.cpu in the spec; exception: lists within the config tree are completely overridden by the ones in the spec if present, which affects e.g. tolerations and lists under affinity]

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationadmininterfaceservice">adminInterfaceService</a></b></td>
        <td>object</td>
        <td>
          Settings for exposing the Envoy admin interface as a Kubernetes service<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinity">affinity</a></b></td>
        <td>object</td>
        <td>
          Kubernetes affinity for the Core Waap pod<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationauth">auth</a></b></td>
        <td>object</td>
        <td>
          Settings related to OAuth2/OpenID Connect<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>bufferLimitBytes</b></td>
        <td>integer</td>
        <td>
          Maximum body size for processing requests and responses (Envoy's perConnectionBufferLimitBytes on listener; also make sure that Coraza body limits are set accordingly) <br/>
          <br/>
            <i>Default</i>: 1048576<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 4.294967295e+09<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationcacertificates">caCertificates</a></b></td>
        <td>object</td>
        <td>
          CA Certificates for the pod, mounted at /etc/ssl/certs/ca-certificates.crt (default is to use the file from container)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>debug</b></td>
        <td>boolean</td>
        <td>
          Use the debug container image;intended for development and troubleshooting only; <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>image</b></td>
        <td>string</td>
        <td>
          Core WAAP container image (host+path+name) without version, e.g. 'uspregistry.azurecr.io/usp/core/waap/usp-core-waap' (must be defined either in spec or operator defaults) (DEPRECATED: for backwards compatibility, it is currently still allowed to append a version with ':' and omit a separate version field, but this is deprecated and existing config should be migrated)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>imagePullSecret</b></td>
        <td>string</td>
        <td>
          Name of the Kubernetes secret used to pull the Core WAAP container image; sets imagePullSecrets on the pod template<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>labels</b></td>
        <td>map[string]string</td>
        <td>
          Map of key/value labels for the pod<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationmetrics">metrics</a></b></td>
        <td>object</td>
        <td>
          Settings for exposing Metrics endpoint as a Kubernetes service<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>port</b></td>
        <td>integer</td>
        <td>
          Port of the Kubernetes service and Envoy listener in the Core WAAP container <br/>
          <br/>
            <i>Default</i>: 8080<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 65535<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>priorityClassName</b></td>
        <td>string</td>
        <td>
          Kubernetes priorityClassName for the Core Waap pod<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>replicas</b></td>
        <td>integer</td>
        <td>
          Number of replicas (default is not managed by operator) <br/>
          <br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationresources">resources</a></b></td>
        <td>object</td>
        <td>
          Kubernetes resources for the Core Waap pod<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontext">securityContext</a></b></td>
        <td>object</td>
        <td>
          Kubernetes securityContext for the Core Waap container<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationserviceaccount">serviceAccount</a></b></td>
        <td>object</td>
        <td>
          Service account<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>serviceAnnotations</b></td>
        <td>map[string]string</td>
        <td>
          Map of key/value annotations for the service<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationstartup">startup</a></b></td>
        <td>object</td>
        <td>
          Settings for Envoy startup (mostly command line options, see https://www.envoyproxy.io/docs/envoy/latest/operations/cli)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationtolerationsindex">tolerations</a></b></td>
        <td>[]object</td>
        <td>
          Kubernetes tolerations for the Core Waap pod<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>version</b></td>
        <td>string</td>
        <td>
          Core WAAP container (image) version, e.g. '1.1.5' (must be defined either in spec or operator defaults)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>xffNumTrustedHops</b></td>
        <td>integer</td>
        <td>
          The number of proxy hops in front of the Core WAAP to trust, i.e. the number of proxies from the right side of the X-Forwarded-For HTTP header to trust when determining the origin client’s IP address <br/>
          <br/>
            <i>Default</i>: 0<br/>
            <i>Minimum</i>: 0<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.adminInterfaceService {#corewaapservicespecoperationadmininterfaceservice}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Settings for exposing the Envoy admin interface as a Kubernetes service

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether the Envoy admin interface should be exposed as Kubernetes service <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>port</b></td>
        <td>integer</td>
        <td>
          Port of the Kubernetes service (if enabled) and Envoy admin interface listener in the Core WAAP container <br/>
          <br/>
            <i>Default</i>: 9901<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 65535<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity {#corewaapservicespecoperationaffinity}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Kubernetes affinity for the Core Waap pod

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinity">nodeAffinity</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinity">podAffinity</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinity">podAntiAffinity</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity {#corewaapservicespecoperationaffinitynodeaffinity}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindex">preferredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecution">requiredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[index] {#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreference">preference</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>weight</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].preference {#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreference}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreferencematchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreferencematchfieldsindex">matchFields</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].preference.matchExpressions[index] {#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreferencematchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreference)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].preference.matchFields[index] {#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreferencematchfieldsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinitypreferredduringschedulingignoredduringexecutionindexpreference)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution {#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecution}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindex">nodeSelectorTerms</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[index] {#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecution)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindexmatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindexmatchfieldsindex">matchFields</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[index].matchExpressions[index] {#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindexmatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[index].matchFields[index] {#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindexmatchfieldsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitynodeaffinityrequiredduringschedulingignoredduringexecutionnodeselectortermsindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity {#corewaapservicespecoperationaffinitypodaffinity}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindex">preferredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindex">requiredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index] {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm">podAffinityTerm</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>weight</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector">labelSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mismatchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector">namespaceSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>namespaces</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>topologyKey</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.labelSelector {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.labelSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.namespaceSelector {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.namespaceSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[index] {#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector">labelSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mismatchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector">namespaceSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>namespaces</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>topologyKey</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].labelSelector {#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexlabelselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].labelSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexlabelselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].namespaceSelector {#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].namespaceSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity {#corewaapservicespecoperationaffinitypodantiaffinity}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindex">preferredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindex">requiredDuringSchedulingIgnoredDuringExecution</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index] {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm">podAffinityTerm</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>weight</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector">labelSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mismatchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector">namespaceSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>namespaces</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>topologyKey</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.labelSelector {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.labelSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermlabelselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.namespaceSelector {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinityterm)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[index].podAffinityTerm.namespaceSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinitypreferredduringschedulingignoredduringexecutionindexpodaffinitytermnamespaceselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[index] {#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinity)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector">labelSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mismatchLabelKeys</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector">namespaceSelector</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>namespaces</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>topologyKey</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].labelSelector {#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexlabelselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].labelSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexlabelselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexlabelselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].namespaceSelector {#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindex)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselectormatchexpressionsindex">matchExpressions</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>matchLabels</b></td>
        <td>map[string]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[index].namespaceSelector.matchExpressions[index] {#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselectormatchexpressionsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationaffinitypodantiaffinityrequiredduringschedulingignoredduringexecutionindexnamespaceselector)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>values</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.auth {#corewaapservicespecoperationauth}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Settings related to OAuth2/OpenID Connect

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>tokenEncryption</b></td>
        <td>boolean</td>
        <td>
          Whether to encrypt OAuth2/OpenID Connect tokens in session cookies or not (normally only turned off temporarily for integration or analysis of issues; logs a warning if set to false to help prevent accidental deactivation) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.caCertificates {#corewaapservicespecoperationcacertificates}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

CA Certificates for the pod, mounted at /etc/ssl/certs/ca-certificates.crt (default is to use the file from container)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>configMap</b></td>
        <td>string</td>
        <td>
          Name of the config map that contains the CA certificates <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key (as in 'YAML key/value pair') in the config map that contains the CA certificates <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.metrics {#corewaapservicespecoperationmetrics}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Settings for exposing Metrics endpoint as a Kubernetes service

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether to expose metrics or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>port</b></td>
        <td>integer</td>
        <td>
          Port of the metrics Kubernetes service <br/>
          <br/>
            <i>Default</i>: 9801<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 65535<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.resources {#corewaapservicespecoperationresources}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Kubernetes resources for the Core Waap pod

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecoperationresourcesclaimsindex">claims</a></b></td>
        <td>[]object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>limits</b></td>
        <td>map[string]int or string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requests</b></td>
        <td>map[string]int or string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.resources.claims[index] {#corewaapservicespecoperationresourcesclaimsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationresources)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>request</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext {#corewaapservicespecoperationsecuritycontext}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Kubernetes securityContext for the Core Waap container

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>allowPrivilegeEscalation</b></td>
        <td>boolean</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontextapparmorprofile">appArmorProfile</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontextcapabilities">capabilities</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>privileged</b></td>
        <td>boolean</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>procMount</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>readOnlyRootFilesystem</b></td>
        <td>boolean</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>runAsGroup</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>runAsNonRoot</b></td>
        <td>boolean</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>runAsUser</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontextselinuxoptions">seLinuxOptions</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontextseccompprofile">seccompProfile</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationsecuritycontextwindowsoptions">windowsOptions</a></b></td>
        <td>object</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext.appArmorProfile {#corewaapservicespecoperationsecuritycontextapparmorprofile}

<sup><sup>[↩ Parent](#corewaapservicespecoperationsecuritycontext)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>localhostProfile</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>type</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext.capabilities {#corewaapservicespecoperationsecuritycontextcapabilities}

<sup><sup>[↩ Parent](#corewaapservicespecoperationsecuritycontext)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>add</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>drop</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext.seLinuxOptions {#corewaapservicespecoperationsecuritycontextselinuxoptions}

<sup><sup>[↩ Parent](#corewaapservicespecoperationsecuritycontext)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>level</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>role</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>type</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>user</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext.seccompProfile {#corewaapservicespecoperationsecuritycontextseccompprofile}

<sup><sup>[↩ Parent](#corewaapservicespecoperationsecuritycontext)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>localhostProfile</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>type</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.securityContext.windowsOptions {#corewaapservicespecoperationsecuritycontextwindowsoptions}

<sup><sup>[↩ Parent](#corewaapservicespecoperationsecuritycontext)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>gmsaCredentialSpec</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>gmsaCredentialSpecName</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>hostProcess</b></td>
        <td>boolean</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>runAsUserName</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.serviceAccount {#corewaapservicespecoperationserviceaccount}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Service account

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>automountToken</b></td>
        <td>boolean</td>
        <td>
          Whether to automount the token for the service account <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Service account name <br/>
          <br/>
            <i>Default</i>: default<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.startup {#corewaapservicespecoperationstartup}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

Settings for Envoy startup (mostly command line options, see https://www.envoyproxy.io/docs/envoy/latest/operations/cli)

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>additionalCliArgs</b></td>
        <td>[]string</td>
        <td>
          Additional command line arguments for Envoy<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>componentLogLevel</b></td>
        <td>string</td>
        <td>
          Envoy log level per component in the form '{comp1}:{level1},{comp2}:{level2}', e.g. 'http:debug,connection:trace', if not set defaults implicitly to empty, command line option '--component-log-level'<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>concurrency</b></td>
        <td>integer</td>
        <td>
          The number of worker threads to run, if not set defaults implicitly to the number of hardware threads on the machine, command line option '--concurrency'<br/>
          <br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>logFormat</b></td>
        <td>enum</td>
        <td>
          Envoy global log format; if not set defaults implicitly to text format<br/>
          <br/>
            <i>Enum</i>: json, text<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>logLevel</b></td>
        <td>enum</td>
        <td>
          Envoy global log level; if not set defaults implicitly to level info, command line option '--log-level'<br/>
          <br/>
            <i>Enum</i>: critical, debug, error, info, off, trace, warn, warning<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.tolerations[index] {#corewaapservicespecoperationtolerationsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperation)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>effect</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>operator</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>tolerationSeconds</b></td>
        <td>integer</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.originBlocking {#corewaapservicespecoriginblocking}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Origin blocking

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>ips</b></td>
        <td>[]string</td>
        <td>
          Allowed or denied IP addresses (CIDR notation or single IP, e.g. 1.2.3.4/32 or 1.2.3.4) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>policy</b></td>
        <td>enum</td>
        <td>
          Policy (ALLOW or DENY access depending on origin) <br/>
          <br/>
            <i>Enum</i>: ALLOW, DENY<br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.rateLimiting {#corewaapservicespecratelimiting}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Rate limiting settings

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecratelimitingrepeatoffender">repeatOffender</a></b></td>
        <td>object</td>
        <td>
          Repeat offender protection settings, i.e. protection against clients that cause lots of errors in a short time<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.rateLimiting.repeatOffender {#corewaapservicespecratelimitingrepeatoffender}

<sup><sup>[↩ Parent](#corewaapservicespecratelimiting)</sup></sup>

Repeat offender protection settings, i.e. protection against clients that cause lots of errors in a short time

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b><a href="#corewaapservicespecratelimitingrepeatoffenderclientidentification">clientIdentification</a></b></td>
        <td>object</td>
        <td>
          How to identify clients that repeatedly produce specific HTTP status codes<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether repeat offender protection is enabled or not <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>excludedClientIPs</b></td>
        <td>[]string</td>
        <td>
          Set of IPv4 IPs to exclude from protection<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecratelimitingrepeatoffenderviolation">violation</a></b></td>
        <td>object</td>
        <td>
          Settings that define how violations are identified and how to temporarily block repeat offenders in order to limit their average/overall rates<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.rateLimiting.repeatOffender.clientIdentification {#corewaapservicespecratelimitingrepeatoffenderclientidentification}

<sup><sup>[↩ Parent](#corewaapservicespecratelimitingrepeatoffender)</sup></sup>

How to identify clients that repeatedly produce specific HTTP status codes

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>headerName</b></td>
        <td>string</td>
        <td>
          The header used to identify clients <br/>
          <br/>
            <i>Default</i>: X-Forwarded-For<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>statusCodeIfMissing</b></td>
        <td>integer</td>
        <td>
          Status code to return if the identifying header is missing in a request <br/>
          <br/>
            <i>Default</i>: 403<br/>
            <i>Minimum</i>: 100<br/>
            <i>Maximum</i>: 599<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.rateLimiting.repeatOffender.violation {#corewaapservicespecratelimitingrepeatoffenderviolation}

<sup><sup>[↩ Parent](#corewaapservicespecratelimitingrepeatoffender)</sup></sup>

Settings that define how violations are identified and how to temporarily block repeat offenders in order to limit their average/overall rates

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>durationSecs</b></td>
        <td>integer</td>
        <td>
          This setting is used both for the time interval during which violations are counted and for the duration the client will be temporarily blocked if there have been too many violations; counting starts at the first violation and if there are more violations than 'threshold' during 'durationSecs', the client is immediately blocked for 'durationSecs' <br/>
          <br/>
            <i>Default</i>: 60<br/>
            <i>Minimum</i>: 1<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>httpCodes</b></td>
        <td>[]string</td>
        <td>
          HTTP status codes that cause the violation counter to be increased; besides numbers like '503' also whole ranges like '4xx' for 400-499 can be used  <br/>
          <br/>
            <i>Default</i>: [4xx 5xx]<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>statusCode</b></td>
        <td>integer</td>
        <td>
          HTTP status code to return when the client has been temporarily blocked due to too many violations <br/>
          <br/>
            <i>Default</i>: 429<br/>
            <i>Minimum</i>: 100<br/>
            <i>Maximum</i>: 599<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>threshold</b></td>
        <td>integer</td>
        <td>
          Number of violations after which to temporarily block the client <br/>
          <br/>
            <i>Default</i>: 10<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 65535<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.webResources {#corewaapservicespecwebresources}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Resources from a config map to serve as static files and/or to map status codes to error pages with dynamic content

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>configMap</b></td>
        <td>string</td>
        <td>
          Name of the config map that contains the web resources <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>path</b></td>
        <td>string</td>
        <td>
          Path where static pages will be served (must begin and end with /) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecwebresourceserrorpagesindex">errorPages</a></b></td>
        <td>[]object</td>
        <td>
          List of error pages to serve (allows dynamic content, e.g. %PROTOCOL%)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecwebresourcesstaticfilesindex">staticFiles</a></b></td>
        <td>[]object</td>
        <td>
          List of static file resources to serve (no dynamic content)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.webResources.errorPages[index] {#corewaapservicespecwebresourceserrorpagesindex}

<sup><sup>[↩ Parent](#corewaapservicespecwebresources)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key in the config map, used as filename (Content-Type guessed from filename, encoding utf-8 for text/*) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>statusCode</b></td>
        <td>string</td>
        <td>
          Status code to apply to (also allows to e.g. use '4xx' for all client errors 400-499) <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>mappedStatusCode</b></td>
        <td>integer</td>
        <td>
          Status code to send to client (defaults to upstream status code)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.webResources.staticFiles[index] {#corewaapservicespecwebresourcesstaticfilesindex}

<sup><sup>[↩ Parent](#corewaapservicespecwebresources)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key in the config map, used as filename (Content-Type guessed from filename, encoding utf-8 for text/*) <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.status {#corewaapservicestatus}

<sup><sup>[↩ Parent](#corewaapservice)</sup></sup>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>status</b></td>
        <td>string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>warnings</b></td>
        <td>[]string</td>
        <td>
          <br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

---
title: 'API Reference'
weight: 60
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
        <td><b><a href="#corewaapservicespeccrs">crs</a></b></td>
        <td>object</td>
        <td>
          OWASP Core Rule Set (CRS) settings (version 4.14.0)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccsrfpolicy">csrfPolicy</a></b></td>
        <td>object</td>
        <td>
          Global CSRF protection (default on). It detects and blocks CSRF attacks based on comparing the request origin (either 'Origin' or 'Referrer' header) with the request target. If the origin does not match the target and is not allowed specifically, the request will be blocked.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfiltering">headerFiltering</a></b></td>
        <td>object</td>
        <td>
          Global header filtering (default is allow standard headers only)<br/>
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
        <td><b><a href="#corewaapservicespectrafficprocessing">trafficProcessing</a></b></td>
        <td>object</td>
        <td>
          Traffic processing settings (e.g. for ICAP Anti-Virus scanning)<br/>
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
        <td><b><a href="#corewaapservicespecroutesindexcrs">crs</a></b></td>
        <td>object</td>
        <td>
          CRS settings per route<br/>
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
        <td><b>trafficProcessingRefs</b></td>
        <td>[]string</td>
        <td>
          References to traffic processing; processing order is OpenAPI, ICAP  (and within each type in the order listed under spec.trafficProcessing)<br/>
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
          Request header name <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>value</b></td>
        <td>string</td>
        <td>
          Request header value (exact match of full string) <br/>
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

### CoreWaapService.spec.routes[index].crs {#corewaapservicespecroutesindexcrs}

<sup><sup>[↩ Parent](#corewaapservicespecroutesindex)</sup></sup>

CRS settings per route

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
        <td><b>disabled</b></td>
        <td>boolean</td>
        <td>
          Whether to disable all CRS parsing for the route or not <br/>
          <br/>
            <i>Default</i>: false<br/>
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
        <td><b><a href="#corewaapservicespecauthenticationsindexcredentials">credentials</a></b></td>
        <td>object</td>
        <td>
          OIDC credentials (client_id and client_secret, omit if only using JWT validation)<br/>
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
          Whether to forward the JWT to the upstream server <br/>
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

### CoreWaapService.spec.crs {#corewaapservicespeccrs}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

OWASP Core Rule Set (CRS) settings (version 4.14.0)

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
        <td><b><a href="#corewaapservicespeccrscustomrequestblockingrulesindex">customRequestBlockingRules</a></b></td>
        <td>[]object</td>
        <td>
          Custom request blocking rules<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabledRequestRules</b></td>
        <td>[]enum</td>
        <td>
          Set of request rule classes (default is to include all rules, rules REQUEST_901_INITIALIZATION and REQUEST_949_BLOCKING_EVALUATION are always included, see https://github.com/coreruleset/coreruleset/tree/v4.14.0/rules for all configurable values, just replace '-' by '_' and omit '.conf')<br/>
          <br/>
            <i>Enum</i>: REQUEST_913_SCANNER_DETECTION, REQUEST_920_PROTOCOL_ENFORCEMENT, REQUEST_921_PROTOCOL_ATTACK, REQUEST_922_MULTIPART_ATTACK, REQUEST_930_APPLICATION_ATTACK_LFI, REQUEST_931_APPLICATION_ATTACK_RFI, REQUEST_932_APPLICATION_ATTACK_RCE, REQUEST_933_APPLICATION_ATTACK_PHP, REQUEST_934_APPLICATION_ATTACK_GENERIC, REQUEST_941_APPLICATION_ATTACK_XSS, REQUEST_942_APPLICATION_ATTACK_SQLI, REQUEST_943_APPLICATION_ATTACK_SESSION_FIXATION, REQUEST_944_APPLICATION_ATTACK_JAVA<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabledResponseRules</b></td>
        <td>[]enum</td>
        <td>
          Set of response rule classes (default is to include no rules, rules RESPONSE_959_BLOCKING_EVALUATION and RESPONSE_980_CORRELATION are always included, see https://github.com/coreruleset/coreruleset/tree/v4.14.0/rules for all configurable values, just replace '-' by '_' and omit '.conf')<br/>
          <br/>
            <i>Enum</i>: RESPONSE_950_DATA_LEAKAGES, RESPONSE_951_DATA_LEAKAGES_SQL, RESPONSE_952_DATA_LEAKAGES_JAVA, RESPONSE_953_DATA_LEAKAGES_PHP, RESPONSE_954_DATA_LEAKAGES_IIS, RESPONSE_955_WEB_SHELLS<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>mode</b></td>
        <td>enum</td>
        <td>
          Mode (BLOCK = traffic identified as suspicious is blocked; DETECT = traffic identified as suspicious is logged but not blocked; DISABLED = traffic is not inspected) <br/>
          <br/>
            <i>Enum</i>: BLOCK, DETECT, DISABLED<br/>
            <i>Default</i>: BLOCK<br/>
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
        <td><b>parseJson</b></td>
        <td>boolean</td>
        <td>
          Whether to apply CRS protection rules for JSON payloads or not <br/>
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
          Whether to scan request bodies or not (if this setting is disabled, POST parameters and other content submitted in the request body will not be inspected) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccrsrequestbodyaccessexceptionsindex">requestBodyAccessExceptions</a></b></td>
        <td>[]object</td>
        <td>
          Request body parsing exceptions (locations to exclude from parsing, typically for file uploads)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestBodyLimitKb</b></td>
        <td>integer</td>
        <td>
          Request body limit in KB, body bytes beyond the limit are not parsed (max 1048576 KB (1 GB)) <br/>
          <br/>
            <i>Default</i>: 128<br/>
            <i>Minimum</i>: 0<br/>
            <i>Maximum</i>: 1.048576e+06<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccrsrequestruleexceptionsindex">requestRuleExceptions</a></b></td>
        <td>[]object</td>
        <td>
          Conditionally disable request rules to avoid false positive alerts/blocks<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>responseBodyLimitKb</b></td>
        <td>integer</td>
        <td>
          Response body limit in KB, body bytes beyond the limit are not parsed <br/>
          <br/>
            <i>Default</i>: 256<br/>
            <i>Minimum</i>: 0<br/>
            <i>Maximum</i>: 1.048576e+06<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespeccrsresponseruleexceptionsindex">responseRuleExceptions</a></b></td>
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
      </tr><tr>
        <td><b>validateJson</b></td>
        <td>boolean</td>
        <td>
          Special rule which checks the syntax of JSON requests (if the syntax is invalid and the current mode is BLOCK, such requests are blocked) <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.crs.customRequestBlockingRules[index] {#corewaapservicespeccrscustomrequestblockingrulesindex}

<sup><sup>[↩ Parent](#corewaapservicespeccrs)</sup></sup>

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

### CoreWaapService.spec.crs.requestBodyAccessExceptions[index] {#corewaapservicespeccrsrequestbodyaccessexceptionsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccrs)</sup></sup>

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
          Location for which to skip request body parsing <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>methods</b></td>
        <td>[]enum</td>
        <td>
          HTTP method(s) for which to skip request body parsing (at least one must be defined) <br/>
          <br/>
            <i>Enum</i>: ACL, BIND, CHECKOUT, CONNECT, COPY, DELETE, GET, HEAD, LINK, LOCK, MERGE, MKACTIVITY, MKCALENDAR, MKCOL, MOVE, MSEARCH, NOTIFY, OPTIONS, PATCH, POST, PROPFIND, PROPPATCH, PURGE, PUT, REBIND, REPORT, SEARCH, SOURCE, SUBSCRIBE, TRACE, UNBIND, UNLINK, UNLOCK, UNSUBSCRIBE<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>regEx</b></td>
        <td>boolean</td>
        <td>
          Whether the location is indicated as a regex or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.crs.requestRuleExceptions[index] {#corewaapservicespeccrsrequestruleexceptionsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccrs)</sup></sup>

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
        <td><b><a href="#corewaapservicespeccrsrequestruleexceptionsindexmetadata">metadata</a></b></td>
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
          Request part name (e.g. 'User-Agent')<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartType</b></td>
        <td>enum</td>
        <td>
          Request part type<br/>
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

### CoreWaapService.spec.crs.requestRuleExceptions[index].metadata {#corewaapservicespeccrsrequestruleexceptionsindexmetadata}

<sup><sup>[↩ Parent](#corewaapservicespeccrsrequestruleexceptionsindex)</sup></sup>

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

### CoreWaapService.spec.crs.responseRuleExceptions[index] {#corewaapservicespeccrsresponseruleexceptionsindex}

<sup><sup>[↩ Parent](#corewaapservicespeccrs)</sup></sup>

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
        <td><b><a href="#corewaapservicespeccrsresponseruleexceptionsindexmetadata">metadata</a></b></td>
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
          Request part name (e.g. 'User-Agent')<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>requestPartType</b></td>
        <td>enum</td>
        <td>
          Request part type<br/>
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

### CoreWaapService.spec.crs.responseRuleExceptions[index].metadata {#corewaapservicespeccrsresponseruleexceptionsindexmetadata}

<sup><sup>[↩ Parent](#corewaapservicespeccrsresponseruleexceptionsindex)</sup></sup>

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

### CoreWaapService.spec.csrfPolicy {#corewaapservicespeccsrfpolicy}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Global CSRF protection (default on). It detects and blocks CSRF attacks based on comparing the request origin (either 'Origin' or 'Referrer' header) with the request target. If the origin does not match the target and is not allowed specifically, the request will be blocked.

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

### CoreWaapService.spec.headerFiltering {#corewaapservicespecheaderfiltering}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Global header filtering (default is allow standard headers only)

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
        <td><b>logOnly</b></td>
        <td>boolean</td>
        <td>
          Whether header filtering should only log potentially blocked headers <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilteringrequest">request</a></b></td>
        <td>object</td>
        <td>
          Request header filtering<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilteringresponse">response</a></b></td>
        <td>object</td>
        <td>
          Response header filtering<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFiltering.request {#corewaapservicespecheaderfilteringrequest}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfiltering)</sup></sup>

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
          List of allowed header names in addition to ones in allowClass<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>allowClass</b></td>
        <td>enum</td>
        <td>
          A common preset of allowed headers. Values: MINIMAL, STANDARD, RESTRICTED <br/>
          <br/>
            <i>Enum</i>: MINIMAL, RESTRICTED, STANDARD<br/>
            <i>Default</i>: STANDARD<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespecheaderfilteringrequestdenyindex">deny</a></b></td>
        <td>[]object</td>
        <td>
          List of denied header names; applied after allowClass & allow<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether request header filtering is enabled or not <br/>
          <br/>
            <i>Default</i>: true<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFiltering.request.deny[index] {#corewaapservicespecheaderfilteringrequestdenyindex}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfilteringrequest)</sup></sup>

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
          Denied header name; '*' could be used in conjunction with non-blank valuePattern to match all header names<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>valuePattern</b></td>
        <td>string</td>
        <td>
          Lua pattern for denied header value (see https://www.lua.org/pil/20.2.html)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.headerFiltering.response {#corewaapservicespecheaderfilteringresponse}

<sup><sup>[↩ Parent](#corewaapservicespecheaderfiltering)</sup></sup>

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
          List of allowed header names<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>deny</b></td>
        <td>[]string</td>
        <td>
          List of denied header names; applied after allow<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>enabled</b></td>
        <td>boolean</td>
        <td>
          Whether response header filtering is enabled or not <br/>
          <br/>
            <i>Default</i>: true<br/>
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
        <td><b>bufferLimitBytes</b></td>
        <td>integer</td>
        <td>
          Maximal body size for processing requests and responses (Envoy's perConnectionBufferLimitBytes on listener, plus also affects buffers for traffic processing in transferMode BUFFERED)<br/>
          <br/>
            <i>Default</i>: 1048576<br/>
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
        <td><b>image</b></td>
        <td>string</td>
        <td>
          Core WAAP container image (host+path+name) without version, e.g. 'uspregistry.azurecr.io/usp/core/waap/usp-core-waap' (must be defined either in spec or operator defaults) (DEPRECATED: for backwards compatibility, it is currently still allowed to append a version with ':' and omit a separate version field, but this is deprecated and existing config should be migrated)<br/>
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
          Whether metrics sidecar is enabled or not <br/>
          <br/>
            <i>Default</i>: false<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>image</b></td>
        <td>string</td>
        <td>
          Metrics sidecar container image (host+path+name) without version, e.g. 'uspregistry.azurecr.io/usp/core/waap/usp-core-waap-metrics' (must be defined either in spec or operator defaults per traffic processor type) <br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>pollIntervalSeconds</b></td>
        <td>integer</td>
        <td>
          Interval (in seconds) between sending metrics requests to the Envoy and traffic processors <br/>
          <br/>
            <i>Default</i>: 60<br/>
            <i>Minimum</i>: 1<br/>
            <i>Maximum</i>: 86400<br/>
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
      </tr><tr>
        <td><b><a href="#corewaapservicespecoperationmetricsresources">resources</a></b></td>
        <td>object</td>
        <td>
          Kubernetes resources for the metrics sidecar container<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>version</b></td>
        <td>string</td>
        <td>
          Metrics sidecar container (image) version, e.g. '1.0.1' (must be defined either in spec or operator defaults per traffic processor type)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.operation.metrics.resources {#corewaapservicespecoperationmetricsresources}

<sup><sup>[↩ Parent](#corewaapservicespecoperationmetrics)</sup></sup>

Kubernetes resources for the metrics sidecar container

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
        <td><b><a href="#corewaapservicespecoperationmetricsresourcesclaimsindex">claims</a></b></td>
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

### CoreWaapService.spec.operation.metrics.resources.claims[index] {#corewaapservicespecoperationmetricsresourcesclaimsindex}

<sup><sup>[↩ Parent](#corewaapservicespecoperationmetricsresources)</sup></sup>

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
        <td>string</td>
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

### CoreWaapService.spec.trafficProcessing {#corewaapservicespectrafficprocessing}

<sup><sup>[↩ Parent](#corewaapservicespec)</sup></sup>

Traffic processing settings (e.g. for ICAP Anti-Virus scanning)

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
        <td><b><a href="#corewaapservicespectrafficprocessingicapindex">icap</a></b></td>
        <td>[]object</td>
        <td>
          Traffic processing settings for type ICAP (Internet Content Adaptation Protocol); ICAP is typically used for Anti-Virus scanning of HTTP request bodies; currently only validation of the HTTP request body is supported (ICAP REQMOD) (no modifications to the scanned body, no validation of HTTP responses<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindex">openapi</a></b></td>
        <td>[]object</td>
        <td>
          Traffic processing settings for type OPENAPI; OPENAPI is used for request/response validation against an OpenAPI schema<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.icap[index] {#corewaapservicespectrafficprocessingicapindex}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessing)</sup></sup>

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
        <td><b><a href="#corewaapservicespectrafficprocessingicapindexconfig">config</a></b></td>
        <td>object</td>
        <td>
          Validation configuration for the sidecar<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes under trafficProcessingRefs <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingicapindexextproc">extProc</a></b></td>
        <td>object</td>
        <td>
          External processing related settings, i.e. settings for the callout to the ICAP sidecar<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingicapindexoperation">operation</a></b></td>
        <td>object</td>
        <td>
          Operation related settings to be used for Kubernetes deployment of the respective traffic processing sidecar (optional, except that the operation's image/version fields must be set in the spec at 'trafficProcessing.{type}.operation' or via default in the operator config at 'waapSpecTrafficProcessingDefaults.{type}', where '{type}' is e.g. 'icap') [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec]<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.icap[index].config {#corewaapservicespectrafficprocessingicapindexconfig}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingicapindex)</sup></sup>

Validation configuration for the sidecar

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
        <td><b>url</b></td>
        <td>string</td>
        <td>
          ICAP URL including protocol and port (e.g. 'icap://some.host:1344/some/path', use 'icaps://' for TLS)  <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.icap[index].extProc {#corewaapservicespectrafficprocessingicapindexextproc}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingicapindex)</sup></sup>

External processing related settings, i.e. settings for the callout to the ICAP sidecar

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
        <td>string</td>
        <td>
          Additional command line arguments for the external service<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>messageTimeout</b></td>
        <td>string</td>
        <td>
          Message timeout for extProc callouts essentially in Kubernetes format (e.g. '30s', defaults to Envoy's default of 200ms)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>transferMode</b></td>
        <td>enum</td>
        <td>
          Transfer mode (icap supports BUFFERED and STREAMED; openapi supports only BUFFERED); in BUFFERED mode body size is limited to operator.bufferLimitBytes, while in STREAMED mode, data is streamed in chunks, which, depending on the backend's specific implementation, might cause data to be processed or stored on the backend, even if validation fails in the end<br/>
          <br/>
            <i>Enum</i>: BUFFERED, STREAMED<br/>
            <i>Default</i>: BUFFERED<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.icap[index].operation {#corewaapservicespectrafficprocessingicapindexoperation}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingicapindex)</sup></sup>

Operation related settings to be used for Kubernetes deployment of the respective traffic processing sidecar (optional, except that the operation's image/version fields must be set in the spec at 'trafficProcessing.{type}.operation' or via default in the operator config at 'waapSpecTrafficProcessingDefaults.{type}', where '{type}' is e.g. 'icap') [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec]

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
        <td><b>image</b></td>
        <td>string</td>
        <td>
          Traffic processor sidecar container image (host+path+name) without version, e.g. 'uspregistry.azurecr.io/usp/core/waap/usp-core-waap-ext-proc-icap' (must be defined either in spec or operator defaults per traffic processor type) (DEPRECATED: for backwards compatibility, it is currently still allowed to append a version with ':' and omit a separate version field, but this is deprecated and existing config should be migrated)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingicapindexoperationresources">resources</a></b></td>
        <td>object</td>
        <td>
          Kubernetes resources for the sidecar container<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>version</b></td>
        <td>string</td>
        <td>
          Traffic processor sidecar container (image) version, e.g. '1.0.1' (must be defined either in spec or operator defaults per traffic processor type)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.icap[index].operation.resources {#corewaapservicespectrafficprocessingicapindexoperationresources}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingicapindexoperation)</sup></sup>

Kubernetes resources for the sidecar container

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
        <td><b><a href="#corewaapservicespectrafficprocessingicapindexoperationresourcesclaimsindex">claims</a></b></td>
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

### CoreWaapService.spec.trafficProcessing.icap[index].operation.resources.claims[index] {#corewaapservicespectrafficprocessingicapindexoperationresourcesclaimsindex}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingicapindexoperationresources)</sup></sup>

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
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index] {#corewaapservicespectrafficprocessingopenapiindex}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessing)</sup></sup>

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
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexconfig">config</a></b></td>
        <td>object</td>
        <td>
          Validation configuration for the sidecar<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>name</b></td>
        <td>string</td>
        <td>
          Name to reference in routes under trafficProcessingRefs <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexextproc">extProc</a></b></td>
        <td>object</td>
        <td>
          External processing related settings, i.e. settings for the callout to the OpenAPI sidecar<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexoperation">operation</a></b></td>
        <td>object</td>
        <td>
          Operation related settings to be used for Kubernetes deployment of the respective traffic processing sidecar (optional, except that the operation's image/version fields must be set in the spec at 'trafficProcessing.{type}.operation' or via default in the operator config at 'waapSpecTrafficProcessingDefaults.{type}', where '{type}' is 'openapi') [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec]<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index].config {#corewaapservicespectrafficprocessingopenapiindexconfig}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindex)</sup></sup>

Validation configuration for the sidecar

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
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexconfigschemasource">schemaSource</a></b></td>
        <td>object</td>
        <td>
          Source of the schema that will be used for validation <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexconfigscope">scope</a></b></td>
        <td>object</td>
        <td>
          Validation scope settings<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index].config.schemaSource {#corewaapservicespectrafficprocessingopenapiindexconfigschemasource}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindexconfig)</sup></sup>

Source of the schema that will be used for validation

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
          Name of the config map that contains the schema <br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>key</b></td>
        <td>string</td>
        <td>
          Key in the config map that contains the schema <br/>
        </td>
        <td>true</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index].config.scope {#corewaapservicespectrafficprocessingopenapiindexconfigscope}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindexconfig)</sup></sup>

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
        <td><b>logOnly</b></td>
        <td>boolean</td>
        <td>
          Indicates that validation won't fail, but only be logged <br/>
          <br/>
            <i>Default</i>: false<br/>
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

### CoreWaapService.spec.trafficProcessing.openapi[index].extProc {#corewaapservicespectrafficprocessingopenapiindexextproc}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindex)</sup></sup>

External processing related settings, i.e. settings for the callout to the OpenAPI sidecar

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
        <td>string</td>
        <td>
          Additional command line arguments for the external service<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>messageTimeout</b></td>
        <td>string</td>
        <td>
          Message timeout for extProc callouts essentially in Kubernetes format (e.g. '30s', defaults to Envoy's default of 200ms)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>transferMode</b></td>
        <td>enum</td>
        <td>
          Transfer mode (icap supports BUFFERED and STREAMED; openapi supports only BUFFERED); in BUFFERED mode body size is limited to operator.bufferLimitBytes, while in STREAMED mode, data is streamed in chunks, which, depending on the backend's specific implementation, might cause data to be processed or stored on the backend, even if validation fails in the end<br/>
          <br/>
            <i>Enum</i>: BUFFERED, STREAMED<br/>
            <i>Default</i>: BUFFERED<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index].operation {#corewaapservicespectrafficprocessingopenapiindexoperation}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindex)</sup></sup>

Operation related settings to be used for Kubernetes deployment of the respective traffic processing sidecar (optional, except that the operation's image/version fields must be set in the spec at 'trafficProcessing.{type}.operation' or via default in the operator config at 'waapSpecTrafficProcessingDefaults.{type}', where '{type}' is 'openapi') [merge with operator defaults: config trees are merged in detail with precedence given to values in the spec]

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
        <td><b>image</b></td>
        <td>string</td>
        <td>
          Traffic processor sidecar container image (host+path+name) without version, e.g. 'uspregistry.azurecr.io/usp/core/waap/usp-core-waap-ext-proc-icap' (must be defined either in spec or operator defaults per traffic processor type) (DEPRECATED: for backwards compatibility, it is currently still allowed to append a version with ':' and omit a separate version field, but this is deprecated and existing config should be migrated)<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexoperationresources">resources</a></b></td>
        <td>object</td>
        <td>
          Kubernetes resources for the sidecar container<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>version</b></td>
        <td>string</td>
        <td>
          Traffic processor sidecar container (image) version, e.g. '1.0.1' (must be defined either in spec or operator defaults per traffic processor type)<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### CoreWaapService.spec.trafficProcessing.openapi[index].operation.resources {#corewaapservicespectrafficprocessingopenapiindexoperationresources}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindexoperation)</sup></sup>

Kubernetes resources for the sidecar container

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
        <td><b><a href="#corewaapservicespectrafficprocessingopenapiindexoperationresourcesclaimsindex">claims</a></b></td>
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

### CoreWaapService.spec.trafficProcessing.openapi[index].operation.resources.claims[index] {#corewaapservicespectrafficprocessingopenapiindexoperationresourcesclaimsindex}

<sup><sup>[↩ Parent](#corewaapservicespectrafficprocessingopenapiindexoperationresources)</sup></sup>

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
      </tr></tbody>
</table>

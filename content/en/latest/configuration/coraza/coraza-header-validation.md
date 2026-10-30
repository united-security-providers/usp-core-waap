---
title: 'Coraza Header Validation'
linkTitle: 'Header Validation'
weight: 80
---
# Header Validation Basic Usage

(This section assumes you have read the section [What is Coraza?](coraza/#what-is-coraza))

* Header validation checks the request headers listed [below](#validated-headers)
  for valid syntax and length.
  Request headers not listed there are not validated.
* By default, header validation is active in mode BLOCK:
  a request with at least one invalid header is rejected with status code 403.
  In mode DETECT, such requests are logged but not blocked.
* Header validation does not depend on CRS, it is also active on routes where CRS is disabled.
  It is only inactive where the Coraza filter is disabled
  (`spec.coraza.enabled` or `spec.routes[].coraza.enabled`).
* Header validation settings are at `spec.coraza.headerValidation`
  in the [API Reference](../crd-doc/#corewaapservicespeccorazaheadervalidation).
  They apply to all routes.

## What is validated

Each validated header is checked in two ways:

* **Length**: the value must not exceed the maximum length listed for the header.
* **Syntax**: the value must match the grammar defined by the specification of the header,
  for most headers an RFC (e.g. [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) for the common HTTP headers).
  For widely used headers without a specification (e.g. `X-Forwarded-For`),
  the grammar follows common implementation practice.

The syntax check validates the form of a value, not its meaning.
A value that is well-formed but makes no sense is accepted:

| Value | Result | Why |
|---|---|---|
| `Accept-Encoding: foozip` | accepted | any token is a valid content coding, the value is not checked against known codings |
| `Authorization: Token abc` | accepted | `Token` is a valid authentication scheme name |
| `Accept: text/` | rejected | the media subtype is missing |
| `Accept: (text)/html` | rejected | `(` is not allowed in a media type |

## Excluding headers

If legitimate clients send headers that fail the validation, these can be excluded
via `spec.coraza.headerValidation.exceptions` (header names are case-insensitive):

* `<header>` excludes the header from both length and syntax validation
* `<header>/length` excludes only the length validation
* `<header>/syntax` excludes only the syntax validation

```yaml
spec:
  [...]
  coraza:
    headerValidation:
      exceptions:
        - "authorization/length"
        - "x-legacy-client"
```

## Introducing header validation

To introduce header validation without blocking legitimate traffic,
it is recommended to first use mode DETECT, add exceptions for headers
legitimately reported as invalid, and then switch to mode BLOCK:

```yaml
spec:
  [...]
  coraza:
    headerValidation:
      mode: DETECT
```

To disable header validation completely, set `spec.coraza.headerValidation.enabled` to `false`.

## Validated headers

| Header | Specification | Max length |
|---|---|--:|
| `Accept` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.accept) | 400 |
| `Accept-Charset` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.accept-charset) | 200 |
| `Accept-Encoding` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.accept-encoding) | 200 |
| `Accept-Language` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.accept-language) | 200 |
| `Accept-Ranges` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.accept-ranges) | 100 |
| `Access-Control-Request-Method` | [WHATWG Fetch](https://fetch.spec.whatwg.org/#http-access-control-request-method) | 8192 |
| `Access-Control-Request-Headers` | [WHATWG Fetch](https://fetch.spec.whatwg.org/#http-access-control-request-headers) | 8192 |
| `Allow` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.allow) | 200 |
| `Authorization` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.authorization) | 4096 |
| `Proxy-Authorization` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.proxy-authorization) | 1200 |
| `Cache-Control` | [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html#field.cache-control) | 200 |
| `Connection` | [RFC 9112](https://www.rfc-editor.org/rfc/rfc9112.html#name-connection-management) | 200 |
| `Content-Encoding` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.content-encoding) | 200 |
| `Content-Language` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.content-language) | 200 |
| `Content-Length` | [RFC 9112](https://www.rfc-editor.org/rfc/rfc9112.html#name-content-length) | 30 |
| `Content-Location` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.content-location) | 2000 |
| `Content-Range` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.content-range) | 200 |
| `Content-Type` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.content-type) | 600 |
| `Date` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.date) | 50 |
| `Expect` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.expect) | 200 |
| `From` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.from) | 200 |
| `Host` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.host) | 200 |
| `HTTP2-Settings` | [RFC 7540](https://www.rfc-editor.org/rfc/rfc7540.html#section-3.2.1) | 8192 |
| `If-Match` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.if-match) | 200 |
| `If-Modified-Since` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.if-modified-since) | 50 |
| `If-None-Match` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.if-none-match) | 200 |
| `If-Range` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.if-range) | 200 |
| `If-Unmodified-Since` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.if-unmodified-since) | 50 |
| `Last-Modified` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.last-modified) | 50 |
| `Location` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.location) | 8192 |
| `Max-Forwards` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.max-forwards) | 50 |
| `Origin` | [RFC 6454](https://www.rfc-editor.org/rfc/rfc6454.html#section-3.2) | 8192 |
| `Pragma` | [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html#field.pragma) | 200 |
| `Range` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.range) | 200 |
| `Referer` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.referer) | 8192 |
| `TE` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.te) | 200 |
| `Transfer-Encoding` | [RFC 9112](https://www.rfc-editor.org/rfc/rfc9112.html#field.transfer-encoding) | 200 |
| `Upgrade` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.upgrade) | 200 |
| `User-Agent` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.user-agent) | 400 |
| `Vary` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.vary) | 200 |
| `Via` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.via) | 200 |
| `Warning` | [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html#field.warning) | 200 |
| `WWW-Authenticate` | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#field.www-authenticate) | 400 |
| `Forwarded` | [RFC 7239](https://www.rfc-editor.org/rfc/rfc7239.html#section-4) | 2000 |
| `Cookie` | [RFC 6265](https://www.rfc-editor.org/rfc/rfc6265.html#section-4.2) | 8192 |
| `Sec-WebSocket-Key` | [RFC 6455](https://www.rfc-editor.org/rfc/rfc6455.html#section-11.3.1) | 50 |
| `Sec-WebSocket-Version` | [RFC 6455](https://www.rfc-editor.org/rfc/rfc6455.html#section-11.3.5) | 50 |
| `Sec-WebSocket-Protocol` | [RFC 6455](https://www.rfc-editor.org/rfc/rfc6455.html#section-11.3.4) | 200 |
| `Sec-WebSocket-Extensions` | [RFC 6455](https://www.rfc-editor.org/rfc/rfc6455.html#section-11.3.2) | 500 |
| `Early-Data` | [RFC 8470](https://www.rfc-editor.org/rfc/rfc8470.html#section-5.1) | 10 |
| `Priority` | [RFC 9218](https://www.rfc-editor.org/rfc/rfc9218.html#name-priority-parameters) | 64 |
| `Content-Digest` | [RFC 9530](https://www.rfc-editor.org/rfc/rfc9530.html#content-digest) | 1024 |
| `Repr-Digest` | [RFC 9530](https://www.rfc-editor.org/rfc/rfc9530.html#name-the-repr-digest-field) | 1024 |
| `Want-Content-Digest` | [RFC 9530](https://www.rfc-editor.org/rfc/rfc9530.html#want-fields) | 200 |
| `Want-Repr-Digest` | [RFC 9530](https://www.rfc-editor.org/rfc/rfc9530.html#want-fields) | 200 |
| `Signature` | [RFC 9421](https://www.rfc-editor.org/rfc/rfc9421.html#signature-header) | 2048 |
| `Signature-Input` | [RFC 9421](https://www.rfc-editor.org/rfc/rfc9421.html#signature-input-header) | 1024 |
| `X-Forwarded-For` | no specification | 2000 |
| `X-Forwarded-Host` | no specification | 200 |
| `X-Forwarded-Port` | no specification | 10 |
| `X-Forwarded-Proto` | no specification | 50 |
| `X-Forwarded-Ssl` | no specification | 10 |
| `Front-End-Https` | no specification | 10 |
| `X-Forwarded-Server` | no specification | 200 |
| `X-Forwarded-By` | no specification | 100 |
| `X-Real-IP` | no specification | 50 |
| `Client-IP` | no specification | 50 |
| `True-Client-IP` | no specification | 50 |
| `CF-Connecting-IP` | no specification | 50 |
| `X-Client-IP` | no specification | 50 |
| `X-Cluster-Client-IP` | no specification | 50 |
| `Fastly-Client-IP` | no specification | 50 |
| `X-Azure-ClientIP` | no specification | 50 |
| `X-ProxyUser-Ip` | no specification | 50 |
| `CF-IPCountry` | no specification | 4 |
| `X-Original-Host` | no specification | 200 |
| `X-Host` | no specification | 200 |
| `X-Original-URL` | no specification | 2000 |
| `X-Rewrite-URL` | no specification | 2000 |
| `X-Forwarded-Path` | no specification | 2000 |
| `X-HTTP-Method-Override` | no specification | 20 |
| `X-HTTP-Method` | no specification | 20 |
| `X-Method-Override` | no specification | 20 |
| `X-Original-Method` | no specification | 20 |
| `Sec-Fetch-Site` | [W3C Fetch Metadata](https://w3c.github.io/webappsec-fetch-metadata/#http-headerdef-sec-fetch-site) | 20 |
| `Sec-Fetch-Mode` | [W3C Fetch Metadata](https://w3c.github.io/webappsec-fetch-metadata/#http-headerdef-sec-fetch-mode) | 20 |
| `Sec-Fetch-User` | [W3C Fetch Metadata](https://w3c.github.io/webappsec-fetch-metadata/#http-headerdef-sec-fetch-user) | 10 |
| `Sec-Fetch-Dest` | [W3C Fetch Metadata](https://w3c.github.io/webappsec-fetch-metadata/#http-headerdef-sec-fetch-dest) | 30 |
| `Sec-Fetch-Storage-Access` | [Storage Access Headers](https://privacycg.github.io/storage-access-headers/#http-headerdef-sec-fetch-storage-access) | 20 |
| `Purpose` | no specification | 20 |
| `Sec-Purpose` | [Speculation Rules](https://wicg.github.io/nav-speculation/prefetch.html#sec-purpose-header) | 30 |
| `Sec-CH-UA` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua) | 300 |
| `Sec-CH-UA-Full-Version-List` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-full-version-list) | 500 |
| `Sec-CH-UA-Form-Factors` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-form-factors) | 200 |
| `Sec-CH-UA-Mobile` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-mobile) | 10 |
| `Sec-CH-UA-Platform` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-platform) | 100 |
| `Sec-CH-UA-Platform-Version` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-platform-version) | 100 |
| `Sec-CH-UA-Full-Version` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-full-version) | 100 |
| `Sec-CH-UA-Arch` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-arch) | 50 |
| `Sec-CH-UA-Bitness` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-bitness) | 20 |
| `Sec-CH-UA-Model` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-model) | 100 |
| `Sec-CH-UA-WoW64` | [W3C UA-CH](https://wicg.github.io/ua-client-hints/#http-headerdef-sec-ch-ua-wow64) | 10 |
| `Sec-CH-Prefers-Color-Scheme` | [User Preference CH](https://wicg.github.io/user-preference-media-features-headers/#sec-ch-prefers-color-scheme) | 30 |
| `Sec-CH-Prefers-Reduced-Motion` | [User Preference CH](https://wicg.github.io/user-preference-media-features-headers/#sec-ch-prefers-reduced-motion) | 30 |
| `Sec-CH-Prefers-Reduced-Transparency` | [User Preference CH](https://wicg.github.io/user-preference-media-features-headers/#sec-ch-prefers-reduced-transparency) | 30 |
| `Sec-CH-Prefers-Contrast` | [User Preference CH](https://wicg.github.io/user-preference-media-features-headers/#sec-ch-prefers-contrast) | 30 |
| `Sec-CH-Viewport-Width` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-viewport-width) | 20 |
| `Sec-CH-Viewport-Height` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-viewport-height) | 20 |
| `Sec-CH-Width` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-width) | 20 |
| `Sec-CH-DPR` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-dpr) | 20 |
| `Sec-CH-Device-Memory` | [W3C Device Memory](https://www.w3.org/TR/device-memory-1/#http-headerdef-sec-ch-device-memory) | 20 |
| `Sec-CH-Downlink` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-downlink) | 20 |
| `Sec-CH-RTT` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-rtt) | 20 |
| `Sec-CH-ECT` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-ect) | 20 |
| `Sec-CH-Save-Data` | [WICG Save Data](https://wicg.github.io/savedata/#registration-save-data) | 10 |
| `DPR` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-dpr) | 20 |
| `Width` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-width) | 20 |
| `Viewport-Width` | [Responsive Image CH](https://wicg.github.io/responsive-image-client-hints/#http-headerdef-sec-ch-viewport-width) | 20 |
| `Device-Memory` | [W3C Device Memory](https://www.w3.org/TR/device-memory-1/#http-headerdef-sec-ch-device-memory) | 20 |
| `Downlink` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-downlink) | 20 |
| `RTT` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-rtt) | 20 |
| `ECT` | [W3C Network Information](https://wicg.github.io/netinfo/#registration-ect) | 20 |
| `Save-Data` | [WICG Save Data](https://wicg.github.io/savedata/#registration-save-data) | 10 |
| `X-Requested-With` | no specification | 100 |
| `X-CSRF-Token` | no specification | 512 |
| `X-XSRF-Token` | no specification | 512 |
| `X-Api-Key` | no specification | 512 |
| `X-Auth-Token` | no specification | 1024 |
| `X-Request-Id` | no specification | 200 |
| `X-Correlation-Id` | no specification | 200 |
| `X-Trace-Id` | no specification | 200 |
| `Idempotency-Key` | [IETF draft](https://datatracker.ietf.org/doc/html/draft-ietf-httpapi-idempotency-key-header) | 256 |
| `Traceparent` | [W3C Trace Context](https://www.w3.org/TR/trace-context/#traceparent-header) | 64 |
| `Tracestate` | [W3C Trace Context](https://www.w3.org/TR/trace-context/#tracestate-header) | 512 |
| `Baggage` | [W3C Baggage](https://www.w3.org/TR/baggage/) | 8192 |
| `DNT` | [W3C DNT](https://www.w3.org/TR/tracking-dnt/#dnt-header-field) | 10 |
| `Sec-GPC` | [W3C GPC](https://w3c.github.io/gpc/#set-global-privacy-control) | 10 |
| `Upgrade-Insecure-Requests` | [W3C UIR](https://www.w3.org/TR/upgrade-insecure-requests/#upgrade-insecure-requests) | 10 |
| `MIME-Version` | [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045.html#section-4) | 20 |
| `A-IM` | [RFC 3229](https://www.rfc-editor.org/rfc/rfc3229.html#section-10.5.3) | 200 |
| `Depth` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.2) | 20 |
| `Destination` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.3) | 2000 |
| `If` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.4) | 2000 |
| `Lock-Token` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.5) | 2000 |
| `Overwrite` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.6) | 10 |
| `Timeout` | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918.html#section-10.7) | 200 |
| `Accept-Datetime` | [RFC 7089](https://www.rfc-editor.org/rfc/rfc7089.html#section-2.1.1) | 64 |
| `Prefer` | [RFC 7240](https://www.rfc-editor.org/rfc/rfc7240.html#section-2) | 200 |
| `Service-Worker` | [W3C Service Workers](https://w3c.github.io/ServiceWorker/#service-worker-script-request) | 20 |
| `Service-Worker-Navigation-Preload` | no specification | 200 |
| `Ping-From` | [WHATWG HTML](https://html.spec.whatwg.org/multipage/links.html#hyperlink-auditing) | 2000 |
| `Ping-To` | [WHATWG HTML](https://html.spec.whatwg.org/multipage/links.html#hyperlink-auditing) | 2000 |
| `Sec-CH-Prefers-Reduced-Data` | no specification | 30 |
| `Sec-Browsing-Topics` | [Topics API](https://patcg-individual-drafts.github.io/topics/#http-headerdef-sec-browsing-topics) | 2048 |
| `Sec-Speculation-Tags` | no specification | 256 |
| `Attribution-Reporting-Eligible` | [Attribution Reporting](https://wicg.github.io/attribution-reporting-api/#attribution-reporting-eligible) | 256 |
| `Attribution-Reporting-Support` | [Attribution Reporting](https://wicg.github.io/attribution-reporting-api/#attribution-reporting-support) | 64 |
| `Sec-Ad-Auction-Fetch` | [Protected Audience](https://wicg.github.io/turtledove/#http-headerdef-sec-ad-auction-fetch) | 10 |
| `Sec-Shared-Storage-Writable` | [Shared Storage](https://wicg.github.io/shared-storage/#http-headerdef-sec-shared-storage-writable) | 10 |
| `Sec-Private-State-Token` | [Private State Tokens](https://wicg.github.io/trust-token-api/#http-headerdef-sec-private-state-token) | 2048 |

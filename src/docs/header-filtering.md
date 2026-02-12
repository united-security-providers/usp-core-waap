# Header Filtering

The header filtering feature allows to filter both request and response header filters.

The two main functionalities are:

* Define a set of header names that are allowed through, while all other headers are removed.
* Define a set of rules to additionally remove headers by regex on the header value.

Header filters can be configured globally and per route, which allows to modify
the above two main functionalities per route without having to list everything that
is  already defined globally.

The merge options are versatile and will be described in detail further below.

Note that it is also possible to only log which filters would be filtered out
without actually doing so, which is useful for initial setup.

## Basic config structure

Header filtering is configured at two places, under `spec.headerFilter`
plus a single setting `spec.routes[].headerFilterRef`:

```yaml
spec:
  headerFilter:
    defaultFilterRef: "my-default"
    routeFilters:
    - name: "my-default"
      # settings...
    - name: "routes-a"
      # settings...
    - name: "routes-b"
      # settings...
routes:
- match:
    path: /one
    pathType: PREFIX
  headerFilterRef: "routes-a"
- match:
    path: /two
    pathType: PREFIX
  headerFilterRef: "routes-a"
- match:
    path: /three
    pathType: PREFIX
  headerFilterRef: "routes-a"
```

Both the default filter ref and refs per route are optional;
if no default filter is referenced and no filter on the route,
header filtering is completely off.

## Filter config settings and basic filtering

Here is a filter config where all items are set:

```yaml
logOnly: false
request:
  enabled: true
  allowClass: STANDARD
  allow:
  - X-Myapp-1
  - X-Myapp-2
  deny:
  - X-Forwarded-For
  denyPattern: 
  - name: X-Myapp-1
    pattern: "^evil-.*$"
  - name: "*"
    pattern: "^EVIL.*$"
response:
  enabled: true
  # no allowClass for response, there is currently only a single implicit allowClass
  allow:       # same as for request
  deny:        # same as for request
  denyPattern: # same as for request
```

See the documentation of the individual items for what they basically do.

The set of effectively allowed headers is informally (merging between per-route and default to be described later):

* `allowPattern` + `allow` - `deny`

Plus if `denyPattern` is set, headers that match the regex
are additionally filtered out.

With the above example config and assuming a request with the following request headers:

* `X-Unknown: Hello`
* `X-Forwarded-For: 1.2.3.4`
* `X-Myapp1: Harmless`
* `X-Myapp2: EVIL`
* (some more headers of STANDARD)

Then the following headers are handled as follows:

* `X-Unknown` - Filtered out, not in STANDARD and not additionally allowed
* `X-Forwarded-For` - Filterered out, would be in STANDARD, but was explicitly denied
* `X-Myapp1: Harmless` - Not filtered out, not in STANDARD, but additionally allowed and not denied by name or regex pattern
* `X-Myapp2: EVIL` - Filtered out, not in STANDARD, additionally allowed and not denied by name, but matched the deny pattern with "*" wildcard header name
* (some more headers of STANDARD) - Only filtered out if matched the deny pattern with "*" wildcard header name

Which headers exactly are in which allow class is specied at the bottom
of this page.

## Merge behavior between per-route and default in detail



## Allow classes

For request headers the following allow classes are defined:

### Request MINIMAL

* `:path`
* `:method`
* `:authority`
* `:scheme`
* `x-forwarded-proto`
* `connection`
* `content-type`
* `content-length`
* `transfer-encoding`
* `expect`
* `x-request-id`

### Request RESTRICTED

* `:path`
* `:method`
* `:authority`
* `:scheme`
* `x-forwarded-proto`
* `connection`
* `content-type`
* `content-length`
* `transfer-encoding`
* `expect`
* `cookie`
* `user-agent`
* `referer`
* `accept`
* `accept-encoding`
* `accept-language`
* `accept-charset`
* `x-request-id`

### Request STANDARD

* `:path`
* `:method`
* `:authority`
* `:scheme`
* `x-forwarded-proto`
* `accept`
* `accept-charset`
* `accept-encoding`
* `accept-language`
* `accept-ranges`
* `access-control-request-headers`
* `access-control-request-method`
* `allow`
* `authorization`
* `cache-control`
* `connection`
* `content-encoding`
* `content-language`
* `content-length`
* `content-location`
* `content-md5`
* `content-range`
* `content-type`
* `date`
* `expect`
* `from`
* `if-match`
* `if-modified-since`
* `if-none-match`
* `if-range`
* `if-unmodified-since`
* `last-modified`
* `location`
* `max-forwards`
* `origin`
* `pragma`
* `proxy-authorization`
* `range`
* `referer`
* `user-agent`
* `transfer-encoding`
* `upgrade`
* `vary`
* `via`
* `warning`
* `www-authenticate`
* `x-requested-with`
* `cookie`
* `sec-websocket-key`
* `sec-websocket-extensions`
* `sec-websocket-protocol`
* `sec-websocket-version`
* `x-request-id`

### Response (implicitly)

* `:status`
* `accept-ranges`
* `access-control-allow-credentials`
* `access-control-allow-headers`
* `access-control-allow-methods`
* `access-control-allow-origin`
* `access-control-expose-headers`
* `access-control-max-age`
* `age`
* `allow`
* `cache-control`
* `connection`
* `content-disposition`
* `content-encoding`
* `content-language`
* `content-length`
* `content-location`
* `content-md5`
* `content-range`
* `content-security-policy`
* `content-security-policy-report-only`
* `content-type`
* `date`
* `etag`
* `expect`
* `upgrade`
* `expect-ct`
* `expires`
* `feature-policy`
* `frame-options`
* `keep-alive`
* `last-modified`
* `location`
* `pragma`
* `proxy-authenticate`
* `public-key-pins`
* `referrer-policy`
* `retry-after`
* `server`
* `set-cookie`
* `strict-transport-security`
* `vary`
* `www-authenticate`
* `x-content-security-policy`
* `x-content-type-options`
* `x-frame-options`
* `x-webkit-csp`
* `sec-websocket-accept`






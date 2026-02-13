# Header Filtering

The header filtering feature allows to filter both request and response header filters.

The two main functionalities are:

* Define a set of header names that are allowed through, while all other headers are removed.
* Define a set of rules to additionally remove headers by regex on the header value.

Header filters can be configured globally and per route, which allows to modify
the above two main functionalities per route without having to list everything that
is  already defined globally.

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
  ...
  headerFilterRef: "routes-a"
- match:
    path: /two
    pathType: PREFIX
  ...
  headerFilterRef: "routes-a"
- match:
    path: /three
    pathType: PREFIX
  ...
  headerFilterRef: "routes-a"
```

Both the default filter ref and per-route filter refs are optional;
if no default filter is referenced and no filter on the route,
header filtering is completely off.

## Filter config settings and basic filtering

Here is a filter config where all individual settings are configured:

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
  allow:       # same structure as for request
  deny:        # same structure as for request
  denyPattern: # same structure as for request
```

See the documentation of the individual settings for what they basically do.

The set of effectively allowed headers is informally as follows:

* `allowPattern` + `allow` - `deny`

Plus if `denyPattern` is set, headers that match the regex
are additionally filtered out.

With the above example config and assuming a request with the following request headers:

* `X-Unknown: Hello`
* `X-Forwarded-For: 1.2.3.4`
* `X-Myapp1: Harmless`
* `X-Myapp2: EVIL`
* (more headers from `STANDARD`)

headers are filtered as follows:

* `X-Unknown` - Filtered out, not in STANDARD and not additionally allowed
* `X-Forwarded-For` - Filterered out, would be in STANDARD, but was explicitly denied
* `X-Myapp1: Harmless` - Not filtered out, not in STANDARD, but additionally allowed and not denied by name or regex pattern
* `X-Myapp2: EVIL` - Filtered out, not in STANDARD, additionally allowed and not denied by name, but matched the deny pattern with "*" wildcard header name
* (more headers from `STANDARD`) - Only filtered out if matched the deny pattern with "*" wildcard header name

Which headers are contained in which allow class
is specied at the bottom of this page.

## Merge behavior between per-route and default in detail

If filtering is defined both per-route and as default,
many useful combinations are possible;
these are described in the following.

For the following settings the logic is the same:

* `logOnly`
* `enabled` (request+response)
* `allowClass`
* `denyPattern` (request+response)

Namely:

* Set per route => pre-route setting is effective (for the matching route)
* Not set per route and set in default => default setting is effective
* Neither set per route nor in default => implicit defaults:
  * `logOnly`: `false`
  * `enabled`: `true`
  * `allowClass`: `STANDARD`
  * `denyPattern`: empty (none)

A special case is if `enabled` is explicitly set to `false` on a route,
then `allow`, `deny` and `denyPatter` are treated as not set.

For `allow` and `deny` not set is treated the same way as set to an empty set.

The complete filter logic with per-route and default settings is:

* If not `enabled` for request resp. response (from per-route if set, else from default if set, else `true`), skip to last step here.
* Start with an empty set of headers.
* If request, add headers from `allowClass` (from per-route if set, else from default if set, else `STANDARD`) to set.
* If response, add headers from implicit allow class to set.
* Add headers from default `allow` to set.
* Remove headers from default `deny` from set.
* Add headers from per-route `allow` to set.
* Remove headers from per-route `deny` from set.
* Remove headers not in the set of headers from request resp. response.
* Remove  headers that match the effective `denyPattern` (from per-route if set, else from default if set, else none) from request resp. response.

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






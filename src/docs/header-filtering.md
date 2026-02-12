# Header Filtering

The header filtering feature allows to filter both request and response header filters.

The two main functionalities are:

* Define a set of header names that are allowed through, while all other headers are rejected.
* Define a set of rules to additionally deny headers by regex on the header value.

Header filters can be configured globally and per route, which allows to modify
the above main functionalities per route without having to list everything that
is  already needed globally.

The merge rules are powerful and will be described in detail in the following.

Note that it is also possible to only log which filters would be filtered out
without actually doing so, which is useful for initial setup.

## Basic config structure

Header filtering is configured at two places below `spec.headerFilter`
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

## Filter Config Settings

Here is a filter config where all items are set:

```yaml
logOnly: false
request:
  enabled: true
  allowClass: STANDARD
  allow:
  - X-Myapp-1
  deny:
  - X-Evil
  denyPattern: 
  - name: X-Maybe-Evil
    pattern: "^evil-.*$"
  - name: "*"
    pattern: "^EVIL.*$"
response:
  enabled: true
  # no allowClass for response, there is currently only an implicit one
  allow:       # same as for request
  deny:        # same as for request
  denyPattern: # same as for request
```




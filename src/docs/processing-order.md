# Processing Order

Core WAAP processes traffic through a fixed pipeline of security features.
Each request from a client passes through the configured features in a defined order before reaching your backend.
Each response passes back through (a subset of) those features on the way out.

The order is deterministic and important. Any feature that runs earlier can block, transform, or short‑circuit traffic so later features may never see the original request or response. 
For example:

* [Rate Limiting](rate-limiting.md) rejecting a flood of requests means [OpenAPI Validation](openapi-validation.md) never has to parse them
* Stripping a header in [Header Filtering](header-filtering.md) changes what [Coraza / CRS](coraza.md) evaluates next.

The same logic applies in reverse on the way back, an early response phase feature can alter or replace a backend response before later features run on it.

This page documents the order in which features run during the request phase and the response phase.

Request phase (note that we start with the client):

```
Client
  │
  ▼
Lua Filters (first)
  │
  ▼
Origin Blocking
  │
  ▼
Rate Limiting
  │
  ▼
Header Filtering
  │
  ▼
CORS Filter
  │
  ▼
CSRF Filter
  │
  ▼
Request Size Enforcement
  │
  ▼
Coraza / CRS / GraphQl
  │
  ▼
Auth
  │
  ▼
OpenAPI
  │
  ▼
ICAP
  │
  ▼
Cookie Manipulation
  │
  ▼
Header Manipulation
  │
  ▼
Lua Filters (last)
  │
  ▼
Backend
```

Response phase (note that we start with the backend):


```
Backend
  │
  ▼
Lua Filters (last)
  │
  ▼
Header Manipulation
  │
  ▼
Cookie Manipulation
  │
  ▼
OpenAPI
  │
  ▼
Auth
  │
  ▼
Coraza / CRS / GraphQl
  │
  ▼
CORS Filter
  │
  ▼
Header Filtering
  │
  ▼
Rate Limiting
  │
  ▼
Lua Filters (first)
  │
  ▼
Custom Error Pages
  │
  ▼
Client
```

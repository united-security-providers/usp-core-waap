# Processing Order

Core WAAP processes traffic through a fixed pipeline of security features.
Each request from a client passes through the configured features in a defined order before reaching your backend.
Each response passes back through (a subset of) those features on the way out.

The order matters. A feature that runs earlier can block, transform, or short-circuit traffic before later features ever see it.
For example:

* [Rate Limiting](rate-limiting.md) rejecting a flood of requests means [OpenAPI Validation](openapi-validation.md) never has to parse them
* Stripping a header in [Header Filtering](header-filtering.md) changes what [Coraza / CRS](coraza.md) evaluates next.

The same logic applies in reverse on the way back, an early response phase feature can alter or replace a backend response before later features run on it.

This page documents the order in which features run during the request phase and the response phase.

Request phase (notice that we start with the client):

```
Client
  │
  ▼
Lua Filters (first)
  │
  ▼
Rate Limiting
  │
  ▼
CORS Filter
  │
  ▼
CSRF Filter
  │
  ▼
Coraza / CRS
  │
  ▼
Origin Blocking
  │
  ▼
Header Filtering
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
Header Manipulation
  │
  ▼
Lua Filters (last)
  │
  ▼
Backend
```

Response phase (notice that we start with the backend):


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
OpenAPI
  │
  ▼
Auth
  │
  ▼
Header Filtering
  │
  ▼
Custom Error Pages
  │
  ▼
Coraza / CRS
  │
  ▼
CSRF Filter
  │
  ▼
CORS Filter
  │
  ▼
Rate Limiting
  │
  ▼
Lua Filters (first)
  │
  ▼
Client
```

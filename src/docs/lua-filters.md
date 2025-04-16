# Lua Filters

Using Lua filters in the USP Core WAAP adds flexibility for custom application integrations.

Filters written in the [Lua programming language](https://www.lua.org/) can be configured to be processed
as part of the regular request/response processing in the USP Core WAAP,
both before and after other filters (like filters for authentication, traffic processing, etc.).

Since the corresponding filter scripts are part of the configuration
of the USP Core WAAP — as opposed to part of a USP Core WAAP binary or release —,
this feature generally adds more flexibility with usually no significant performance impact.
(Lua is a very performant and sophisticated script language with a tiny footprint,
also broadly used in computer games for the same reasons,
and in the case of USP Core WAAP also precompiled with the Lua JIT compiler.)

The Envoy Lua filter usage, including what can be done in filter scripts, is generally described here:

* [envoy/Configuration reference/HTTP/HTTP filters/Lua](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/lua_filter)

The following examples show how to configure and use Lua filtering in the USP Core WAAP,
and provide at the same time some general info and tips regarding how to typically use Lua filters.

## Example 1: Multiple filters, store path, simple Lua module

Here is the `routes` and `lua` configuration for this example:

```yaml
  routes:
    - match:
        path: "/foo"
        pathType: "PREFIX"
      backend:
        address: myhost
        port: 8443
        tls:
          enabled: true
      luaRefs:
        first:
        - filter1.lua
        - filter2.lua
        last:
          # effective order will be reversed, will be the order at spec.lua
        - filter3.lua
        - filter2.lua
    - match:
        path: "/bar"
        pathType: "PREFIX"
      backend:
        address: myhost
        port: 8443
        tls:
          enabled: true
      luaRefs:
        first:
        - filter1.lua
  lua:
    configMap: "lua-basic-config-map"
    filters:
    - name: filter1.lua
    - name: filter2.lua
    - name: filter3.lua
    helpers:
    - name: util.lua
```

There are two locations:

* `/foo`
    * `filter1` and `filter2` referenced as "first" Lua filters
      will be run in that order before all other filters
      (authentication, traffic processing, "last" Lua filters)
    * `filter3` and `filter2` referenced as "last" Lua filters
      will be run in the order `filter2` then `filter3` after all other filters
      (except the final filter that routes to the backend)
    * **Note** that the order in which filters are run is the order listed at `spec.lua`,
      not the order listed at `spec.routes.luaRefs.first|last`;
      this is essentially an architectural limitation of the underlying Envoy proxy.
* `/bar`
    * Just `filter1` will be run as first filter.

The Lua filter and helper scripts are defined in a config map named `lua-basic-config-map`.
They only do some logging but do not modify request/response in this example. 
Besides the simple example in filter1.lua, filter2.lua and filter3.lua illustrate how utility functions from other scripts can be used (Lua module).

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: "lua-basic-functionality-config-map"
  namespace: {{.Values.namespace}}
data:
  filter1.lua: |
    local path
    function envoy_on_request(request_handle)
        path = request_handle:headers():get(':path')
        request_handle:logInfo('[REQ] ' .. path .. ' filter1')
    end
    function envoy_on_response(response_handle)
        response_handle:logInfo('[RES] ' .. path .. ' filter1')
    end
  filter2.lua: |
    local util = require 'opt.usp.core-waap.lua.filters.util'
    local path
    function envoy_on_request(request_handle)
        path = util.getPath(request_handle)
        util.logFilter(request_handle, 'REQ', path, 'filter2')
    end
    function envoy_on_response(response_handle)
        util.logFilter(response_handle, 'RES', path, 'filter2')
    end
  filter3.lua: |
    local util = require 'opt.usp.core-waap.lua.filters.util'
    local path
    function envoy_on_request(request_handle)
        path = util.getPath(request_handle)
        util.logFilter(request_handle, 'REQ', path, 'filter3')
    end
    function envoy_on_response(response_handle)
        util.logFilter(response_handle, 'RES', path, 'filter3')
    end
  util.lua: |
    local meta = { }

    -- get path from request
    function getPath(request_handle)
        return request_handle:headers():get(':path')
    end
    meta.getPath = getPath

    -- log direction, path and filter name as given
    function logFilter(handle, direction, path, filter)
      handle:logInfo('[' .. direction .. '] ' .. path .. ' ' .. filter)
    end
    meta.logFilter = logFilter

    return meta
```

Some things worth noting:

* The local variable `path` that is defined outside the two handlers for request and response
  is set in the request handler and available that way also in the response handler.
* Both local and global variables defined that way are not available
  to other filter scripts nor to the same filter when processing a different request/response.
* Lua filters and helper files (which are not limited to Lua scripts) are all deployed to the
  directory `/opt/usp/core-waap/lua/filters`.
    * To use a helper Lua script e.g. `util.lua` that implements a Lua module use `require`
      as in the scripts above with module path `opt.usp.core-waap.lua.filters.util`,
      which finds the Lua file at `/opt/usp/core-waap/lua/filters/util.lua`.
    * To read or use the content of a helper file of any kind, use the full path in Lua scripts,
      e.g. to use a helper file `config.xml` use the path `/opt/usp/core-waap/lua/filters/config.xml`.

This produces the following log entries for a GET request first to `/foo` and then one to `/bar`
(log prefixes removed below):


```
[REQ] /foo filter1
[REQ] /foo filter2
[REQ] /foo filter2
[REQ] /foo filter3
[RES] /foo filter3
[RES] /foo filter2
[RES] /foo filter2
[RES] /foo filter1
[REQ] /bar filter1
[RES] /bar filter1
```

Note that filters that come first when processing the request come last when processing the response.

## Example 2: Share data between filters in same request

Sometimes it is helpful to be able to share some data between filters,
for example  if some data that can only be obtained in a "first" filter
is needed in a "last" filter.

The underlying mechanism is called "dynamic metadata" in Envoy.

Here is a `util.lua` Lua module that would be defined as a helper script
in the USP Core WAAP configuration (see example 1 above):

```lua
local meta = { }

-- store given value under given key in given context
function set(handle, contextId, key, value)
    handle:streamInfo():dynamicMetadata():set(contextId, key, value)
end
meta.set = set

-- retrieve given value under given key from given context
function get(handle, contextId, key)
    local context = handle:streamInfo():dynamicMetadata():get(contextId)
    if context == nil then
        return nil
    else
        return context[key]
    end
end
meta.get = get

return meta
```

The module would be used as in example 1, i.e. first required like this:

```lua
local util = require 'opt.usp.core-waap.lua.filters.util'
```
Then it could be used in filter request and response handlers in the following way,
where `handle` could be both a request or response handle.

Store value `myValue` with key `myKey` in shared context with id `contextId`:

```lua
util.set(handle, 'contextId', 'myKey', 'myValue')
```

Retrieve value with key `myKey` from shared context with id `contextId`:

```lua
local value = util.get(handle, 'contextId', 'myKey')
```

Note that this data is stored exclusively per single request/response transaction.
Other requests have no access to "dynamic metadata" of another request.

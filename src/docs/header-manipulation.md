# Header Manipulation

The header manipulation feature allows to manipulate both request and response headers.

The following manipulation actions are supported:

* `APPEND_IF_EXISTS`: Search for the specified header and append the value only if it exists
* `ADD_IF_ABSENT`: Add header with specified value only if it does not exist yet
* `OVERWRITE_IF_EXISTS`: Search for the specified header and replace its value
* `OVERWRITE_IF_EXISTS_OR_ADD`: Search for the specified header and replace its value or add the header if it does not exist yet
* `REMOVE`: Search for the specified header and remove it

For more information about these actions, please check the
[api reference](https://docs.united-security-providers.ch/usp-core-waap/latest/crd-doc/#corewaapservicespecheadermanipulationconfigurationsindexrequestindexaction).

## Basic config structure

Header manipulation is defined under `spec.headerManipulation`
and referenced on each individual route with `spec.routes[].headerManipulationRef`:

```yaml
spec:
  headerManipulation:
    configurations:
    - name: "routes-a"
      request:
      - name: X-Header-A
        value: Added-By-Core-WAAP
        action: OVERWRITE_IF_EXISTS_OR_ADD
      response:
      - name: X-Secret-Credentials
        action: REMOVE
routes:
- match:
    path: /a
    pathType: PREFIX
  ...: ...
  headerManipulationRef: "routes-a"
```

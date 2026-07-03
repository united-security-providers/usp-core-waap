# Cookie Manipulation

The header manipulation feature allows to manipulate both `Cookie` request headers
and `Set-Cookie` response headers with fine-grained control down to cookie attributes.

The following manipulation actions are supported for cookies:

* `ADD_IF_ABSENT`:
  Add the cookie only if no cookie with the same name is present
* `OVERWRITE_IF_EXISTS_OR_ADD`:
  Replace the cookie value if it exists, otherwise add it
* `OVERWRITE_IF_EXISTS`:
  Replace the cookie value if it exists, otherwise do nothing
* `REMOVE`: Remove all cookies with the given name
* `MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT`:
   For response only: do not change the cookie value,
   modify its attributes if it is present

The same manipulation actions except `MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT`
also exist for the cookie attributes.

For more information about these actions, please check the api_reference for
[cookies](https://docs.united-security-providers.ch/usp-core-waap/latest/crd-doc/#corewaapservicespeccookiemanipulationconfigurationsindexrequestindexaction)
and [attributes](https://docs.united-security-providers.ch/usp-core-waap/latest/crd-doc/#corewaapservicespeccookiemanipulationconfigurationsindexrequestindexattributesindexaction).

## Basic config structure

Cookie manipulation is defined under `spec.cookieManipulation`
and referenced on each individual route with `spec.routes[].cookieManipulationRef`.

Here an example that modifies two cookie attributes if the cookie is present:

```yaml
spec:
  cookieManipulation:
    configurations:
    - name: "secure-ref"
      logOnly: true
      response:
      - name: "sessionId"
        action: "MODIFY_ATTRIBUTES_IF_COOKIE_PRESENT"
        attributes:
        - name: "SameSite"
          value: "Strict"
          action: "OVERWRITE_IF_EXISTS_OR_ADD"
        - name: "Max-Age"
          value: "3600"
          action: "ADD_IF_ABSENT"
routes:
- match:
    path: /a
    pathType: PREFIX
  ...: ...
  cookieManipulationRef: "secure-ref"
```

It is also possible to define a default cookie manipulation
with `spec.cookieManipulation.defaultManipulationRef` that
would be applied on all routes except where overriden per route.

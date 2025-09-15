# OAuth2 / OIDC

!!! danger

    We advise against using **long lived refresh tokens**.
    Even if the ID token and access token are short lived,
    a long lived refresh token kept client-side (even encrypted)
    can be stolen and later used to obtain new tokens.

## Token cookies encryption

OAuth2 / OIDC tokens in session cookies are **encrypted by default**.
To disable encryption, set the following configuration:

```yaml
spec:
  operation:
    auth:
      tokenEncryption: false
```

However, turning off encryption is **not recommended**.
Encryption should only be disabled for debugging purposes or if you are sure you need information stored in theses tokens.

## Signout

TBD

## Response on invalid access tokens

By default, requests with invalid or expired access tokens are redirected (HTTP 302) to the authentication page.
For some applications (e.g. SPA) this may be undesirable.
The WAF can be configured to return a deny response (HTTP 401) instead of a redirect.

Example:

```yaml
spec:
  authentications:
    - name: auth
      ...
      denyRedirectMatcher:
        enabled: true
        headerName: "Sec-Fetch-Dest"
        expectedHeaderValue: "empty"
        headerValueType: "EXACT"
```

For more information check the API reference.

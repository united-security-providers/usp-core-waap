# OAuth2 / OIDC

Configuration of the OAuth2 / OIDC client at `spec.authentications[]` is quite straightforward,
but there are some things you should be aware of for optimal and secure usage.

## Session store in cookies

The Core WAAP stores its OIDC / OAuth login session in essentially three cookies,
for `id_token`, `access_token` and `refresh_token`.

This means that some caution is required regarding the validity period of the
`refresh_token` (which is configured on the OP). The longer that validity period is,
the more likely an attacker could get access to the cookies on the client machine
and use them to login without having to present user credentials.

!!! danger

    We advise against using **long-lived refresh tokens**.
    Even if the ID token and access token are short-lived,
    a long-lived refresh token kept client-side (even encrypted)
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
Normally, encryption should only be disabled temporarily for debugging purposes
during integration and to resolve issues during operation.

## Logout

Logout is initiated with a GET request to `https://{host}/core-waap/oauth/{realm}/signout'`.

By default, logout is only performed on the OAuth2/OIDC client/RP,
i.e. only on the Core WAAP, but not on the OP.
More precisely, session cookies are deleted
and the HTTP client receives a redirect to the root location `/` on the Core WAAP.

This means that the user remains logged in at the OP;
in other words, if the user tries to access a protected location again shortly afterward,
the user is redirected to the OP and is automatically logged in again.

In the case of OIDC,
the Core WAAP supports a logout additionally also at the OP.
It is initiated at the same location as indicated above,
but with an additional config setting `spec.authentications[].endSessionEndpoint`,
where you set the URL at the OP for logout.
(The requested redirect for after OP logout is again the root location `/` on the Core WAAP.)

## Response on invalid access tokens

By default, requests with invalid or expired access tokens are redirected (HTTP 302) to the authentication page.
For some applications (e.g. SPA) this may be undesirable.
The Core WAAP can be configured to return a deny response (HTTP 401) instead of a redirect.

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

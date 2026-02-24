# Coraza

## What is Coraza?

Roughly speaking, Coraza is the same as ModSecurity / OWASP CRS except
for some technical implementation details.

Its main purpose is to provide protection of websites with the
[OWASP Core Rule Set (CRS)](https://owasp.org/www-project-modsecurity-core-rule-set/):

_The OWASP CRS is a set of generic attack detection rules
for use with [ModSecurity](https://modsecurity.org/)
or compatible web application firewalls.
It aims to protect web applications from a wide range of attacks,
including the [OWASP Top Ten](https://owasp.org/www-project-top-ten/),
with a minimum of false alerts.
CRS provides protection against many common attack categories,
including SQL Injection, Cross Site Scripting, Local File Inclusion, etc._

## Technical Details

The website of the OWASP Coraza project ([coraza.io](https://coraza.io/))
links to the main implementation of the Coraza library at GitHub
[corazawaf/coraza](https://github.com/corazawaf/coraza),
described with
"OWASP Coraza WAF is a golang modsecurity compatible web application firewall library".

In other words,
it is a port of [ModSecurity](https://modsecurity.org/)
from the original implementation in the C programming language
to the Go programming language (Golang),
with the main purpose of providing protection of websites
to newer architectures where Go is prominently used,
including in the cloud (Kubernetes, etc.).

Note that the relation to CRS is even in the name,
emphasized if written as _CoRaZa_,
with "coraza" in Spanish meaning an armor
or generally a shield or protective barrier.

## United Security Provider's Contribution

**United Security Providers** has implemented a
**Golang filter for the Envoy reverse proxy**
that provides the functionality of Coraza for Envoy
– and thus also for the Core WAAP –,
and has made it available as **Open Source** on GitHub at
[united-security-providers/coraza-envoy-go-filter](https://github.com/united-security-providers/coraza-envoy-go-filter).

This filter provides the general functionality via Seclang directives,
namely things like limiting HTTP request and/or response size
and, of course, activating OWASP CRS rule sets,
plus the ability to tweak things.

In the **Core WAAP**, there are the following **major additions**:

* **Simplicity:**
  No need to write/maintain Seclang directives,
  those are generated automatically from a few simple setttings.
* **GraphQL Protection:**
  Via a proprietary plugin for the Coraza filter,
  GraphQL can be specifically protected.
* **Auto-Learning:**
  Via a [command line tool](autolearning.md),
  rule exceptions for CRS and maxima for GraphQL can be
  automatically learned from logs.

Note that including GraphQL validation as part of Coraza has the
implicit benefit that buffer allocation and JSON parsing is only
done once on routes where both CRS and GraphQL validation are active,
thus reducing memory and CPU footprint.

In the future further dedicated validations might be added,
with potentially similar benfits.

!!! tip

We have implemented performance optimizations in the Coraza filter
compared to the general Coraza implementation.
Even though we test compatibility with CRS rules in detail (FTW test suite),
it is possible to turn off these optimizations in case there would be
compatibility problems in practice, using the settings
`spec.coraza.useRe2` and `spec.coraza.useLibinjection`.

## Core WAAP Coraza Settings

* Settings regarding Coraza in general (e.g. activation or request size limits)
  are specified at `spec.coraza` and `spec.routes[].coraza`
  in the [API Reference](crd-doc.md).
* Settings regarding specifically CRS
  are specified at `spec.coraza.crs` and `spec.routes[].coraza.crs`
  in the [API Reference](crd-doc.md),
  plus there is a basic overview in the section [*CRS*](coraza-crs.md).
* Settings regarding specifically GraphQL
  are specified at `spec.coraza.graphql` and `spec.routes[].coraza.graphql`
  in the [API Reference](crd-doc.md),
  plus there is a basic overview in the section [*GraphQL*](coraza-graphql.md).

!!! tip

Note that `spec.coraza.enabled` and per route `spec.routes[].coraza.enabled`
decide whether the Coraza filter is inserted at all at a given route.
The Coraza filter needs to be inserted if either CRS or GraphQL validations are to be done.
Whether CRS is active on a route is defined by `spec.coraza.defaultEnabled`
and `spec.routes[].coraza.crs.enabled`.
Whether GraphQL validation is active on a route is defined by
`spec.routes[].coraza.graphql.enabled`.

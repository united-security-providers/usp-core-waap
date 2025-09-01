# Coraza

## What is Coraza?

From a technical point of view
"OWASP **Coraza** WAF is a golang modsecurity compatible web application firewall library",
as it states on the [GitHub page](https://github.com/corazawaf/coraza)
for the OWASP **Coraza** project ([coraza.io](https://coraza.io/)),
in other words, it is a port of [ModSecurity](https://modsecurity.org/)
from the original implementation in the C programming language
to the Go programming language (Golang).

Its main purpose is to provide protection of websites with the
[OWASP Core Rule Set (CRS)](https://owasp.org/www-project-modsecurity-core-rule-set/)
to newer architectures where Go is prominently used,
including in the cloud (Kubernetes, etc.).

_The OWASP CRS is a set of generic attack detection rules
for use with [ModSecurity](https://modsecurity.org/)
or compatible web application firewalls.
It aims to protect web applications from a wide range of attacks,
including the [OWASP Top Ten](https://owasp.org/www-project-top-ten/),
with a minimum of false alerts.
CRS provides protection against many common attack categories,
including SQL Injection, Cross Site Scripting, Local File Inclusion, etc._

The relation to CRS is even in the name: CoRaZa,
where "coraza" stands in Spanish for an armor
or generally for a shield or protective barrier.

## Protection by Coraza in the Core WAAP

### Sizes and CRS

United Security Providers has implemented a Golang filter
for the Envoy reverse proxy that provides the functionality
of Coraza for Envoy – and thus also for the Core WAAP –,
and has made it available as Open Source on GitHub at
[united-security-providers/coraza-envoy-go-filter](https://github.com/united-security-providers/coraza-envoy-go-filter).

The Open Source filter provides essentially two layers of protection:

* Allows to limit sizes of request body and response, plus related details.
  See `spec.coraza` and `spec.routes[].coraza` settings in the [API Reference](crd-doc.md)
  and also the section [Large Payloads](large-payloads.md).
* Validation of requests and responses using the OWASP Core Rule Set (CRS)
  including its various customization options,
  specified at `spec.coraza.crs` and `spec.routes[].coraza,crs`,
  see section [CRS](coraza-crs.md).

### GraphQL etc.

In addition, with USP-proprietary extensions of the Open Source Coraza filter,
the Core WAAP supports:

* Protection specifically for GraphQL queries, see [GraphQL](coraza-graphql.md),
  specified at `spec.coraza.crs` and `spec.routes[].coraza,crs`.
* Possibly in the future further dedicated validations...

Note that the general size protection of Coraza listed further above
applies equally for GraphQL.

Also note that buffering and JSON parsing for GraphQL is handled
by Coraza, hence there is much less memory and CPU overhead than
there would be for an independent implementation.

### Auto-Learning

For both CRS and GraphQL, the [Auto-Learning CLI](autolearning.md)
allows to learn from logs and automatically add learned rules to the configuration.
Sources and targets can be local files or directly accessed in a Kubernetes cluster.

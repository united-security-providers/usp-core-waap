> For AI agents: this documentation is indexed at https://docs.united-security-providers.ch/usp-core-waap/llms.txt, and every page is available as markdown at its own address plus index.md.

# USP Core WAAP

USP Core WAAP (Web Application and API Protection) provides secure access to web-based applications and resources,
while simplifying the process of configuration and deployment.

> [!TIP]
> The current **[Helm chart](operation/helm/usage.md)** version for the **[USP Core WAAP operator](operation/helm/usage/#install-operator)** is : **2.1.1**

## Overview

For Kubernetes we provide the Core WAAP Operator which deploys Core WAAP based on a Custom 
Resource with the respective services and pods. With Core WAAP, the security configuration can be fully integrated in applications continuous integration and delivery process 
while enabling developers move from DevOps to SecDevOps.

![Core WAAP Overview](assets/images/core-waap-illustration1.png)

## Configuring Core WAAP

A basic Core WAAP configuration looks as follows.

![Core WAAP configuration example](assets/images/core-waap-editor-demo.gif)

## Getting Started

New to Core WAAP? The **[Getting Started guide](getting-started.md)** walks you through installing the operator and
protecting an example application (OWASP Juice Shop) with a `CoreWaapService` custom resource.

To pull the Operator helm chart and corresponding container images you need a key. Get in contact with us, we are looking forward to support you.
[Web Application &#038; API Protection (WAAP) &#8211; United Security Providers AG](https://www.united-security-providers.ch/technology/application-security/web-application-api-protection-waap/#more)

If you want to try the Core WAAP yourself head over to the [Killercoda Core WAAP scenarios](https://killercoda.com/united-security-providers).

## Pages

- [Getting Started](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/getting-started/index.md)
- [Core WAAP Release Notes](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/core-waap-releasenotes/index.md)
- [API Reference](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/crd-doc/index.md)
- [Processing Order](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/processing-order/index.md)
- [Coraza](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/coraza/coraza/index.md)
- [CRS Basic Usage](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/coraza/coraza-crs/index.md)
- [GraphQL Basic Usage](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/coraza/coraza-graphql/index.md)
- [Header Filtering](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/header-filtering/index.md)
- [Header Manipulation](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/header-manipulation/index.md)
- [Cookie Manipulation](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/cookie-manipulation/index.md)
- [Error Mapping](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/error-mapping/index.md)
- [Native Config Post-Processing (NCPP)](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/native-config-post-processing/index.md)
- [ICAP Antivirus Scanning](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/icap-antivirus-scanning/index.md)
- [OpenAPI Validation](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/openapi-validation/index.md)
- [Virtual Patch](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/crs-virtual-patch/index.md)
- [Lua Filters](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/lua-filters/index.md)
- [Rate Limiting](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/configuration/rate-limiting/index.md)
- [Helm Charts](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/helm/usage/index.md)
- [usp-core-waap-operator](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/helm/values/index.md)
- [Updating Core WAAP Operator](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/upgrade/index.md)
- [Logs and Metrics](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/logs-metrics/index.md)
- [Auto-Learning](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/autolearning/index.md)
- [Handling large request and response payloads with OWASP CRS attack detection](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/large-payloads/index.md)
- [OAuth2 / OIDC](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/oidc-operation/index.md)
- [Debugging](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/operation/debugging/index.md)
- [Downloads](https://docs.united-security-providers.ch/usp-core-waap/2.1.x/downloads/index.md)

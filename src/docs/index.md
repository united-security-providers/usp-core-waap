# USP Core WAAP

USP Core WAAP (Web Application and API Protection) provides secure access to web-based applications and resources,
while simplifying the process of configuration and deployment.

* Current Helm charts version for USP Core WAAP operator : [%CHARTS_VERSION%](helm-CHANGELOG.md)
    * Current USP Core WAAP operator release version: [%OPERATOR_VERSION%](operator-CHANGELOG.md)
    * Current Core WAAP Proxy image: [%CORE_WAAP_PROXY_VERSION%](waap-proxy-CHANGELOG.md)
        * Current extProc ICAP image: [%EXT_PROC_ICAP_VERSION%](ext-proc-icap-CHANGELOG.md)
        * Current extProc OpenAPI image: [%EXT_PROC_OPENAPI_VERSION%](ext-proc-openapi-CHANGELOG.md)

## Overview

For Kubernetes we provide the Core WAAP Operator which deploys Core WAAP based on a Custom 
Resource with the respective services and pods. With Core WAAP, the security configuration can be fully integrated in applications continuous integration and delivery process 
while enabling developers move from DevOps to SecDevOps.

![Core WAAP Overview](assets/images/core-waap-illustration1.png)

## Configuring Core WAAP

A basic Core WAAP configuration looks as follows.

![Core WAAP configuration example](assets/images/core-waap-editor-demo.gif)

## Getting Started

To pull the Operator helm chart and corresponding container images you need a key. Get in contact with us, we are looking forward to support you.
[Web Application &#038; API Protection (WAAP) &#8211; United Security Providers AG](https://www.united-security-providers.ch/technology/application-security/web-application-api-protection-waap/#more)

If you want to try the Core WAAP yourself head over to the [Killercoda Core WAAP scenarios](https://killercoda.com/united-security-providers).

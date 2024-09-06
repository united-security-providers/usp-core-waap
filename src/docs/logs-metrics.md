# Updating Core WAAP Operator

Logs about Core WAAP's http request/response processing and possible security policy violation events are crucial for the visibility of the target web application or API operation.
Core WAAP Operator logs allow to monitor configuration change events. Besides logs, metrics offer quantitative data on aspects like traffic volume, response times, and blocked threats, enabling the monitoring of Core WAAP effectiveness over time and identifying trends or anomalies.

The Core WAAP components log to the standard out in JSON format and can be used by customers log stack for further processing and visualization. Metrics can be scraped with Prometheus for example. Therefore Core WAAP's adminInterface has to be configured accordingly. Therefore check the [API Description](crd-doc.md) for `spec.operation.adminInterfaceService`. Metrics are exposed on the admin interface `/stats/prometheus`

How the log and monitoring stack is beyond the scope of this documentation. We simply provide examples for OpenSearch and Grafana which can be [downloaded here](downloads.md).
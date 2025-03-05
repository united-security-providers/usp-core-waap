# Auto-Learning

USP Core WAAP provides a command-line tool that allows to update configuration of an existing USP Core WAAP instance
based on the information from its runtime log files.

When 'crs' processor is enabled, it will analyze 'false positives' of Coraza (ModSecurity/CRS) engine and generate rule exceptions to avoid them.

With 'methods' processor, it will analyze all requests and generate 'allowedMethods' sections for the existing routes.

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-%OPERATOR_VERSION%.jar --help` to see usage:

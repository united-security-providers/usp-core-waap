# Auto-Learning

USP Core WAAP provides a command-line tool that allows to apply an automated learning mechanism to generate a set
of rules for Coraza (ModSecurity).

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

```
Usage: java -jar waap-lib-spec-cli-<version>.jar [-hV] [-o=<out>] <in>
Converts a USP Core WAAP config YAML to native Envoy config.
Copyright (c) 2023 United Security Providers AG, Switzerland, All rights
reserved.
      <in>          The USP Core WAAP config YAML file.
  -h, --help        Show this help message and exit.
  -o, --out=<out>   Directory for target Envoy configuration, defaults to
                      current working directory.
  -V, --version     Print version information and exit.

```


[downloaded here]: /downloads/
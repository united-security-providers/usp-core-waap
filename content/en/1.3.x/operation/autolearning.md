---
title: 'Auto-Learning'
weight: 210
aliases:
  - '../autolearning/'
---
# Auto-Learning

USP Core WAAP provides a command-line tool that allows to update configuration of an existing USP Core WAAP instance
based on the information from its runtime log files.

When 'crs' processor is enabled, it will analyze 'false positives' of Coraza (ModSecurity/CRS) engine and generate rule exceptions to avoid them.

With 'methods' processor, it will analyze all requests and generate 'allowedMethods' sections for the existing routes.

The tool itself is an executable Java archive (jar) and can be [downloaded here](../downloads.md).

Run with `java -jar waap-lib-autolearn-cli-1.2.0.jar --help` to see usage:

```
Usage: java -jar waap-lib-autolearn-cli-<version>.jar [-hV] ([-i=<specIn>
       -l=<log>] | [-n=<namespace> -w=<instance>]) [[-o=<specOut>]] [[crs]
       [methods]] [[-t=<range>] [-e=<errorFile>] [-s]] [[--skippostparts]
       [--skipmetadataexport] [--sortexceptions] [--reduceconfigured]]
Autolearns CRS rule exceptions and methods whitelisting from USP Core WAAP log
files.
Copyright (c) United Security Providers AG, Switzerland, All rights reserved.
  -h, --help                 Show this help message and exit.
  -V, --version              Print version information and exit.
file input
  -i, --waapspecin=<specIn>  USP Core WAAP spec file (or manifest file) to
                               read, use '-' for stdin, exclusive with -n/-w.
  -l, --log=<log>            USP Core WAAP log file to parse, exclusive with
                               -n/-w.
k8s instance input
  -n, --namespace=<namespace>
                             Kubernetes namespace with USP Core WAAP, exclusive
                               with -i/-l.
  -w, --waapinstance=<instance>
                             Kubernetes USP Core WAAP instance name (app.
                               kubernetes.io/instance), exclusive with -i/-l.
output
  -o, --waapspecout=<specOut>
                             USP Core WAAP spec file (or manifest file) to
                               write, defaults to 'waap.yaml', use '-' for
                               stdout (then automatically also -s).
processors
      crs                    Autolearns CRS rule exceptions
      methods                Autolearns methods whitelisting
common options
  -e, --errorfile=<errorFile>
                             File to write errors to, optional, by default no
                               file is written.
  -s, --silent               No output to stdout with number of learned rules
                               and errors.
  -t, --timerange=<range>    Optional time range to learn from, e.g.
                               "20231201.1010-20231202.1010" (time with
                               minutes).
CRS mode options
      --reduceconfigured     Changes already configured exceptions by removing
                               a) duplicates & b) more specific rules in favor
                               of more general ones
      --skipmetadataexport   Skip metadata export.
      --skippostparts        Skip part name parsing for ARGS_POST.
      --sortexceptions       Sort rule exceptions in the output.
```

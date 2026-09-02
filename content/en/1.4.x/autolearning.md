---
title: 'Auto-Learning'
weight: 210
---
# Auto-Learning

USP Core WAAP provides a command-line tool that allows to update configuration of an existing USP Core WAAP instance
based on the information from its runtime log files.

There are different processing options that can be activated independently:

* `crs`: Learns 'false positives' of the Coraza (ModSecurity/CRS) engine and generates rule exceptions to avoid them.
* `graphql`: Learns maxima for complexity, length and batch size and generates settings to allow them.
* `methods`: Learns allowed HTTP methods for configured routes and generates 'allowedMethods' settings for those routes.

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-1.3.1.jar --help` to see usage:

```
Usage: java -jar waap-lib-autolearn-cli-<version>.jar [-hV] ([-i=<specIn>
       -l=<log>] | [-n=<namespace> -w=<instance>]) [[-o=<specOut>]] [[crs]
       [graphql] [methods]] [[-t=<range>] [-e=<errorFile>] [-s]]
       [[--skippostparts] [--skipmetadataexport] [--sortexceptions]
       [--reduceconfigured]]
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
      crs                    Autolearns CRS rule exceptions (defaulting to the
                               new spec.coraza.crs settings over the legacy
                               spec.crs settings unless only the legacy spec.
                               crs settings are present or only those are
                               enabled)
      graphql                Autolearns max. values for GraphQL queries
      methods                Autolearns HTTP methods whitelisting
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

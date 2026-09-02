---
title: 'Auto-Learning'
weight: 210
---
# Auto-Learning

USP Core WAAP provides a command-line tool that allows to apply an automated learning mechanism to generate a set
of rules for Coraza (ModSecurity/CRS).

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-1.1.0.jar --help` to see usage:

```
Usage: java -jar waap-lib-autolearn-cli-<version>.jar [-hsV]
       [--reduceconfigured] [--skipmetadataexport] [--skippostparts]
       [--sortexceptions] [-e=<error>] [-i=<specIn>] [-l=<log>]
       [-n=<namespace>] [-o=<specOut>] [-t=<range>] [-w=<instance>]
Autolearns CRS rule exceptions from USP Core WAAP log files.
Copyright (c) United Security Providers AG, Switzerland, All rights reserved.
  -e, --errorfile=<error>    File to write errors to, optional, by default no
                               file is written.
  -h, --help                 Show this help message and exit.
  -i, --waapspecin=<specIn>  USP Core WAAP spec file (or manifest file) to
                               read, use '-' for stdin, exclusive with -n/-w.
  -l, --log=<log>            USP Core WAAP log file to parse, exclusive with
                               -n/-w.
  -n, --namespace=<namespace>
                             Kubernetes namespace with USP Core WAAP, exclusive
                               with -i/-l.
  -o, --waapspecout=<specOut>
                             USP Core WAAP spec file (or manifest file) to
                               write, defaults to 'waap.yaml', use '-' for
                               stdout (then automatically also -s).
      --reduceconfigured     Changes already configured exceptions by removing
                               a) duplicates & b) more specific rules in favor
                               of more general ones
  -s, --silent               No output to stdout with number of learned rules
                               and errors.
      --skipmetadataexport   Skip metadata export.
      --skippostparts        Skip part name parsing for ARGS_POST.
      --sortexceptions       Sort rule exceptions in the output.
  -t, --timerange=<range>    Optional time range to learn from, e.g.
                               "20231201.1010-20231202.1010" (time with
                               minutes).
  -V, --version              Print version information and exit.
  -w, --waapinstance=<instance>
                             Kubernetes USP Core WAAP instance name (app.
                               kubernetes.io/instance), exclusive with -i/-l.
```

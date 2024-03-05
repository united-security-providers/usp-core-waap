# USP Core WAAP

Welcome to the USP Core WAAP (Web Application and API Protection) customers repository.

This requires `mkdocs` to generate the website and deploy it to GitHub pages. 

## Generate site

To just generate the site, run

----
$ ./release.sh
----

## Generate and deploy to GitHub

To generate the site and deploy it to GitHub pages, run

----
$ ./release.sh deploy
----

## Local testing

Generate the site without deploying it, then run `mkdocs` to serve it locally:

----
$ ./release.sh
$ mkdocs serve
----

This will make it available locally (URL visible in output on the shell).


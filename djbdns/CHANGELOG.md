## v0.99.2:

* [COOK-1042] - Corrected a syntax error in axfr.
* [COOK-740] - use correct directory for tinydns root data

## Previous versions:

The various recipes now support multiple service types. This is controlled with the `node[:djbdns][:service_type]` attribute, which is set by platform in the default recipe.

ArchLinux support has been added, as well as naively attempting other platforms by source-compiled installation with bluepill for service management.

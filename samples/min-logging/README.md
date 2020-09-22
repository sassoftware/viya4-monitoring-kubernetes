# Minimal Logging Sample

This sample demonstrates a customization to the logging deployment
to minimize resource usage by configuring single instances of each
component. This configuration could save both CPU and memory resources
in development and test environments, for example.

## Installation

Copy this directory to a separate local path then set the `USER_DIR`
environment variable to this path:

```bash
export USER_DIR=/your/path/to/min-logging
```

Deploy logging normally:

```bash
logging/bin/deploy_logging_open.sh
```

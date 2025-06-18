# SAS® Viya® Monitoring for Kubernetes Security Policy

Project maintainers and community contributors take security issues seriously. We appreciate efforts to disclose potential issues responsibly and will acknowledge viable contributions. To aid in the investigation of reported vulnerabilities, please follow the [reporting guidelines](#reporting-guidelines) outlined below.

## Scope of Security Reports

### In Scope
The following components are directly maintained by this project and should be reported through our security reporting process:

* Custom deployment scripts and automation code
* Project-specific configuration files and templates
* Custom Kubernetes manifests and Helm charts
* Project documentation and guidance
* Any other artifacts created and maintained specifically by the SAS Viya Monitoring project

### Out of Scope
This project deploys and configures various third-party open-source monitoring tools. For a complete inventory of third-party components used by this project, please refer to [ARTIFACT_INVENTORY.md](ARTIFACT_INVENTORY.md).

Vulnerabilities in these underlying components should be reported to their respective projects. For example:

* Grafana - Report via [Grafana Security](https://github.com/grafana/grafana/security)
* Prometheus - Report via [Prometheus Security](https://github.com/prometheus/prometheus/security)
* OpenSearch - Report via [OpenSearch Security](https://github.com/opensearch-project/OpenSearch/security)

If you're unsure whether a vulnerability belongs to our project's code or an underlying component, please submit the report through our process and we will help direct it to the appropriate team.

## Reporting Guidelines

To report a suspected security issue that is in scope for this project, use GitHub's private vulnerability reporting:

1. Click the `Security` tab
2. Click the `Report a vulnerability` button

Please provide the following information with your security report:

* Your name and affiliation (if applicable)
* Version/build-date of the SAS Viya Monitoring project
* Detailed description of the security issue
* Steps to reproduce the issue
* Impact of the vulnerability
* Any known public information about this vulnerability (e.g., related CVE, security advisory)
* Whether the vulnerability exists in the latest version
* Suggested fixes or mitigations (if any)

## Recognition

Contributors who responsibly disclose security vulnerabilities will be acknowledged in our release notes (unless they prefer to remain anonymous).

## Additional Information

For general questions about the project's security, please open a regular GitHub issue. Do not include sensitive security-related details in public issues.

Note: This security policy may be updated from time to time. Please refer to the latest version in the repository.

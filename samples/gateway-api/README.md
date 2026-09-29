# Gateway API

## Overview

This sample demonstrates how to configure [Gateway API](https://gateway-api.sigs.k8s.io/)
resources for accessing the web applications that are deployed as part of the SAS
Viya Monitoring for Kubernetes solution.

Gateway API is the vendor-neutral ingress standard published by Kubernetes
SIG-Network. Its core resources (`GatewayClass`, `Gateway`, `HTTPRoute`,
`ReferenceGrant`, `GRPCRoute`) reached v1/GA in the Standard channel as of
Gateway API v1.4.0. Adopting it aligns SAS Viya Monitoring for Kubernetes with
the direction established for SAS Viya itself in ADR-0151.

> [!IMPORTANT]
> The customization files in this sample can be applied manually, as described
> below, or generated and applied automatically by setting
> `AUTOGENERATE_INGRESS=true` and `INGRESS_TYPE=gateway-api`. See
> [Autogeneration](#autogeneration).

### Gateway API is not the same thing as Contour

These are frequently conflated, and the distinction matters for reading this
sample:

* **Gateway API** is a *specification*. Any ingress controller can implement it.
* **Contour** is a *controller* (using Envoy as its data plane). It supports
  Gateway API as one of several configuration options, alongside its own
  proprietary `HTTPProxy` CRD — which is what the existing
  [`samples/contour`](../contour) sample uses.

Everything in this sample is portable Gateway API YAML. The **only**
implementation-specific value is `spec.gatewayClassName` on the `Gateway`
resource. The same HTTPRoutes work against many controllers. That portability 
is the entire point.

> [!IMPORTANT]
> Your implementation should have **Extended** conformance, not merely Core.
> Some features this sample depends on — notably the `URLRewrite` filter used for
> path-based routing — are Extended-level, not Core.

### A note on `BackendTLSPolicy` versions

Earlier research recorded `BackendTLSPolicy` as an `v1alpha3`, Extended-channel
resource. That is now out of date: as of Gateway API **v1.4.0 it is part of the
Standard channel and is served as `v1`**, and the standard install defines
`v1alpha3` but marks it `served: false`. This sample therefore uses `v1`.

If your cluster runs an older Gateway API release — or your controller only
understands the alpha version, as Contour does — applying the policy files fails
with `no matches for kind "BackendTLSPolicy" in version ".../v1"`. Change the
`apiVersion` to `gateway.networking.k8s.io/v1alpha3`; the spec fields are
identical. `bin/check-gateway-api-support.sh` reports which versions your cluster
actually serves.

## Scenarios

Two scenarios are provided:

* **host-based routing** — the application name is part of the host name
  (for example, `https://grafana.host.cluster.example.com/`).
* **path-based routing** — the host name is fixed and the application name is
  appended as a path (for example, `https://monitoring.host.cluster.example.com/grafana`).

## Contents

```
bin/check-gateway-api-support.sh   read-only cluster capability report
bin/create-ca-configmap.sh         creates the CA ConfigMap BackendTLSPolicy needs
host-based/{monitoring,logging}/
path-based/{monitoring,logging}/
    gateway.yaml                   REFERENCE ONLY -- customer/platform-managed
    http-redirect_httproute.yaml   explicit HTTP -> HTTPS redirect
    <app>_httproute.yaml           one per web application
    backendtlspolicies.yaml        backend re-encryption ("full-stack TLS")
    user-values-*.yaml, user.env   Helm/deployment customizations
```

## Using This Sample

1. Run `bin/check-gateway-api-support.sh` to confirm your cluster has a Gateway
   API implementation with the CRDs this sample needs, and to find your
   `GatewayClass` name.
2. Copy the customization files from either the `host-based` or `path-based`
   subdirectories into your local customization directory (that is, your
   `USER_DIR`).
3. Replace all instances of `host.cluster.example.com` with the applicable host
   name for your environment, and set `spec.gatewayClassName` in `gateway.yaml`
   to your implementation's GatewayClass.
4. Create the Kubernetes Secret containing the ingress TLS certificate
   referenced by the Gateway. In this sample it is named
   `v4m-ingress-tls-secret`. See
   [Manually Configure Ingress Definitions and Enable TLS](https://documentation.sas.com/?softwareId=obsrv&softwareVersion=prod&docsetId=obsrvdply&docsetTarget=n0auhd4hutsf7xn169hfvriysz4e.htm#n13g4ybmjfxr2an1tuy6a20zpvw7).
5. Deploy SAS Viya Monitoring for Kubernetes.
6. Run `bin/create-ca-configmap.sh <namespace>` in each namespace to produce the
   CA ConfigMap that `BackendTLSPolicy` requires (see
   [CA certificates](#ca-certificates-must-be-in-a-configmap-not-a-secret)).
7. Apply the routing resources with `kubectl apply`, for example:

   ```
   kubectl -n monitoring apply -f $USER_DIR/monitoring/grafana_httproute.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/http-redirect_httproute.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/backendtlspolicies.yaml
   ```

Only apply the `BackendTLSPolicy` documents for applications you actually
exposed; the sample file contains policies for all of them.

## Key Gateway API Concepts Used in This Sample

### Gateway Ownership

The `Gateway` resource is owned and managed by the platform or cluster
administrator, not by SAS Viya Monitoring for Kubernetes. The
`gateway.yaml` files in this sample are **reference material only** — a
known-good starting point that matches the HTTPRoutes shipped here.

A `Gateway` can only reference TLS Secrets in its own namespace (absent a
`ReferenceGrant`), so the sample places one Gateway in each of the `monitoring`
and `logging` namespaces, alongside the TLS Secrets the deployment scripts
create there. A single shared Gateway in a dedicated namespace also works; see
the comments in `host-based/logging/gateway.yaml`.

This creates a sequencing consideration: the TLS Secret must exist before the
Gateway that references it becomes usable. The Gateway will simply report a
`ResolvedRefs: False` condition until the Secret appears.

### There is no "root proxy"

The `Gateway` owns the host name and TLS certificate; each application's
`HTTPRoute` attaches to it independently via `parentRefs` and contributes its
own path rules. There is no separate resource that "includes" the others, and
no `INGRESS_CREATE_ROOT_PROXY`-equivalent setting.

### HTTP-to-HTTPS redirect is explicit

Gateway API has no implicit HTTP-to-HTTPS redirect. It requires a dedicated
`HTTPRoute` with a `RequestRedirect` filter and no `backendRefs`, attached to
the Gateway's HTTP listener via `sectionName`. That is
`http-redirect_httproute.yaml`. One per Gateway is sufficient.

### Backend TLS uses a separate resource

Gateway API has no per-`backendRef` field for marking a backend as HTTPS;
backend re-encryption is configured out-of-band by a `BackendTLSPolicy` that
targets the `Service`.

Two gotchas follow from this.

#### CA certificates must be in a ConfigMap, not a Secret

`BackendTLSPolicy.validation.caCertificateRefs` accepts a `ConfigMap`. Our
`create_ingress_certs` function in `bin/autogenerate-include.sh` creates a
`kubernetes.io/tls` Secret only, so an additional step is required.
`bin/create-ca-configmap.sh` extracts the CA public certificate from the existing
Secrets (handling both the cert-manager and openssl TLS flows) and creates the
ConfigMap.

Worth tracking: NGINX Gateway Fabric is adding Secret support for
`BackendTLSPolicy`, and `ClusterTrustBundles` (currently beta) may eventually
displace the ConfigMap requirement.

#### The hostname to validate is not the Service name

`validation.hostname` is matched against the SANs on the backend's serving
certificate, and some implementations enforce this strictly.
The certificates issued by our deployment scripts do
**not** carry the Service name as a SAN. The correct values, taken from
`monitoring/tls/*.yaml` and `logging/tls/*.yaml`, are:

| Service            | `validation.hostname`              |
| ------------------ | ---------------------------------- |
| `v4m-grafana`      | `prometheus-operator-grafana`      |
| `v4m-prometheus`   | `prometheus-operator-prometheus`   |
| `v4m-alertmanager` | `prometheus-operator-alertmanager` |
| `v4m-osd`          | `prometheus-operator-kibana`       |
| `v4m-search`       | `v4m-es-client-service`            |

> [!WARNING]
> **These values are only correct when certs come from the `cert-manager` flow**
> (`monitoring/tls/*-tls-cert.yaml`, `logging/tls/*-tls-cert.yaml`), whose
> `dnsNames` match this table. If the deployment falls back to the **openssl
> path** (`bin/tls-include.sh`) instead, the issued certs carry SANs of the
> form `<service>`, `<service>.<namespace>`, `<service>.<namespace>.svc`,
> `<service>.<namespace>.svc.cluster.local` (e.g. `grafana`,
> `grafana.monitoring`, ...) -- with **no** `prometheus-operator-` prefix.
> `AUTOGENERATE_INGRESS=true` deployments don't need this table -- the deploy
> scripts read the SAN off the actual cert (see Autogeneration below). It only
> matters if you're applying `backendtlspolicies.yaml` by hand; confirm against
> the actual issued cert with the command below first.

Verify against your own deployment before relying on these:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.tls\.crt}' | base64 -d \
  | openssl x509 -noout -text | grep -A1 'Subject Alternative Name'
```

### Trailing-slash handling replaces the regex rewrite

Regex path matching is explicitly implementation-specific in the Gateway API
spec, so it cannot be used in a portable sample. The path-based routes instead
use an ordered pair of rules:

1. An `Exact` match on the unslashed path with a `RequestRedirect` filter
   (`ReplaceFullPath`) to the slashed form.
2. A `PathPrefix` match on the slashed path that routes to the backend.

`Exact` outranks `PathPrefix` in Gateway API's match-precedence rules, so the
ordering resolves deterministically. This replaces the nginx
`configuration-snippet` regex rewrite the deprecated ingress-nginx sample used
for OpenSearch Dashboards, and is a genuine improvement — it avoids that
approach's problems with special characters in URLs.

For OpenSearch Dashboards and the OpenSearch API, the second rule also carries a
`URLRewrite` filter with `ReplacePrefixMatch: /`, which strips the path prefix
before forwarding to the backend. Grafana, Prometheus and Alertmanager need no
rewrite because they are configured to serve from their sub-path.

### Session persistence is experimental

`sessionPersistence` on `HTTPRoute` (needed for OSD sticky sessions) is
**experimental channel only** -- the Standard-channel `HTTPRoute` has no such
field at all, so using it requires installing the experimental CRD set, and
implementation support varies. It is present but commented out in the OSD
routes. This only matters if OpenSearch Dashboards is scaled beyond a single
replica, which the default deployment does not do.

### Proxy tuning is a documentation matter

There is no portable Gateway API mechanism for buffer sizes, header sizes, or
timeouts. NGINX Gateway Fabric has a proposed policy CRD for this, but nothing is
standardized across implementations. These settings must be applied to the
Gateway or the implementation's own configuration by the platform administrator.
Publishing minimum proxy requirements for our applications is a documentation
deliverable, not something this sample can automate.

## Confirm the Status of the Resources

Gateway API reports reconciliation results in resource status conditions rather
than a single validity column. Check the Gateway first, then the routes:

```
kubectl -n monitoring get gateway v4m-gateway
kubectl -n monitoring describe gateway v4m-gateway
kubectl -n monitoring describe httproute v4m-grafana
```

On the `Gateway`, look for `Programmed: True` and, per listener,
`ResolvedRefs: True` — a missing TLS Secret shows up as `ResolvedRefs: False`
with reason `InvalidCertificateRef`. On each `HTTPRoute`, look at
`status.parents[].conditions` for `Accepted: True` and `ResolvedRefs: True`; a
route that attached to no listener reports `Accepted: False` with reason
`NoMatchingListenerHostname`, which usually means the route's `hostnames` do not
fall within the listener's `hostname`.

`BackendTLSPolicy` status is reported under `status.ancestors[]`; a missing CA
ConfigMap surfaces there as `ResolvedRefs: False`.

### Making secondary applications accessible

**This sample does NOT recommend making Prometheus and Alertmanager accessible
by default. Neither includes any native authentication mechanism, and exposing
such an application without other restrictions in place is insecure. It also does
NOT recommend making the OpenSearch API endpoint accessible by default; although
it does require authentication, there are limited use cases requiring it.**

Files for these applications are included should you need them. Apply the
relevant `_httproute.yaml` and the matching `BackendTLSPolicy` document, and
uncomment the corresponding section of `user-values-prom-operator.yaml`.

## Access the Applications

Replace the placeholder host names with the ones you specified.

### Host-based

* Grafana — `https://grafana.host.cluster.example.com`
* OpenSearch Dashboards — `https://dashboards.host.cluster.example.com`
* Prometheus — `https://prometheus.host.cluster.example.com` (if enabled)
* Alertmanager — `https://alertmanager.host.cluster.example.com` (if enabled)
* OpenSearch — `https://search.host.cluster.example.com` (if enabled)

### Path-based

* Grafana — `https://monitoring.host.cluster.example.com/grafana`
* OpenSearch Dashboards — `https://logging.host.cluster.example.com/dashboards`
* Prometheus — `https://monitoring.host.cluster.example.com/prometheus` (if enabled)
* Alertmanager — `https://monitoring.host.cluster.example.com/alertmanager` (if enabled)
* OpenSearch — `https://logging.host.cluster.example.com/opensearch` (if enabled)

## Autogeneration

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` generates and applies
the `HTTPRoute` resources shown in this sample as part of a normal deploy,
following the same pattern as `INGRESS_TYPE=contour`. It requires
`GATEWAY_CLASS_NAME` to be set, and requires a `Gateway` named `v4m-gateway`
using that `GatewayClass` to already exist in the `monitoring`/`logging`
namespace (the Gateway itself is never created by the deploy scripts -- see
[Gateway Ownership](#gateway-ownership)). The
existing per-application enable flags (`GRAFANA_INGRESS_ENABLE` and friends) and
the FQDN/path override variables carry through unchanged. There is no
`INGRESS_CREATE_ROOT_PROXY` equivalent, since Gateway API needs no root resource.

Backend re-encryption via `BackendTLSPolicy` is on by default
(`INGRESS_BACKEND_TLS_ENABLE=true`), since application backends serve HTTPS by
default and Gateway API has no per-route TLS toggle. The deploy scripts read
`validation.hostname` off the actual issued cert rather than using the values in
`backendtlspolicies.yaml`, so it works regardless of which TLS flow is active.

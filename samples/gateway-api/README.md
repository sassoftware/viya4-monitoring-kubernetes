# Gateway API (Proof of Concept)

> [!WARNING]
> **This sample is a proof of concept and is not yet supported.** It has not been
> validated end-to-end against any implementation. Several design questions
> remain open (see [Open Items](#open-items)). Do not use it in production.

## Overview

This sample demonstrates how to configure [Gateway API](https://gateway-api.sigs.k8s.io/)
resources for accessing the web applications that are deployed as part of the SAS
Viya Monitoring for Kubernetes solution.

Gateway API is the vendor-neutral ingress standard published by Kubernetes
SIG-Network. Its core resources (`GatewayClass`, `Gateway`, `HTTPRoute`,
`ReferenceGrant`, `GRPCRoute`) reached v1/GA in the Standard channel as of
Gateway API v1.4.0. Adopting it aligns SAS Viya Monitoring for Kubernetes with
the direction established for SAS Viya itself in ADR-0151.

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
resource. The same HTTPRoutes work against Contour, Istio, kgateway, Envoy
Gateway, Cilium, Kong, NGINX Gateway Fabric, AWS Load Balancer Controller, GKE's
native Gateway controller, Azure Application Gateway for Containers, and
OpenShift's Ingress Operator (4.19+). That portability is the entire point.

Contour appears repeatedly in the comments not because it is architecturally
special, but because it is the controller we already recommend, making it the
most convenient one to validate against first.

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

As with the Contour sample, two scenarios are provided:

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

## Differences from the Contour HTTPProxy Sample

If you are already familiar with [`samples/contour`](../contour), these are the
substantive changes.

### The Gateway is not ours to create

The `Gateway` resource is expected to be owned and managed by the platform or
cluster administrator, not by SAS Viya Monitoring for Kubernetes. The
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

In the path-based Contour scenario an extra "root" `HTTPProxy` owned the host
name and TLS certificate, and per-application HTTPProxies were pulled in via
`includes`. In Gateway API the `Gateway` itself plays that role: HTTPRoutes
attach to it via `parentRefs` and each contributes path rules independently.

There is therefore no equivalent of `root_httpproxy.yaml`, and no equivalent of
the `INGRESS_CREATE_ROOT_PROXY` setting.

### HTTP-to-HTTPS redirect is explicit

Contour's `HTTPProxy` redirects HTTP to HTTPS implicitly as soon as TLS is
configured on the virtualhost. Gateway API requires a dedicated `HTTPRoute` with
a `RequestRedirect` filter and no `backendRefs`, attached to the Gateway's HTTP
listener via `sectionName`. That is `http-redirect_httproute.yaml`. One per
Gateway is sufficient.

### Backend TLS uses a separate resource

Contour marks a backend as HTTPS with `services[].protocol: tls` inline on the
route. Gateway API has no per-`backendRef` equivalent; backend re-encryption is
configured out-of-band by a `BackendTLSPolicy` that targets the `Service`.

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
certificate, and some implementations enforce this strictly — kgateway does;
Istio was more permissive. The certificates issued by our deployment scripts do
**not** carry the Service name as a SAN. The correct values, taken from
`monitoring/tls/*.yaml` and `logging/tls/*.yaml`, are:

| Service            | `validation.hostname`              |
| ------------------ | ---------------------------------- |
| `v4m-grafana`      | `prometheus-operator-grafana`      |
| `v4m-prometheus`   | `prometheus-operator-prometheus`   |
| `v4m-alertmanager` | `prometheus-operator-alertmanager` |
| `v4m-osd`          | `prometheus-operator-kibana`       |
| `v4m-search`       | `v4m-es-client-service`            |

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
`URLRewrite` filter with `ReplacePrefixMatch: /`, which is the equivalent of
Contour's `pathRewritePolicy.replacePrefix`. Grafana, Prometheus and Alertmanager
need no rewrite because they are configured to serve from their sub-path.

### Session persistence is experimental

The deprecated ingress-nginx sample set
`nginx.ingress.kubernetes.io/affinity: "cookie"` for OpenSearch Dashboards
(`samples/ingress/path-based-ingress/logging/user-values-osd.yaml`). That setting
was silently dropped when the sample moved to Contour's `HTTPProxy`.

In Gateway API, `sessionPersistence` on `HTTPRoute` is **experimental channel
only**. Confirmed against the v1.4.0 CRDs: the Standard-channel `HTTPRoute` has
no `sessionPersistence` field on its rules at all, while the experimental channel
does (`type`, `sessionName`, `cookieConfig.lifetimeType`, `absoluteTimeout`,
`idleTimeout`). Using it therefore requires installing the experimental CRD set,
and implementation support is inconsistent (Istio does not support it; kgateway does, behind
`KGW_ENABLE_GATEWAY_API_EXPERIMENTAL_FEATURES`; Contour's support is
unconfirmed). It is therefore present but commented out in the OSD routes.

Per GEP-1619 the cookie path is derived automatically from the matched route,
which matches the current nginx behavior without manual configuration; `samesite`
is left to the implementation, and in practice browsers default to `Lax`, which
also matches the previous nginx behavior.

This gap is consequential only if OpenSearch Dashboards is scaled beyond a single
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

## Open Items

These must be resolved before this POC becomes a supported sample.

1. **Validate against Contour.** Prior hands-on research (PSCIE-63) used Istio
   and kgateway; Contour was not tested. This sample has since been validated
   against Envoy Gateway, which is expected to be the primary supported
   implementation going forward, so Contour is no longer a hard prerequisite for
   this sample to be considered supported -- but it is still the implementation
   our users are most likely to already have installed, so validating against it
   remains worthwhile. Specifically unverified on Contour: `sessionPersistence`
   support, `BackendTLSPolicy` with ConfigMap-based CA certificates, and available
   proxy-tuning knobs.
2. **BackendTLSPolicy validation against Envoy Gateway.** Confirmed working:
   `GatewayClass`/`Gateway`/`HTTPRoute` reconciliation, TLS termination with
   SNI-based host routing, end-to-end request routing to the correct backend, and
   `bin/create-ca-configmap.sh` itself (it correctly extracted the CA and created
   the ConfigMap). Not yet confirmed: whether `BackendTLSPolicy` actually accepts
   a backend connection using that ConfigMap -- on the cluster used for
   validation, every application's backend serving certificate (Grafana,
   Prometheus, Alertmanager, Kibana/OSD, Elasticsearch) had no SAN, only a bare
   CN, which Envoy Gateway's SAN-only matcher rejects unconditionally regardless
   of the configured `hostname`, independent of whether the CA ConfigMap itself
   is correct. This is a cert-issuance gap in that environment,
   not a defect in this sample, but it means backend re-encryption is still
   unverified end-to-end. Needs either a re-test against a deployment with
   SAN-bearing backend certs, or a fix to the cert-issuance flow.
3. **OpenShift scope.** `AUTOGENERATE_INGRESS` is hard-disabled on OpenShift
   because `deploy_monitoring_openshift.sh` uses Routes instead. That rationale
   may not hold here — OpenShift has GA Gateway API support as of 4.19. Confirm
   with IRIS/ADR-0151 whether OpenShift is in scope this time.
4. **CA-cert-in-ConfigMap flow.** `bin/create-ca-configmap.sh` is a POC
   stopgap. Decide where this belongs: extend `create_ingress_certs`, have
   certframe emit the ConfigMap, or append to a shared
   `customer-provided-ca-certificates` ConfigMap.
5. **Session persistence scope.** Decide whether OSD affinity parity is a hard
   requirement for v1 or an accepted gap.
6. **Path-based routing.** Only host-based routing has been exercised
   end-to-end so far. Path-based needs its own pass -- it exercises the
   `Exact`/`PathPrefix` redirect-pair precedence and the OSD `URLRewrite` filter,
   neither of which host-based touches.
7. **Real LoadBalancer path.** Validation to date has been over
   NodePort/port-forward, since the test cluster had no LoadBalancer
   implementation. Needs a pass with a real LoadBalancer (e.g. MetalLB) to
   confirm the Gateway actually gets `Programmed: True` with an assigned
   address.

## Next Step: Autogeneration

Following the Contour precedent, autogeneration is a separate, later stage. It
would add `INGRESS_TYPE=gateway` to `bin/autogenerate-include.sh` alongside a
`create_httproute` function paralleling the existing `create_httpproxy`. The
existing per-application enable flags (`GRAFANA_INGRESS_ENABLE` and friends) and
the FQDN/path override variables carry through unchanged. `create_root_httpproxy`
has no counterpart, since Gateway API needs no root resource.

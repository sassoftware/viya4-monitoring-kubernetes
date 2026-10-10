# Gateway API

## Overview

This sample demonstrates how to configure [Gateway API](https://gateway-api.sigs.k8s.io/)
`HTTPRoute` resources for accessing the web applications that are deployed as
part of the SAS Viya Monitoring for Kubernetes solution.

Gateway API is a vendor-neutral ingress specification published by Kubernetes
SIG-Network. It is distinct from [Contour](https://projectcontour.io/):
Contour is a controller that can implement Gateway API, but also has its own
`HTTPProxy` CRD, which is what [`samples/contour`](../contour) uses instead.
The only implementation-specific value in this sample is
`spec.gatewayClassName` on the `Gateway` you attach to.

> [!IMPORTANT]
> The customization files in this sample can be applied manually, as described
> below, or generated and applied automatically by setting
> `AUTOGENERATE_INGRESS=true` and `INGRESS_TYPE=gateway-api`. See
> [Autogeneration](#autogeneration).

> [!IMPORTANT]
> Your implementation needs **Extended** conformance, not just Core. The
> `URLRewrite` filter used for path-based routing is Extended-level.

`BackendTLSPolicy` is part of the Standard channel as of Gateway API v1.4.0
and is served as `v1`; this sample uses `v1`. If your cluster runs an older
release, check which versions it actually serves:

```
kubectl get crd backendtlspolicies.gateway.networking.k8s.io -o jsonpath='{.spec.versions[?(@.served==true)].name}'
```

If `v1` isn't in the list, use a manifest matching whichever version your
cluster actually serves (for example `v1alpha3`), or upgrade your Gateway API
CRDs to a release that serves `v1`.

## Scenarios

Two scenarios are provided:

* **host-based routing** — the application name is part of the host name
  (for example, `https://grafana.host.cluster.example.com/`).
* **path-based routing** — the host name is fixed and the application name is
  appended as a path (for example, `https://monitoring.host.cluster.example.com/grafana`).

## Contents

```
host-based/{monitoring,logging}/
path-based/{monitoring,logging}/
    http-redirect_httproute.yaml   explicit HTTP -> HTTPS redirect
    <app>_httproute.yaml           one per web application
    user-values-*.yaml             Helm/deployment customizations
```

There is no `gateway.yaml`. The `Gateway` is owned and managed by your
platform or cluster administrator, not created by this sample -- see
[Gateway Ownership](#gateway-ownership).

## Using This Sample

1. Find the `GatewayClass` name and the name/namespace of an existing
   `Gateway` you can attach to:

   ```
   kubectl get gatewayclass
   kubectl get gateway -A
   ```

2. Copy the customization files from either the `host-based` or `path-based`
   subdirectories into your local customization directory (that is, your
   `USER_DIR`).
3. Replace all instances of `host.cluster.example.com` with the applicable
   host name for your environment.
4. Confirm the Gateway's listeners allow routes from outside its own
   namespace (`allowedRoutes.namespaces.from: All`, or a matching
   `Selector`). If they don't, your `HTTPRoute`s will attach nowhere; ask
   whoever manages the Gateway to widen it.
5. Deploy SAS Viya Monitoring for Kubernetes.
6. Create the CA ConfigMap `BackendTLSPolicy` requires (see
   [CA certificates](#ca-certificates-must-be-in-a-configmap-not-a-secret)),
   and apply a `BackendTLSPolicy` for each app you're exposing. Application
   backends serve HTTPS by default, so without this the Gateway sends
   plaintext to a TLS-only backend and every request fails.
7. Set `parentRefs` in each `HTTPRoute` to your Gateway's actual name and
   namespace, then apply the routing resources:

   ```
   kubectl -n monitoring apply -f $USER_DIR/monitoring/grafana_httproute.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/http-redirect_httproute.yaml
   ```

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` does all of the
above for you as part of a normal deploy -- see [Autogeneration](#autogeneration).

### Making secondary applications accessible

**This sample does NOT recommend making Prometheus and Alertmanager accessible
by default. Neither includes any native authentication mechanism, and exposing
such an application without other restrictions in place is insecure. It also does
NOT recommend making the OpenSearch API endpoint accessible by default; although
it does require authentication, there are limited use cases requiring it.**

Files for these applications are included should you need them. Apply the
relevant `_httproute.yaml`, write a `BackendTLSPolicy` for it (its backend
serves HTTPS by default, same as the others), and uncomment the corresponding
section of `user-values-prom-operator.yaml`.

## Gateway Ownership

The `Gateway` resource is owned and managed by the platform or cluster
administrator, not by SAS Viya Monitoring for Kubernetes. This sample assumes
one already exists and never creates or modifies it.

It's expected to be a single, shared Gateway that `HTTPRoute`s from both the
`monitoring` and `logging` namespaces attach to via a cross-namespace
`parentRef`. It can live in any namespace. Its listeners must set
`allowedRoutes.namespaces.from` to `All` (or a matching `Selector`), and its
TLS Secret -- also the Gateway owner's, never created by this sample -- must
be in that same namespace (Gateway API does not allow a Gateway to reference
a Secret in another namespace without a `ReferenceGrant`).

## Gateway API Differences From Contour

* **No root proxy.** The `Gateway` owns the host name and TLS certificate;
  each `HTTPRoute` attaches to it independently via `parentRefs`. There is no
  `INGRESS_CREATE_ROOT_PROXY` equivalent.
* **HTTP-to-HTTPS redirect is explicit.** Gateway API has no implicit
  redirect. `http-redirect_httproute.yaml` is a dedicated `HTTPRoute` with a
  `RequestRedirect` filter, attached to the Gateway's HTTP listener via
  `sectionName`. One per Gateway is sufficient.
* **Backend TLS is a separate resource.** There's no per-`backendRef` TLS
  field; backend re-encryption is configured out-of-band by a
  `BackendTLSPolicy` that targets the `Service`. Two things follow from this.

### CA certificates must be in a ConfigMap, not a Secret

`BackendTLSPolicy.validation.caCertificateRefs` accepts a `ConfigMap`. TLS
Secrets created by the deployment scripts don't produce one, so extract the
CA public certificate and create it yourself:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
kubectl -n monitoring create configmap v4m-ca-certs --from-file=ca.crt=ca.crt
```

`AUTOGENERATE_INGRESS=true` deployments don't need this -- the deploy scripts
do it automatically (`create_backend_tls_ca_configmap` in
`bin/autogenerate-include.sh`) when `INGRESS_BACKEND_TLS_ENABLE=true`.

### The hostname to validate is not the Service name

`validation.hostname` is matched against the SANs on the backend's serving
certificate. Confirm the actual SAN before writing a `BackendTLSPolicy` by
hand:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.tls\.crt}' | base64 -d \
  | openssl x509 -noout -text | grep -A1 'Subject Alternative Name'
```

`AUTOGENERATE_INGRESS=true` deployments don't need this -- the deploy scripts
read the SAN off the actual issued cert.

## Other Notes

* **No regex path rewrite.** Regex matching is implementation-specific in
  Gateway API. The path-based routes instead use an ordered pair of rules: an
  `Exact` match on the unslashed path with a `RequestRedirect` to the slashed
  form, then a `PathPrefix` match on the slashed path that routes to the
  backend (`Exact` outranks `PathPrefix` in Gateway API's match precedence,
  so this resolves deterministically). For OpenSearch Dashboards and the
  OpenSearch API, the second rule also carries a `URLRewrite` filter with
  `ReplacePrefixMatch: /` to strip the path prefix before forwarding.
* **Session persistence is experimental.** `sessionPersistence` on
  `HTTPRoute` (needed for OSD sticky sessions) is experimental-channel only
  and requires the experimental CRD set; it's present but commented out in
  the OSD routes. Only matters if OpenSearch Dashboards is scaled beyond a
  single replica, which the default deployment does not do.
* **Proxy tuning is a documentation matter.** There's no portable Gateway API
  mechanism for buffer sizes, header sizes, or timeouts. Apply these to the
  Gateway or the implementation's own configuration.

## Confirm the Status of the Resources

Gateway API reports reconciliation results in resource status conditions.
Check the Gateway first, then the routes:

```
kubectl -n <gateway-namespace> get gateway <gateway-name>
kubectl -n <gateway-namespace> describe gateway <gateway-name>
kubectl -n monitoring describe httproute v4m-grafana
```

On the `Gateway`, look for `Programmed: True` and, per listener,
`ResolvedRefs: True` — a missing TLS Secret shows up as `ResolvedRefs: False`
with reason `InvalidCertificateRef`. On each `HTTPRoute`, look at
`status.parents[].conditions` for `Accepted: True` and `ResolvedRefs: True`; a
route that attached to no listener reports `Accepted: False` with reason
`NoMatchingListenerHostname`, which usually means the route's `hostnames` do
not fall within the listener's `hostname`.

`BackendTLSPolicy` status is reported under `status.ancestors[]`; a missing
CA ConfigMap surfaces there as `ResolvedRefs: False`.

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

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` generates and
applies the `HTTPRoute` resources shown in this sample as part of a normal
deploy, following the same pattern as `INGRESS_TYPE=contour`.

Required: `GATEWAY_CLASS_NAME`, `GATEWAY_NAMESPACE`, and `GATEWAY_NAME`. A
Gateway matching all three must already exist, with listeners that allow
routes from outside its own namespace; the deploy scripts verify all of this
and fail with a clear error if it's not met. Neither the Gateway nor its TLS
Secret is ever created by the deploy scripts; see
[Gateway Ownership](#gateway-ownership).

The existing per-application enable flags (`GRAFANA_INGRESS_ENABLE` and
friends) and the FQDN/path override variables carry through unchanged. There
is no `INGRESS_CREATE_ROOT_PROXY` equivalent.

Backend re-encryption via `BackendTLSPolicy` is on by default
(`INGRESS_BACKEND_TLS_ENABLE=true`), since application backends serve HTTPS
by default and Gateway API has no per-route TLS toggle. The deploy scripts
read `validation.hostname` off the actual issued cert, so it works regardless
of which TLS flow is active.

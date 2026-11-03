# Gateway API

## Overview

This sample demonstrates how to configure [Gateway API](https://gateway-api.sigs.k8s.io/)
`HTTPRoute` resources for accessing the web applications that are deployed as
part of the SAS Viya Monitoring for Kubernetes solution.

Gateway API is a vendor-neutral ingress specification published by Kubernetes
SIG-Network. The only implementation-specific value in this sample is
`spec.gatewayClassName` on the `Gateway` you attach to.

This sample's manifests use the `v1` (Standard/GA) Gateway API resources
throughout, not `v1alpha2`/`v1beta1`.

> [!IMPORTANT]
> The customization files in this sample can be applied manually, as described
> below, or generated and applied automatically by setting
> `AUTOGENERATE_INGRESS=true` and `INGRESS_TYPE=gateway-api`. See
> [Autogeneration](#autogeneration).

> [!IMPORTANT]
> Your implementation needs **Extended** conformance, not just Core. The
> `URLRewrite` filter used for path-based routing is Extended-level.

> [!IMPORTANT]
> Requires Gateway API v1.5.0 or later. This also covers `ListenerSet` (see
> [ListenerSet Ownership](#listenerset-ownership)), which graduated to the
> Standard channel before v1.5.0.

`BackendTLSPolicy` graduated to the Standard channel in Gateway API v1.4.0
and is served as `v1`; this sample uses `v1`. The v1.5.0+ minimum required
here guarantees that version is served. To check which versions your cluster
actually serves:

```
kubectl get crd backendtlspolicies.gateway.networking.k8s.io -o jsonpath='{.spec.versions[?(@.served==true)].name}'
```

## Scenarios

Two scenarios are provided:

* **host-based routing** — the application name is part of the host name
  (for example, `https://grafana.monitoring.host.cluster.example.com/`). The
  `monitoring`/`logging` segment is required; see
  [ListenerSet Ownership](#listenerset-ownership).
* **path-based routing** — the host name is fixed and the application name is
  appended as a path (for example, `https://monitoring.host.cluster.example.com/grafana`).

## Contents

```
host-based/{monitoring,logging}/
path-based/{monitoring,logging}/
    listenerset.yaml               attaches our own hostname/TLS cert to the shared Gateway
    http-redirect_httproute.yaml   explicit HTTP -> HTTPS redirect
    <app>_httproute.yaml           one per web application
    user-values-*.yaml             Helm/deployment customizations
```

There is no `gateway.yaml`. The `Gateway` is owned and managed by your
platform or cluster administrator, not created by this sample; see
[Gateway Ownership](#gateway-ownership). `listenerset.yaml`, by contrast, is
ours: see [ListenerSet Ownership](#listenerset-ownership).

## Using This Sample

1. Find the `GatewayClass` name and the name/namespace of an existing
   `Gateway` you can attach to:

   ```
   kubectl get gatewayclass
   kubectl get gateway -A
   ```

2. Confirm the Gateway allows `ListenerSet`s to attach from outside its own
   namespace (`spec.allowedListeners.namespaces.from: All`, or a matching
   `Selector`):

   ```
   kubectl -n <gateway-namespace> get gateway <gateway-name> \
     -o jsonpath='{.spec.allowedListeners.namespaces.from}'
   ```

   If this isn't `All` or a matching `Selector`, your `ListenerSet` will
   attach nowhere; ask whoever manages the Gateway to widen it.

   If it's a `Selector`, your `monitoring`/`logging` namespace must already
   exist with labels matching it *before* you deploy. This sample's deploy
   scripts create the namespace if it's missing, but never apply labels to
   it; there's no generic way to know what label values an arbitrary
   selector expects. Create and label the namespace yourself first, for
   example:

   ```
   kubectl create namespace monitoring
   kubectl label namespace monitoring team=viya  # match the actual selector
   ```
3. Copy the customization files from either the `host-based` or `path-based`
   subdirectories into your local customization directory (that is, your
   `USER_DIR`). `path-based/monitoring/user.env` sets
   `MON_TLS_PATH_INGRESS=true`, which `deploy_monitoring_cluster.sh` requires
   whenever `ROUTING=path`. Copy it too, and make sure it actually gets
   loaded (`USER_DIR/monitoring/user.env`) before you deploy.
4. Replace all instances of `host.cluster.example.com` in the copied YAML
   files with the applicable host name for your environment.
5. Deploy SAS Viya Monitoring for Kubernetes.
6. Create the TLS Secret `listenerset.yaml` references
   (`v4m-ingress-tls-secret` by default). This is the cert your own
   namespace's listener presents, not the Gateway owner's. For host-based
   routing it must cover every app hostname in use (for example via a
   wildcard SAN matching `*.monitoring.host.cluster.example.com`).
7. Create the CA ConfigMap and a `BackendTLSPolicy` for each app you're
   exposing. Application backends serve HTTPS by default, so without this
   the Gateway sends plaintext to a TLS-only backend and every request
   fails.

   Use a separate ConfigMap per app, named for the app it's for. Apps in
   the same namespace usually share one CA, but don't have to; reusing
   one ConfigMap name across apps with different CAs would silently
   validate the wrong one for whichever app doesn't match:

   ```
   kubectl -n monitoring get secret grafana-tls-secret \
     -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
   kubectl -n monitoring create configmap v4m-grafana-backend-tls-ca-certs --from-file=ca.crt=ca.crt
   ```

   Then, for each app, confirm the SAN on its backend cert (see
   [The hostname to validate is not the Service name](#the-hostname-to-validate-is-not-the-service-name))
   and apply a `BackendTLSPolicy` like this one for Grafana:

   ```
   kubectl -n monitoring apply -f - <<EOF
   apiVersion: gateway.networking.k8s.io/v1
   kind: BackendTLSPolicy
   metadata:
     name: v4m-grafana-backend-tls
     namespace: monitoring
   spec:
     targetRefs:
       - group: ""
         kind: Service
         name: v4m-grafana
     validation:
       caCertificateRefs:
         - group: ""
           kind: ConfigMap
           name: v4m-grafana-backend-tls-ca-certs
       hostname: grafana.monitoring  # replace with the SAN you confirmed above
   EOF
   ```

8. Set `spec.parentRef` in `listenerset.yaml` to your Gateway's actual name
   and namespace, then apply the routing resources:

   ```
   kubectl -n monitoring apply -f $USER_DIR/monitoring/listenerset.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/grafana_httproute.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/http-redirect_httproute.yaml
   ```

> [!NOTE]
> As noted above, all of these steps can be automated by setting
> `AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` prior to
> running the deployment scripts. See [Autogeneration](#autogeneration) for
> details.

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

It's expected to be a single, shared Gateway that other namespaces attach
their own `ListenerSet`s to. It can live in any namespace. Its only
requirement is `spec.allowedListeners.namespaces.from: All` (or a matching
`Selector`); see [ListenerSet Ownership](#listenerset-ownership).

## ListenerSet Ownership

Unlike the `Gateway`, `listenerset.yaml` **is** ours: it's how a tenant
namespace attaches its own hostname and TLS cert to a Gateway it doesn't own,
without the Gateway owner having to provision anything on its behalf. Each of
`monitoring` and `logging` gets its own `ListenerSet`, in its own namespace,
with its own TLS Secret in that same namespace. There's no cross-namespace
Secret reference, and no `ReferenceGrant` needed.

`spec.parentRef` points at the shared Gateway (name/namespace both required,
since the Gateway can live in any namespace). Its listeners' hostnames are
based on `BASE_DOMAIN`, same as the rest of this sample.

**Both routing modes require a namespace segment in the hostname**:
`grafana.monitoring.<domain>` for host-based, or `monitoring.<domain>` (the
single shared hostname for every app in that namespace) for path-based. Each
of `monitoring` and `logging` owns its *own* `ListenerSet` attached to the
same shared Gateway,
and Gateway API will not let two separate listeners, even in different
`ListenerSet`s, claim the same hostname on the same port. For host-based, a
flat `*.<domain>` wildcard in both namespaces' `ListenerSet`s would be
indistinguishable over TLS SNI and gets rejected outright (`reason:
HostnameConflict`). For path-based, two `ListenerSet`s both using the
literal, identical `<domain>` (no segment) hit the same rejection, just
without a wildcard involved. The per-namespace segment is what keeps the two
apart in both cases. It's not optional: dropping it for a "cleaner" URL
breaks routing for whichever namespace loses the conflict.

## Backend TLS Is a Separate Resource

There's no per-`backendRef` TLS field; backend re-encryption is configured
out-of-band by a `BackendTLSPolicy` that targets the `Service`. Two things
follow from this.

### CA certificates must be in a ConfigMap, not a Secret

`BackendTLSPolicy.validation.caCertificateRefs` accepts a `ConfigMap`. TLS
Secrets created by the deployment scripts don't produce one, so extract the
CA public certificate and create it yourself: one ConfigMap per app, from
that app's own TLS Secret (see [step 7](#using-this-sample) for why: apps in
the same namespace don't always share one CA):

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
kubectl -n monitoring create configmap v4m-grafana-backend-tls-ca-certs --from-file=ca.crt=ca.crt
```

`AUTOGENERATE_INGRESS=true` deployments don't need this; the deploy scripts
do it automatically (`apply_backend_tls_policy` in
`bin/autogenerate-include.sh`) when `INGRESS_BACKEND_TLS_ENABLE=true`,
deriving each app's CA ConfigMap from that same app's own TLS Secret.

### The hostname to validate is not the Service name

`validation.hostname` is matched against the SANs on the backend's serving
certificate. Confirm the actual SAN before writing a `BackendTLSPolicy` by
hand:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.tls\.crt}' | base64 -d \
  | openssl x509 -noout -text | grep -A1 'Subject Alternative Name'
```

`AUTOGENERATE_INGRESS=true` deployments don't need this; the deploy scripts
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
* **Proxy tuning is a documentation matter.** There's no portable Gateway API
  mechanism for buffer sizes, header sizes, or timeouts. Apply these to the
  Gateway, the `ListenerSet`, or the implementation's own configuration.
* **The HTTP listener only ever serves a redirect.** `http-redirect_httproute.yaml`
  has no `backendRefs`, so no application content is ever returned over plain
  HTTP. For example, `http://grafana.monitoring.<domain>/` gets a `301`
  pointing at `https://grafana.monitoring.<domain>/`; the actual Grafana page
  is only ever served over HTTPS. "HTTP exposed" here just means port 80 is
  open at all and answers with that redirect. Removing the HTTP listener from
  `listenerset.yaml` (and not applying `http-redirect_httproute.yaml`) closes
  port 80 entirely, so `http://grafana.monitoring.<domain>/` gets no response
  instead of a redirect; `https://grafana.monitoring.<domain>/` is unaffected
  either way.

## Confirm the Status of the Resources

Gateway API reports reconciliation results in resource status conditions.
Check the Gateway, then the `ListenerSet`, then the routes:

```
kubectl -n <gateway-namespace> get gateway <gateway-name>
kubectl -n monitoring get listenerset v4m-listenerset
kubectl -n monitoring describe listenerset v4m-listenerset
kubectl -n monitoring describe httproute v4m-grafana
```

On the `Gateway`, `Programmed: False` with reason `AddressNotAssigned` is
normal on clusters with no real `LoadBalancer` (common on-prem); it does not
block routing. What does matter is `spec.allowedListeners.namespaces.from`
(see [step 2](#using-this-sample)).

On the `ListenerSet`, look for `Accepted: True` and `Programmed: True`, and
per listener, `ResolvedRefs: True`. A missing TLS Secret shows up as
`ResolvedRefs: False` with reason `InvalidCertificateRef`; two
namespaces' listeners with the same (or overlapping wildcard) hostname show
up as `Conflicted: True` with reason `HostnameConflict` (see
[ListenerSet Ownership](#listenerset-ownership)).

On each `HTTPRoute`, look at `status.parents[].conditions` for
`Accepted: True` and `ResolvedRefs: True`; a route that attached to no
listener reports `Accepted: False` with reason `NoMatchingListenerHostname`,
which usually means the route's `hostnames` do not fall within the
`ListenerSet`'s listener `hostname`.

`BackendTLSPolicy` status is reported under `status.ancestors[]`; a missing
CA ConfigMap surfaces there as `ResolvedRefs: False`.

## Access the Applications

Replace the placeholder host names with the ones you specified.

### Host-based

* Grafana — `https://grafana.monitoring.host.cluster.example.com`
* OpenSearch Dashboards — `https://dashboards.logging.host.cluster.example.com`
* Prometheus — `https://prometheus.monitoring.host.cluster.example.com` (if enabled)
* Alertmanager — `https://alertmanager.monitoring.host.cluster.example.com` (if enabled)
* OpenSearch — `https://search.logging.host.cluster.example.com` (if enabled)

### Path-based

* Grafana — `https://monitoring.host.cluster.example.com/grafana`
* OpenSearch Dashboards — `https://logging.host.cluster.example.com/dashboards`
* Prometheus — `https://monitoring.host.cluster.example.com/prometheus` (if enabled)
* Alertmanager — `https://monitoring.host.cluster.example.com/alertmanager` (if enabled)
* OpenSearch — `https://logging.host.cluster.example.com/opensearch` (if enabled)

## Autogeneration

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` generates and
applies the `ListenerSet` and `HTTPRoute` resources shown in this sample as
part of a normal deploy.

Required: `GATEWAY_CLASS_NAME`, `GATEWAY_NAMESPACE`, and `GATEWAY_NAME`. A
Gateway matching all three must already exist, with
`spec.allowedListeners.namespaces.from` set to allow `ListenerSet`s from
outside its own namespace; the deploy scripts verify all of this and fail
with a clear error if it's not met. The Gateway itself is never created by
the deploy scripts; see [Gateway Ownership](#gateway-ownership). Its own
`ListenerSet`, by contrast, is created automatically; see
[ListenerSet Ownership](#listenerset-ownership).

The `ListenerSet`'s TLS Secret (`v4m-ingress-tls-secret` by default) is only
created from `INGRESS_CERT`/`INGRESS_KEY` if those point at real files; the
deploy scripts don't generate a cert from nothing. If those aren't set and
the Secret doesn't already exist (for example from a previous deploy), the
`ListenerSet` is still created, but its listener can't resolve the
certificate reference (`ResolvedRefs: False`, reason `InvalidCertificateRef`)
until you create that Secret yourself.

The existing per-application enable flags (`GRAFANA_INGRESS_ENABLE` and
friends) and the FQDN/path override variables carry through unchanged. Gateway
API has no root/aggregator resource: each enabled app gets its own
`HTTPRoute` directly. Each app's default FQDN automatically includes its
namespace segment: `grafana.monitoring.$BASE_DOMAIN`
for host-based, `monitoring.$BASE_DOMAIN` for path-based (and the `logging`
equivalents); an explicit `GRAFANA_FQDN` (and so on) overrides this entirely,
same as for the other ingress types.

For host-based routing, an explicit override must still end in
`.monitoring.$BASE_DOMAIN` (or `.logging.$BASE_DOMAIN`). The `ListenerSet`'s
listener only covers `*.monitoring.$BASE_DOMAIN`, so an override outside
that pattern would never match it; the deploy scripts detect this and fail
with a clear error rather than applying a route that would sit permanently
unmatched (reason: `NoMatchingListenerHostname`). Path-based overrides have
no such constraint, since the path segment, not the hostname, is what
changes per app.

Backend re-encryption via `BackendTLSPolicy` is on by default
(`INGRESS_BACKEND_TLS_ENABLE=true`), since application backends serve HTTPS
by default and Gateway API has no per-route TLS toggle. The deploy scripts
read `validation.hostname` off the actual issued cert, so it works regardless
of which TLS flow is active.

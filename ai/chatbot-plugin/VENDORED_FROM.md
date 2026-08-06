# Provenance

This directory is a vendored copy of the Grafana chatbot plugin, originally developed in `summer_2026_grafana_chatbot` (GitHub: `Joel-Kenline_sasinst/summer_2026_grafana_chatbot`), Apache-2.0 licensed (see `LICENSE`).

This copy was made to support automating the plugin build inside `viya4-monitoring-kubernetes/monitoring/bin/deploy_ai_chatbot.sh`. Vendoring the source here was discussed with the plugin's author ahead of this project and is intentional — the plugin isn't tracked separately going forward, this repo is now its home for the purposes of the AI chatbot integration.

Note: the upstream repo had uncommitted local changes at the time of this copy (dependency bumps in `package.json`/`package-lock.json`, a comment tweak in `provisioning/plugins/apps.yaml`), which were carried over as part of this vendored copy.

`.github-original/` holds inert reference copies of the upstream repo's CI/CD workflows (not live — see its own README) — not vendored into this repo's own `.github/workflows/`.

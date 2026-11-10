# codex-docs-railway

Wrapper image for deploying [CodeX Docs](https://github.com/codex-team/codex.docs) (v2.3.3, Apache-2.0) on Railway.

Upstream reads all settings from a YAML file. The entrypoint writes it at boot from `DOCS_PASSWORD`, `DOCS_SECRET` and optional
`SITE_TITLE`, binds Railway's `PORT`, and keeps the file database and uploads under `/data`. The write API answers 401 JSON instead
of redirecting to the login page. Built by GitHub Actions to `ghcr.io/bon5co/codex-docs-railway`.

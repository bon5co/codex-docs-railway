#!/bin/sh
# Write docs-config.yaml from the environment, then hand over to the upstream command.
set -eu

: "${DOCS_PASSWORD:?DOCS_PASSWORD is not set}"
: "${DOCS_SECRET:?DOCS_SECRET is not set}"
DATA_DIR="${DATA_DIR:-/data}"
SITE_TITLE="${SITE_TITLE:-CodeX Docs}"

# Values go inside double-quoted YAML scalars: refuse the two characters that would break out of them.
for v in "$DOCS_PASSWORD" "$DOCS_SECRET" "$SITE_TITLE"; do
  case "$v" in
    *'"'* | *'\'*) echo "railway-entrypoint: DOCS_PASSWORD, DOCS_SECRET and SITE_TITLE must not contain a double quote or a backslash" >&2; exit 1 ;;
  esac
done

mkdir -p "$DATA_DIR/db" "$DATA_DIR/uploads"

cat > /usr/src/app/docs-config.yaml <<YAML
port: ${PORT:-8080}
host: "0.0.0.0"
uploads:
  driver: "local"
  local:
    path: "$DATA_DIR/uploads"
frontend:
  title: "$SITE_TITLE"
  description: "Documentation powered by CodeX Docs"
  startPage: ""
  carbon:
    serve: ""
    placement: ""
  menu: []
auth:
  password: "$DOCS_PASSWORD"
  secret: "$DOCS_SECRET"
database:
  driver: local
  local:
    path: "$DATA_DIR/db"
YAML

echo "railway-entrypoint: config written, port ${PORT:-8080}, data dir $DATA_DIR"
exec "$@"

#!/bin/sh
set -eu

# Validate arguments
WORKERS="${WORKERS:-2}"
if [ "$WORKERS" -gt 0 ]; then
    echo "Starting gunicorn with $WORKERS workers"
else
    echo "Invalid argument: WORKERS=$WORKERS"
    exit 1
fi

EXTRA_OPTS=""
if [ "$WORKERS" -gt 1 ]; then
    export prometheus_multiproc_dir="${prometheus_multiproc_dir:-/tmp}"
fi

# Add Bedrock model server directory to path
export PYTHONPATH="${PYTHONPATH:-}:/app"

exec conda run -n production \
     gunicorn \
     --config gunicorn_config.py \
     --bind=:${BEDROCK_SERVER_PORT:-8080} \
     --worker-class=gthread \
     --workers=${WORKERS} \
     --timeout=300 \
     --preload serve_http:app

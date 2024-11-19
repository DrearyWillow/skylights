#!/bin/sh

MARKER_FILE="/.setup_done"

quickwit "$@" &
QUICKWIT_PID=$!

if [ ! -f "$MARKER_FILE" ]; then
  sleep 5

  echo "First run detected. Running setup..."

  quickwit index create --index-config /open-library-index.yml

  curl -O https://open-library-uploads.s3.eu-north-1.amazonaws.com/index.ndjson.gz
  quickwit index ingest --index open-library --input-path index.ndjson.gz --force
  rm index.ndjson.gz

  touch "$MARKER_FILE"
else
  echo "Setup already completed. Skipping setup."
fi

wait $QUICKWIT_PID

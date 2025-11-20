#!/bin/bash

sleep 3
chromium \
  --no-sandbox \
  --headless \
  --disable-gpu \
  --proxy-server=http://proxy:8080 \
  --ignore-certificate-errors "$@"
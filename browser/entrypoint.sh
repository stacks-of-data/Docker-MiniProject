#!/bin/bash

chromium \
  --no-sandbox \
  --headless \
  --disable-gpu \
  --proxy-server=http://mitmdump:8080 \
  --ignore-certificate-errors "$@"
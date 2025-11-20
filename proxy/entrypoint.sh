#!/bin/sh

mitmdump \
  --mode regular --listen-host 0.0.0.0 \
  --listen-port 8080 > /home/mitmdump/log/mitmdump.log 2>&1
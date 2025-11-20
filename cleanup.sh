#!/bin/bash

docker compose down --rmi all
rm -rf ./mitmdump/log/mitmdump.log
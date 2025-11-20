#!/bin/bash

docker compose down --rmi all
rm -rf ./proxy/log
rm -rf ./logger/captures
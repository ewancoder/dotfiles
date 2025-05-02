#!/usr/bin/env bash

docker compose --env-file .env --env-file .secrets -f compose.yml -p media-server up -d

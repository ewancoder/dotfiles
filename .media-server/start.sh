#!/usr/bin/env bash

docker compose --env-file .env --env-file .secrets up -d

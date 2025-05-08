#!/bin/bash

docker compose -f infra.yml up -d
docker compose -f infra.yml cp infra.yml doneman:/docker-compose.yml
docker compose -f infra.yml restart doneman

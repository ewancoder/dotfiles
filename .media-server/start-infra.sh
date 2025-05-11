#!/bin/bash

docker compose -f infra.yml up -d
docker compose -f infra.yml cp infra.yml tyr-infra-doneman:/docker-compose.yml
docker compose -f infra.yml restart tyr-infra-doneman

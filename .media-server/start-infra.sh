#!/bin/bash

docker compose -f infra.yml up -d
docker compose -f infra.yml cp infra-networks.yml doneman:/config.yml
docker compose -f infra.yml restart doneman

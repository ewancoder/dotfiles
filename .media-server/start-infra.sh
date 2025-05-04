#!/bin/bash

docker compose -f infra.yml -p typingrealm-infra up -d
docker compose -f infra.yml -p typingrealm-infra cp infra-networks.yml doneman:/config.yml
docker compose -f infra.yml -p typingrealm-infra restart doneman

#!/bin/bash

docker compose -f infra.yml -p typingrealm-infra pull
./start-infra.sh

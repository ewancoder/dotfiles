#!/bin/bash

docker compose -f infra.yml pull
./start-infra.sh

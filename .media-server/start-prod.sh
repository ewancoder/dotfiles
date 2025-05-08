#!/bin/bash

docker compose pull
docker compose up  -d
docker compose cp compose.yml doneman:/docker-compose.yml
docker compose restart doneman

#!/usr/bin/env bash

sptlrx pipe --player mpris | while read -r line; do echo "$line" > /tmp/lyrics; done

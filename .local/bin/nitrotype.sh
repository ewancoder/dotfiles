#!/bin/bash

curl https://www.nitrotype.com/api/v2/teams/OLIWAN | jq -r '.results.season[] | .username + "-" + (.typed | tostring) + "-" + (.errs | tostring)' | awk -F'-' '{precision=100*($2-$3)/$2; printf "%s - %.2f%% - Total typed: %s (Errors: %s)\n", $1, precision, $2, $3}'

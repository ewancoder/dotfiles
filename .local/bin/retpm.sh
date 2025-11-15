#!/bin/bash

drive="$1"
systemd-cryptenroll --wipe-slot=tpm2 "$drive"
systemd-cryptenroll "$drive" --tpm2-device=auto --tpm2-pcrs=7

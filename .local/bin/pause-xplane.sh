#!/bin/bash
p=$(pgrep -f '^/.*X-Plane-x86_64' | head -1); [ -n "$p" ] && { grep -q '^State:.*T' /proc/$p/status && kill -CONT $p || kill -STOP $p; }

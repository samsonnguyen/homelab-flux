#!/usr/bin/env bash

timestamp="$1"; shift
file="$1"; shift
event="$1"; shift

echo "[${timestamp}] file: ${file} changed (${event}), sending"
scp -i ${IDENTITY_FILE} -s "${file}" ${DESTINATION}

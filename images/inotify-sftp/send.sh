#!/usr/bin/env bash

timestamp="$1"; shift
target="$1"; shift
event="$1"; shift
file="$1"; shift

echo "[${timestamp}] file: ${target}${file} changed (${event}), checking if file exists"
if [ -f "${target}${file}" ]; then
  echo "[${timestamp}] file: ${file} changed (${event}), sending"
  scp -i ${IDENTITY_FILE} "${target}${file}" ${DESTINATION}
  if [ $? -ne 0 ]; then
    echo "[${timestamp}] file: ${file} changed (${event}), sending failed"
    exit 1
  else
    rm "${target}${file}"
    echo "[${timestamp}] file: ${file} changed (${event}), sending successful"
    exit 0
  fi
fi


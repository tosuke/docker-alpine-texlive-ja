#!/bin/bash -eu

case $1 in
  "linux/arm64")
    echo "aarch64-linux";;
  "linux/amd64")
    echo "x86_64-linux";;
esac
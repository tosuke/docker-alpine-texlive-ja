#!/bin/bash -eu

if [ $1 != $2 ]; then
  case $1 in
    "linux/arm64")
      ln -s /target-lib/aarch64-linux-gnu /lib/aarch64-linux-gnu
      ln -s /target-lib/aarch64-linux-gnu/ld-*.so /lib/ld-linux-aarch64.so.1
      ;;
    "linux/amd64")
      mkdir /lib64
      ln -s /target-lib/x86_64-linux-gnu /lib/x86_64-linux-gnu
      ln -s /target-lib/x86_64-linux-gnu/ld-*.so /lib64/ld-linux-x86-64.so.2
      ;;
  esac
fi
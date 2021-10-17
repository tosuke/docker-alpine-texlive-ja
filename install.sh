#/bin/bash -eu

FAIL=0
until ./install-tl --force-arch $1 --profile $2 || [ $FAIL -eq 4 ]; do
  sleep $(( FAIL++ ))
done

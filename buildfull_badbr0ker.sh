#!/bin/bash
# simple passthrough script

board=$1
recopath=$2

fail() {
    printf "%s\n" "$1"
    printf "error occurred\n"
    exit 1
}

if [ -z "$board" ] || [ -z "$recopath" ]; then
    fail "Usage: $0 <board> <recovery_path>"
fi

echo "running update_downloader.sh"
bash update_downloader.sh "$board" || fail "update_downloader.sh exited with an error"

echo "running build_badrecovery.sh"
./build_badrecovery.sh -i "$recopath" -t unverified || fail "build_badrecovery.sh exited with an error"

echo "No errors detected while buildng the badbr0ker image"

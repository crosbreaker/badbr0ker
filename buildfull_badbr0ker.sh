#!/bin/bash
# simple paththrough script
board = $1
recopath = $2
fail(){
	printf "$1\n"
	printf "error occurred\n"
	exit
}
echo "running update_downloader.sh"
bash update_downloader.sh "$board" || fail "update_downloader.sh exited with an erorr"
echo "running build_badrecovery.sh"
./build_badrecovery.sh -i "$recopath" -t unverified || fail "build_badrecovery.sh exited with an error"
echo "

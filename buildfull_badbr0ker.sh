#!/bin/bash
# simple passthrough script + downloading a 129 image

board=$1
fail() {
    printf "%s\n" "$1"
    printf "error occurred\n"
    exit 1
}
if [ -z "$board" ]; then
    fail "Usage: $0 <board>"
fi

if [ "$board" == "nissa" ]; then
    reco_name="chromeos_16002.60.0_nissa_recovery_stable-channel_mp-v32"
elif [ "$board" == "skyrim" ]; then
    reco_name="chromeos_16002.60.0_skyrim_recovery_stable-channel_mp-v8"
elif [ "$board" == "corsola" ]; then
    reco_name="chromeos_16002.60.0_corsola_recovery_stable-channel_mp-v14"
elif [ "$board" == "brya" ]; then
    reco_name="chromeos_16002.60.0_brya_recovery_stable-channel_mp-v18"
elif [ "$board" == "dedede" ]; then
    reco_name="chromeos_16002.60.0_dedede_recovery_stable-channel_mp-v50"
else
    echo "Unsupported board. note: your board name must not be capitalized.  Please use another method to create badbr0ker, or contact us."
    exit 1
fi
check_deps() {
	for dep in "$@"; do
		command -v "$dep" &>/dev/null || echo "$dep"
	done
}
missing_deps=$(check_deps partx sgdisk mkfs.ext4 cryptsetup lvm numfmt tar curl git python3 protoc gzip)
[ "$missing_deps" ] && fail "The following required commands weren't found in PATH:\n${missing_deps}"


echo "running update_downloader.sh"
bash update_downloader.sh "$board" || fail "update_downloader.sh exited with an error"

recopath="$reco_name.bin"
recozippedpath="$reco_name.bin.zip"
recolink="https://dl.google.com/dl/edgedl/chromeos/recovery/$recozippedpath"

echo "Downloading 124 recovery image"
wget "$recolink" || fail "Failed to download recovery image"

echo "Extracting 124 recovery image"
unzip "$recozippedpath" || fail "Failed to unzip recovery image"

echo "Deleting 124 recovery image zip (unneeded now)"
rm "$recozippedpath" || fail "Failed to delete zipped recovery image"

echo "running build_badrecovery.sh"
sudo ./build_badrecovery.sh -i "$recopath" -t unverified || fail "build_badrecovery.sh exited with an error"
echo "Cleaning up directory"
rm -rf unverified/16093
echo "No errors detected while buildng the badbr0ker image"
echo "File saved to $recopath"

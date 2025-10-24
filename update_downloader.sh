#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=${SCRIPT_DIR:-"."}

set -eE

URL_FILE="$SCRIPT_DIR/lib/latest_r132.txt"
OUT_DIR="$SCRIPT_DIR/badbr0ker"
UPDATE_ENGINE="$SCRIPT_DIR/lib/update_engine"
UPDATE_SOURCE="https://dl.google.com/chromeos"

fail() {
	printf "%s\n" "$*" >&2
	exit 1
}

readlink /proc/$$/exe | grep -q bash || fail "Please run with bash"
[ -f "$URL_FILE" ] || fail "Could not find required URL list at $URL_FILE"

check_deps() {
	for dep in "$@"; do
		command -v "$dep" &>/dev/null || echo "$dep"
	done
}

missing_deps=$(check_deps curl git python3 protoc gzip)
[ "$missing_deps" ] && fail "The following required commands weren't found in PATH:\n${missing_deps}"

cleanup() {
	[ -d "$WORKDIR" ] && rm -rf "$WORKDIR"
	trap - EXIT INT
}

trap 'echo $BASH_COMMAND failed with exit code $?.' ERR
trap 'cleanup; exit' EXIT
trap 'echo Abort.; cleanup; exit' INT

[ -n "$1" ] || fail "Usage: $0 <board> [output dir]"

WORKDIR=$(mktemp -d)
BOARD="$1"
if [ -n "$2" ]; then
	[ -d "$2" ] || fail "'$2' is not a directory"
	OUT_DIR="$2"
else
	mkdir -p "$OUT_DIR"
fi
if [ "$BOARD" = "eve" ]; then
    echo "BOARD is eve, you will need to manually recover to 132 :("
	exit
fi

file_line=$(grep "^${BOARD}," "$URL_FILE") || fail "board '$BOARD' is not in board list"
file_name=$(echo "$file_line" | cut -d, -f2)
file_version=$(echo "$file_name" | cut -d_ -f2)
major_version=$(echo "$file_version" | cut -d. -f1)
file_channel=$(echo "$file_name" | cut -d_ -f4)
file_url="$UPDATE_SOURCE/$BOARD/$file_version/$file_channel/$file_name"

echo "Downloading update payload..."
wget --show-progress "$file_url" -O "$WORKDIR/$file_name"

if ! [ -d "$UPDATE_ENGINE" ]; then
	echo "Downloading update_engine..."
	git clone -n https://chromium.googlesource.com/aosp/platform/system/update_engine "$UPDATE_ENGINE"
	(cd "$UPDATE_ENGINE"; git checkout c5a026d8c9ad881ee7834eb245a447455b2788c7)
fi

protoc --proto_path="$UPDATE_ENGINE" --python_out="$UPDATE_ENGINE"/scripts/update_payload "$UPDATE_ENGINE"/update_metadata.proto

echo "Extracting update payload..."
python3 "$UPDATE_ENGINE"/scripts/paycheck.py "$WORKDIR/$file_name" --part_names kernel root --out_dst_part_paths "$WORKDIR"/kern "$WORKDIR"/root
rm "$WORKDIR/$file_name"

echo "Compressing update payload..."
mkdir -p "$OUT_DIR/$major_version/$BOARD"
gzip -c "$WORKDIR"/kern >"$OUT_DIR/$major_version/$BOARD/kern.gz"
gzip -c "$WORKDIR"/root >"$OUT_DIR/$major_version/$BOARD/root.gz"

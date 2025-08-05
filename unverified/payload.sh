#!/bin/sh

mexit(){
    printf "$1\n"
    printf "exiting...\n"
        echo "Error detected.  Please report this."
    echo "Here is your disk layout:"
    fdisk -l
        printf "\033]input:on\a"
    /bin/sh
}

get_fixed_dst_drive() {
    local dev
    if [ -z "${DEFAULT_ROOTDEV}" ]; then
        for dev in /sys/block/sd* /sys/block/mmcblk*; do
            if [ ! -d "${dev}" ] || [ "$(cat "${dev}/removable")" = 1 ] || [ "$(cat "${dev}/size")" -lt 2097152 ]; then
                continue
            fi
            if [ -f "${dev}/device/type" ]; then
                case "$(cat "${dev}/device/type")" in
                SD*)
                    continue;
                    ;;
                esac
            fi
            DEFAULT_ROOTDEV="{$dev}"
        done
    fi
    if [ -z "${DEFAULT_ROOTDEV}" ]; then
        dev=""
    else
        dev="/dev/$(basename ${DEFAULT_ROOTDEV})"
        if [ ! -b "${dev}" ]; then
            dev=""
        fi
    fi
    echo "${dev}"
}
# spinner is always the 2nd /bin/sh
spinner_pid=$(pgrep /bin/sh | head -n 2 | tail -n 1)
kill -9 "$spinner_pid"
pkill -9 tail
sleep 0.1

HAS_FRECON=0
if pgrep frecon >/dev/null 2>&1; then
    HAS_FRECON=1
    # restart frecon to make VT1 background black
    exec </dev/null >/dev/null 2>&1
    pkill -9 frecon || :
    rm -rf /run/frecon
    frecon-lite --enable-vt1 --daemon --no-login --enable-vts --pre-create-vts --num-vts=4 --enable-gfx
    until [ -e /run/frecon/vt0 ]; do
        sleep 0.1
    done
    exec </run/frecon/vt0 >/run/frecon/vt0 2>&1
    # note: switchvt OSC code only works on 105+
    printf "\033]switchvt:0\a\033]input:off\a"
    /bin/sh | tee /run/frecon/vt1 /run/frecon/vt2 >/run/frecon/vt3
else
    exec </dev/tty1 >/dev/tty1 2>&1
    chvt 1
    stty -echo
    /bin/sh | tee /dev/tty2 /dev/tty3 >/dev/tty4
fi
printf "\033]input:on\a"
# run the br0ker script
/usb/usr/sbin/br0ker.sh

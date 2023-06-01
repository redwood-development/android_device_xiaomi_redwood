#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/camera/pure*_parameter.xml)
            sed -i "s/=\([0-9]\+\)>/=\"\1\">/g" "${2}"
            ;;
        vendor/lib64/hw/camera.xiaomi.so)
            # Before
            # 21 00 80 52     mov        w1,#0x1
            # 29 07 00 94     bl         <EXTERNAL>::android::hardware::configureRpcThr
            # After
            # 21 00 80 52     mov        w1,#0x1
            # 1f 20 03 d5     nop
            sed -i "s/\x21\x00\x80\x52\x29\x07\x00\x94/\x21\x00\x80\x52\x1f\x20\x03\xd5/g" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=redwood
export DEVICE_COMMON=sm8350-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"

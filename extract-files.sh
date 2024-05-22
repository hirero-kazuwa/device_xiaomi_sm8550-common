#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE_COMMON=sm8550-common
VENDOR_COMMON=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_FIRMWARE=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-firmware )
                ONLY_FIRMWARE=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        odm/lib64/hw/vendor.xiaomi.sensor.citsensorservice@2.0-impl.so)
            sed -i 's/_ZN13DisplayConfig10ClientImpl13ClientImplGetENSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEEPNS_14ConfigCallbackE/_ZN13DisplayConfig10ClientImpl4InitENSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEEPNS_14ConfigCallbackE\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0/g' "${2}"
            ;;
        odm/lib64/hw/displayfeature.default.so)
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libmt@1.3.so)
            "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v33.so" "${2}"
            ;;
        odm/etc/init/vendor.xiaomi.sensor.citsensorservice@2.0-service.rc)
            sed -i 's/group system input/group system input\n    task_profiles ServiceCapacityLow/' "${2}"
            ;;
        vendor/bin/hw/android.hardware.security.keymint-service-qti | vendor/lib64/libqtikeymint.so)
            "${PATCHELF}" --add-needed android.hardware.security.rkp-V3-ndk.so "${2}"
            ;;
        vendor/bin/hw/dolbycodec2 | vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service | vendor/bin/hw/vendor.dolby.media.c2@1.0-service | vendor/lib64/hw/audio.primary.kalama.so)
            "${PATCHELF}" --add-needed "libstagefright_foundation-v33.so" "${2}"
            ;;
    esac
}

if [ -z "${ONLY_FIRMWARE}" ] && [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../../${VENDOR}/${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    if [ -z "${ONLY_FIRMWARE}" ]; then
        extract "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    fi

    if [ -z "${SECTION}" ] && [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" ]; then
        extract_firmware "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" "${SRC}"
    fi
fi

"${MY_DIR}/setup-makefiles.sh"

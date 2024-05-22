#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/xiaomi/sm8550-common
KERNEL_PATH := device/xiaomi/sm8550-common/ishtar-kernel

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
SELINUX_IGNORE_NEVERALLOWS := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-hidl"

# Audio
$(call soong_config_set, android_hardware_audio, run_64bit, true)

AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_LSM_HIDL := true
AUDIO_FEATURE_ENABLED_PAL_HIDL := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_USE_STUB_HAL := true
BOARD_SUPPORTS_OPENSOURCE_STHAL := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

TARGET_USES_QCOM_MM_AUDIO := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := kalama
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
BOARD_VENDOR := xiaomi
TARGET_SOC := kalama

BOARD_ROOT_EXTRA_SYMLINKS := \
    /vendor/fsg:/fsg

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth/include

# Camera
TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED := true

# Display
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE := false
TARGET_USES_DISPLAY_RENDER_INTENTS := true
TARGET_USES_GRALLOC4 := true
TARGET_USES_HWC2 := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/configs/config.fs

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
$(call soong_config_set, qtilocation, feature_nhz, false)

# Lineage Health
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_PATH := /sys/class/qcom-battery/input_suspend
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_ENABLED := 0
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_DISABLED := 1
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS := false

# Init
TARGET_INIT_VENDOR_LIB := //$(COMMON_PATH):libinit_ishtar
TARGET_RECOVERY_DEVICE_MODULES := libinit_ishtar

# Kernel
BOARD_USES_DT := true

BOARD_KERNEL_PAGESIZE := 4096

BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

BOARD_KERNEL_CMDLINE := \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    disable_dma32=on \
    loop.max_part=7 \
    msm_rtb.filter=0x237 \
    pcie_ports=compat \
    service_locator.enable=1 \
    swinfo.fingerprint=$(LINEAGE_VERSION) \
    mtdoops.fingerprint=$(LINEAGE_VERSION)

BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    androidboot.selinux=permissive

BOARD_KERNEL_IMAGE_NAME := Image
BOARD_RAMDISK_USE_LZ4 := true
TARGET_KERNEL_APPEND_DTB := false
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)
TARGET_KERNEL_CONFIG := \
    gki_defconfig \
    vendor/kalama_GKI.config

# Kill lineage kernel build task while preserving kernel
TARGET_NO_KERNEL_OVERRIDE := true

#BOARD_USES_GENERIC_KERNEL_IMAGE := true
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_VERSION := 5.15
TARGET_PREBUILT_KERNEL := device/xiaomi/sm8550-common/ishtar-kernel/Image
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img
TARGET_PREBUILT_DTB := $(KERNEL_PATH)/dtb.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
PRODUCT_COPY_FILES += \
    $(TARGET_PREBUILT_DTB):$(TARGET_COPY_OUT)/dtb.img

# Kernel modules
BOOT_KERNEL_MODULES := $(strip $(shell cat $(COMMON_PATH)/ishtar-kernel/vendor_ramdisk/modules.load.recovery))
BOARD_SYSTEM_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/system_dlkm/modules.load))

BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/vendor_ramdisk/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_ramdisk/modules.blocklist

BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_ramdisk/modules.load.recovery))
RECOVERY_MODULES := $(addprefix $(KERNEL_PATH)/vendor_ramdisk/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))

BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))

BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/vendor_dlkm/, $(BOARD_VENDOR_KERNEL_MODULES_LOAD))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=  $(KERNEL_PATH)/vendor_dlkm/modules.blocklist

# Kernel modules
#BOOT_KERNEL_MODULES := $(strip $(shell cat $(COMMON_PATH)/ishtar-kernel/vendor_boot/modules.load.recovery))
#BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(COMMON_PATH)/ishtar-kernel/vendor_dlkm/*.ko)
#BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(COMMON_PATH)/ishtar-kernel/vendor_dlkm/modules.load))
#BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=  $(COMMON_PATH)/ishtar-kernel/vendor_dlkm/modules.blocklist
#BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(COMMON_PATH)/ishtar-kernel/vendor_boot/*.ko)
#BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat  $(COMMON_PATH)/ishtar-kernel/vendor_boot/modules.load))
#BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(COMMON_PATH)/ishtar-kernel/vendor_boot/modules.blocklist
#BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(COMMON_PATH)/ishtar-kernel/vendor_boot/modules.load.recovery))

#PRODUCT_COPY_FILES += \
#    $(call find-copy-subdir-files,*,$(COMMON_PATH)/ishtar-kernel/vendor_dlkm/,$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules) \
#    $(call find-copy-subdir-files,*,$(COMMON_PATH)/ishtar-kernel/vendor_boot/,$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules) \
#    $(call find-copy-subdir-files,*,$(COMMON_PATH)/ishtar-kernel/system_dlkm/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/lib/modules/)

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Platform
BOARD_USES_QCOM_HARDWARE := true
QCOM_BOARD_PLATFORMS += kalama
TARGET_BOARD_PLATFORM := kalama
TARGET_BOARD_PLATFORM_GPU := qcom-adreno740

# Power
TARGET_POWERHAL_MODE_EXT := $(COMMON_PATH)/power/power-mode.cpp

# PowerShare
SOONG_CONFIG_NAMESPACES += XIAOMI_POWERSHARE
SOONG_CONFIG_XIAOMI_POWERSHARE := WIRELESS_TX_ENABLE_PATH
SOONG_CONFIG_XIAOMI_POWERSHARE_WIRELESS_TX_ENABLE_PATH := /sys/class/qcom-battery/reverse_chg_mode

# Properties
TARGET_ODM_PROP += $(COMMON_PATH)/properties/odm.prop
TARGET_PRODUCT_PROP += $(COMMON_PATH)/properties/product.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/properties/system.prop
TARGET_SYSTEM_EXT_PROP += $(COMMON_PATH)/properties/system_ext.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/properties/vendor.prop

# Recovery
SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.qcom
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := false
PRODUCT_COPY_FILES += $(COMMON_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2024-01-01

# Sepolicy
include device/qcom/sepolicy_vndr/SEPolicy.mk
include device/xiaomi/sepolicy/SEPolicy.mk
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/public
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor

# VINTF
DEVICE_MANIFEST_SKUS := kalama
DEVICE_MANIFEST_KALAMA_FILES := $(COMMON_PATH)/vintf/manifest_kalama.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(COMMON_PATH)/vintf/compatibility_matrix.device.xml \
    $(COMMON_PATH)/vintf/compatibility_matrix.xiaomi.xml \
    device/qcom/vendor-common/vintf/vendor_framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml \
    vendor/lineage/config/device_framework_matrix.xml

# VNDK
BOARD_VNDK_VERSION := current

# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
QC_WIFI_HIDL_FEATURE_DUAL_AP := true
QC_WIFI_HIDL_FEATURE_DUAL_STA := true
WIFI_DRIVER_BUILT := qca_cld3
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_AWARE := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

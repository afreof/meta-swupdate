require libubootenv.inc
SRCREV = "9e121d41113dc0313452b2c00627097c46802c10"
PV_append = "+git${SRCPV}"

DEFAULT_PREFERENCE = "-1"

SRC_URI += " \
    file://0001-add-.editorconfig-file.patch \
    file://0002-add-missing-includes.patch \
    file://0003-handle-protected-mmcblk_boot_-devices.patch \
"

require swupdate.inc

DEFAULT_PREFERENCE = "-1"

SRCREV ?= "045a618a725d0a2fce64161f10101c0004ac5d85"
PV = "2019.04+git${SRCPV}"

SYSTEMD_SERVICE_${PN} += " \
    swupdate.socket \
"

require swupdate.inc
require swupdate_tools.inc

SRC_URI += "file://0001-systemd-generic-startup.patch"

DEFAULT_PREFERENCE = "-1"

SRCREV ?= "da974cd6fe8f000d22a943f21fc1c8aadb743955"

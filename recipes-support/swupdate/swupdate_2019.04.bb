require swupdate.inc
require swupdate_tools.inc

SRC_URI += " \
     file://swupdate.service \
     file://swupdate-usb.rules \
     file://swupdate-usb@.service \
     file://swupdate-progress.service \
     file://systemd-tmpfiles-swupdate.conf \
     "

SRCREV = "d39f4b8e00ef1929545b66158e45b82ea922bf81"

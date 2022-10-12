#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI PBX Administration
LUCI_DEPENDS:= +asterisk +asterisk-app-authenticate +asterisk-app-disa \
        +asterisk-app-system \
	+asterisk-codec-a-mu +asterisk-codec-alaw +asterisk-func-cut \
	+asterisk-res-clioriginate +asterisk-func-channel \
	+asterisk-app-record +asterisk-app-senddtmf +asterisk-cdr \
        +asterisk-chan-sip +asterisk-res-rtp-asterisk +asterisk-pjsip \
	+asterisk-bridge-simple

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

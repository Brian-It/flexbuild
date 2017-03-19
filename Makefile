#####################################
#
# Copyright 2017 NXP
#
#####################################

ifndef TOPDIR
  TOPDIR = $(shell cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
endif

include build.cfg

# override default config during run-time
ifeq ($(COMPONENT),rcw)
BUILD_RCW = y
export BUILD_RCW
endif

ifeq ($(COMPONENT),uboot)
BUILD_UBOOT = y
export BUILD_UBOOT
endif

ifeq ($(COMPONENT),uefi)
BUILD_UEFI = y
export BUILD_UEFI
endif


all:
	@$(MAKE) -C packages

uboot uefi rcw ppa:
	@$(MAKE) -C packages/qoriq-firmware $@

firmware linux apps:
	@$(MAKE) -C packages/qoriq-$@

distroinstaller:
	@$(MAKE) -C packages/installer

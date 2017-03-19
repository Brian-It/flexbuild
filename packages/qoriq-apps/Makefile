#####################################
#
# Copyright 2017 NXP
#
######################################

include ../../build.cfg

all: build-targets

build-targets:
ifeq ($(BUILD_RESTOOL), y)
	@echo "Building restool ..."
	@if [ ! -d restool ]; then git clone $(STASH_DPAA2_GIT)/restool; fi
	@make -C restool
	@make -C restool install
endif

ifeq ($(BUILD_FLIB), y)
	@echo "Building flib ..."
	@if [ ! -d flib ]; then git clone $(STASH_DPAAMODULE_GIT)/flib; fi
	@make -C flib install
endif

ifeq ($(BUILD_FMLIB), y)
	@echo "Building fmlib ..."
	@if [ ! -d fmlib ]; then git clone $(STASH_DPAAMODULE_GIT)/fmlib; fi
	@make -C fmlib install-libfm-arm64a53
	@make -C fmlib install-libfm-arm64a72
endif

ifeq ($(BUILD_FMC), y)
	@if [ ! -d fmc ]; then git clone $(STASH_DPAAMODULE_GIT)/fmc; fi
	@echo "Building fmc ..."
	@cp -rf fmlib/include/fmd $(DESTDIR)/usr/include
	@make -C fmc/source
endif

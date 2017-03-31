#####################################
#
# Copyright 2017 NXP
#
######################################

include ../../build.cfg

ifeq ($(BUILD_LINUX_DEV), y)
	LINUX_TREE_LIST += $(LINUX_DEV_TREE_NAME)
endif

ifeq ($(BUILD_LINUX), y)
	LINUX_TREE_LIST += $(LINUX_TREE_NAME)
endif

ifeq ($(BUILD_LTS), y)
	LINUX_TREE_LIST += $(LTS_TREE_NAME)
endif

ifeq ($(DESTARCH),arm64)
	DEFCONFIG_LIST ?= defconfig freescale.config distro.config
else
	DEFCONFIG_LIST ?= ls_aarch32_defconfig
endif


all: setup-gits build-linux

setup-gits:
	@$(foreach name,$(LINUX_TREE_LIST),test -d $(name) || (git clone $(LSDK_GITHUB_URL)/$(name).git))

build-linux:
ifneq ($(BUILD_LINUX)_$(BUILD_LTS), n_n)
	@echo "building Linux for $(LINUX_TREE_LIST) ..."
	@echo "toolchain = $(CROSS_COMPILE)gcc   DEFCONFIG_LIST = $(DEFCONFIG_LIST)"
	@for ltree in $(LINUX_TREE_LIST); do \
		if [ $(DESTARCH) = arm64 ]; then locarch=arm64; dtbstr=freescale/*.dtb; \
			else locarch=arm; dtbstr=ls*.dtb; fi && \
		if [ $$ltree = $(LTS_TREE_NAME) ]; then \
			remotebranch=$(LTS_BRANCH); localbranch=$(LTS_BRANCH_NAME); \
		else if [ $$ltree = $(LINUX_TREE_NAME) ]; then \
			remotebranch=$(LINUX_BRANCH); localbranch=$(LINUX_BRANCH_NAME); \
		fi; fi; \
		cd $(TOPDIR)/packages/qoriq-linux/$$ltree && \
		if [ "$$(cat .git/HEAD | grep $(LTS_BRANCH_NAME) | cut -d/ -f3)" != "$(LTS_BRANCH_NAME)" ]; then  \
		    if [ "$$(git branch  | grep $(LTS_BRANCH_NAME))" != "$(LTS_BRANCH_NAME)" ]; then \
		    git checkout $(LTS_BRANCH) -b $(LTS_BRANCH_NAME); \
		    else git checkout $(LTS_BRANCH_NAME); fi; \
		fi; \
		$(MAKE) mrproper; $(MAKE) $(DEFCONFIG_LIST); $(MAKE) -j$(JOBS) all; \
		$(MAKE) modules; $(MAKE) INSTALL_MOD_PATH=$(TOPDIR)/build/qoriq-linux/$$ltree/$(DESTARCH) modules_install; \
		if [ ! -d  $(TOPDIR)/build/qoriq-linux/$$ltree/$(DESTARCH) ]; then \
		mkdir -p $(TOPDIR)/build/qoriq-linux/$$ltree/$(DESTARCH); fi && \
		cp arch/$$locarch/boot/Image*  $(TOPDIR)/build/qoriq-linux/$$ltree/$(DESTARCH) && \
		ls arch/$$locarch/boot/dts/$$dtbstr | grep -E 'rdb|frdm|twr' | xargs -I {} cp {} \
		$(TOPDIR)/build/qoriq-linux/$$ltree/$(DESTARCH)/; \
	 done
endif

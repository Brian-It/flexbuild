#####################################
#
# Copyright 2017 NXP
#
#####################################

include ../../build.cfg

MC_LISTS := mc-binary dpl-examples
ETH_PHY_LISTS := firmware-aquantia firmware-cortina
RCWSRCBRD := $(filter-out ls2088ardb ls1012ardb ls1012afrdm,$(MACHINE_LIST))
PPASUBDIRS = soc-ls1012 soc-ls1028 soc-ls1043 soc-ls1046 soc-ls1088 \
	    soc-ls2080 soc-ls2088 soc-la1575 soc-lx2160


firmware: uboot uefi ppa rcw bin-firmwares

uboot:
ifeq ($(BUILD_UBOOT), y)
	@echo "building uboot ..."
	@if [ ! -d $(UBOOT_TREE_NAME) ]; then git clone $(LSDK_GITHUB_URL)/$(UBOOT_TREE_NAME); fi
	@cd $(UBOOT_TREE_NAME) && if [ "$$(cat .git/HEAD | grep $(UBOOT_BRANCH_NAME) | cut -d/ -f3)" != "$(UBOOT_BRANCH_NAME)" ]; then  \
	 if [ "$$(git branch | grep $(UBOOT_BRANCH_NAME))" != "$(UBOOT_BRANCH_NAME)" ]; then \
		git checkout $(UBOOT_BRANCH) -b $(UBOOT_BRANCH_NAME) else git checkout $(UBOOT_BRANCH_NAME); fi; \
	 fi

ifeq ($(MACHINE), all)
	@echo building uboot for $(MACHINE_LISTS)
	@for brd in $(MACHINE_LISTS); do \
		echo "\n******** machine = $$brd ************"; \
		if [ $$brd != ls2088ardb ]; then \
			for cfg in `ls $(UBOOT_TREE_NAME)/configs/*$$brd* 2>/dev/null | cut -d/ -f3 | grep -E 'qspi|sdcard|rdb_defconfig'`; do \
				$(call build-uboot-target,$$cfg) ; \
			done; \
		else \
			for cfg in `ls $(UBOOT_TREE_NAME)/configs/*ls2080* 2>/dev/null | cut -d/ -f3 | grep -E 'qspi|sdcard|rdb_defconfig'`; do \
				$(call build-uboot-target,$$cfg) ; \
			done; \
		fi; \
	 done

else
	@echo "building uboot for $(MACHINE)"
ifeq ($(MACHINE), ls2088ardb)
	@$(foreach cfg,$(shell ls $(UBOOT_TREE_NAME)/configs/*ls2080ardb* 2>/dev/null | \
	 cut -d/ -f3 | grep -E 'qspi|sdcard|rdb_defconfig'),$(call build-uboot-target,$(cfg)))
else
	@$(foreach cfg,$(shell ls $(UBOOT_TREE_NAME)/configs/*$(MACHINE)* 2>/dev/null | \
	 cut -d/ -f3 | grep -E 'qspi|sdcard|rdb_defconfig'),$(call build-uboot-target,$(cfg)))
endif
endif


define build-uboot-target
	$(MAKE) -C $(UBOOT_TREE_NAME) distclean && $(MAKE) -C $(UBOOT_TREE_NAME) $(1)  && \
	$(MAKE) -C $(UBOOT_TREE_NAME) -j$(JOBS) && \
	if [ $(MACHINE) != all ]; then brd=$(MACHINE); fi && \
	if [ ! -d $(TOPDIR)/build/qoriq-firmware/u-boot/$$brd ]; then mkdir -p $(TOPDIR)/build/qoriq-firmware/u-boot/$$brd; fi &&  \
	if [ -z $$(echo $(1) | grep -E 'qspi|rdb_defconfig' ) ]; then srcbin=u-boot-with-spl-pbl.bin; else srcbin=u-boot-dtb.bin; fi && \
	if [ ! -z $$(echo $(1) | grep 'qspi' ) ]; then tgtbin=u-boot-$$brd-qspiboot.bin; else if [ ! -z $$(echo $(1) | grep 'sdcard' ) ]; \
	   then tgtbin=u-boot-$$brd-sdboot.bin; else  tgtbin=u-boot-$$brd-norboot.bin; fi; fi &&  \
	cp $(UBOOT_TREE_NAME)/$$srcbin $(TOPDIR)/build/qoriq-firmware/u-boot/$$brd/$$tgtbin;
endef
endif

uefi:
ifeq ($(BUILD_UEFI), y)
	@echo "uefi will be supported later"
endif


rcw:
ifeq ($(BUILD_RCW), y)
	@echo "building rcw ..."
	@if [ ! -d $(RCW_TREE_NAME) ]; then git clone $(LSDK_GITHUB_URL)/$(RCW_TREE_NAME).git; fi
	@cd $(RCW_TREE_NAME) && if [ "$$(cat .git/HEAD | grep $(RCW_BRANCH_NAME) | cut -d/ -f3)" != "$(RCW_BRANCH_NAME)" ]; \
	 then git checkout $(RCW_BRANCH) -b $(RCW_BRANCH_NAME); fi
	@for brd in $(RCWSRCBRD); do $(MAKE) -C $(RCW_TREE_NAME)/$$brd; done
	@if [ ! -d $(TOPDIR)/build/qoriq-firmware/rcw ]; then mkdir -p $(TOPDIR)/build/qoriq-firmware/rcw; fi
	@$(foreach brd,$(MACHINE_LIST),$(shell if [ ! -d $(TOPDIR)/build/qoriq-firmware/rcw/$$brd ]; then mkdir -p $(TOPDIR)/build/qoriq-firmware/rcw/$$brd; fi))
	@for brd in $(MACHINE_LIST) ; do cd $(TOPDIR)/packages/qoriq-firmware/$(RCW_TREE_NAME)/$$brd &&  \
	    for tmpdir in `ls -l | grep ^d | awk '{print $$9}'`; do \
		cp -rf $$tmpdir $(TOPDIR)/build/qoriq-firmware/rcw/$$brd; \
		rm -f $(TOPDIR)/build/qoriq-firmware/rcw/$$brd/*.rcw; \
		rm -f $(TOPDIR)/build/qoriq-firmware/rcw/$$brd/$$tmpdir/*.rcw; \
	    done; \
	 done
endif

ppa:
ifeq ($(BUILD_PPA), y)
	@echo "Building ppa ... "
	@if [ ! -d ppa-generic ]; then git clone $(LSDK_GITHUB_URL)/ppa-generic.git; fi
	@if [ ! -d $(TOPDIR)/build/qoriq-firmware/ppa ]; then mkdir -p $(TOPDIR)/build/qoriq-firmware/ppa; fi
	@cd ppa-generic/ppa && ./build rdb-fit all
	@if [ ! -d $(TOPDIR)/build/qoriq-firmware/ppa/soc-ls2088 ]; then ls -l ppa-generic/ppa/soc-*/build/obj/ppa.itb \
	 | cut -d/ -f3 | xargs -i mkdir $(TOPDIR)/build/qoriq-firmware/ppa/{};fi
	@$(foreach name,$(PPASUBDIRS),cp ppa-generic/ppa/$(name)/build/obj/ppa.itb $(TOPDIR)/build/qoriq-firmware/ppa/$(name) ;)
endif


bin-firmwares: dpaa1-fman-ucode qe-ucode dpaa2-mc-dpl-examples eth-phy

dpaa1-fman-ucode:
	@if [ ! -d fm-ucode ]; then git clone $(LSDK_GITHUB_URL)/fm-ucode; fi
	@if [ ! -h $(TOPDIR)/build/qoriq-firmware/fm-ucode ]; then \
	 ln -s $(TOPDIR)/packages/qoriq-firmware/fm-ucode $(TOPDIR)/build/qoriq-firmware/fm-ucode; fi


qe-ucode:
	@if [ ! -d qe-ucode ]; then git clone $(LSDK_GITHUB_URL)/qe-ucode; fi
	@if [ ! -h $(TOPDIR)/build/qoriq-firmware/qe-ucode ]; then \
	 ln -s $(TOPDIR)/packages/qoriq-firmware/qe-ucode $(TOPDIR)/build/qoriq-firmware/qe-ucode; fi


dpaa2-mc-dpl-examples:
	@for name in $(MC_LISTS); do \
		if [ ! -d $$name ]; then git clone $(LSDK_GITHUB_URL)/$$name; fi; \
		if [ ! -h $(TOPDIR)/build/qoriq-firmware/$$name ]; then \
		ln -s $(TOPDIR)/packages/qoriq-firmware/$$name $(TOPDIR)/build/qoriq-firmware/$$name; fi; \
	done

eth-phy:
	@for phy in $(ETH_PHY_LISTS); do \
		if [ ! -d $$phy ]; then git clone $(LSDK_GITHUB_URL)/$$phy; fi; \
		if [ ! -h $(TOPDIR)/build/qoriq-firmware/$$phy ]; then \
		ln -s $(TOPDIR)/packages/qoriq-firmware/$$phy $(TOPDIR)/build/qoriq-firmware/$$phy; fi; \
	done


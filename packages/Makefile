#####################################
#
# Copyright 2017 NXP
#
#####################################

include ../build.cfg

SUBDIRS := $(shell ls -l | grep ^d | awk '{print $$9}')

all: $(SUBDIRS)

$(SUBDIRS): ECHO
	@$(MAKE) -C $@

ECHO:
	@echo $(SUBDIRS)

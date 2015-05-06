#!/usr/bin/env make
# -*- coding: utf-8; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-

# -----------------------------------------------------------------------------
# config
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := build

ROOT_DIR := $(shell pwd)
COMBO_DIR := $(ROOT_DIR)/combination
SRC_COMBO_SCRIPT=$(COMBO_DIR)/scripts/combo-layer
COMPO_DIR := $(ROOT_DIR)/components
CONF_DIR := $(ROOT_DIR)/examples

AVAILABLE_DISTROS := core oe poky exiguous
AVAILABLE_TARGETS := nodistro poky exiguous
AVAILABLE_IMAGES := core-image-minimal

DEFAULT_OPTIONS :=
DEFAULT_DISTRO := poky
DEFAULT_TARGET := qemux86-64
DEFAULT_IMAGE := core-image-minimal

OPTIONS ?= $(DEFAULT_OPTIONS)
DISTRO ?= $(DEFAULT_DISTRO)
TARGET ?= $(DEFAULT_TARGET)
IMAGE ?= $(DEFAULT_IMAGE)

# -----------------------------------------------------------------------------
# Print configuration information
# -----------------------------------------------------------------------------

$(info Available distributions: $(AVAILABLE_DISTROS))
$(info Available targets: $(AVAILABLE_TARGETS))
$(info Available images: $(AVAILABLE_IMAGES))
$(info )
$(info Default distribution: $(DEFAULT_DISTRO))
$(info Default target: $(DEFAULT_TARGET))
$(info Default image: $(DEFAULT_IMAGE))
$(info Default options: $(DEFAULT_OPTIONS))
$(info )
$(info Current distribution: $(DISTRO))
$(info Current target: $(TARGET))
$(info Current image: $(IMAGE))
$(info Current options: $(OPTIONS))
$(info )

# -----------------------------------------------------------------------------
# clean
# -----------------------------------------------------------------------------
.PHONY: clean
clean:
	$(info Clean the root folder...)
	@find $(ROOT_DIR) -type f -name "*~" -delete
	$(info Remove components...)
	@rm -rf $(COMPO_DIR)

.PHONY: mrproper
mrproper: clean
	$(info Remove combo-layer script...)
	@rm -f $(SRC_COMBO_SCRIPT)
	$(info Remove combination...)
	@rm -rf $(COMBO_DIR)

# -----------------------------------------------------------------------------
# build
# -----------------------------------------------------------------------------

.PHONY: build
build:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/$(DISTRO).conf \
        --machine $(TARGET) \
        --distro $(DISTRO) \
        --image $(IMAGE) \
        --options $(OPTIONS)

.PHONY: build_all
build_all:
	$(info TODO The target isn\'t implemented)

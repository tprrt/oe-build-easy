#!/usr/bin/env make
# -*- coding: utf-8; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-

# -----------------------------------------------------------------------------
# config
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := all

ROOT_DIR := $(shell pwd)
SRC_DIR := $(ROOT_DIR)/src
SRC_COMBO_SCRIPT=$(SRC_DIR)/scripts/combo-layer
REPOS_DIR := $(ROOT_DIR)/repos
CONF_DIR := $(ROOT_DIR)/examples

# -----------------------------------------------------------------------------
# clean
# -----------------------------------------------------------------------------
.PHONY: clean
clean:
	$(info Clean the root folder...)
	@find $(ROOT_DIR) -type f -name "*~" -delete
	$(info Clean the source folder...)
	@rm -rf $(SRC_DIR)

.PHONY: mrproper
mrproper: clean
	$(info Delete combo-layer script...)
	@rm -f $(SRC_COMBO_SCRIPT)
	$(info Clean repositories folder...)
	@rm -rf $(REPOS_DIR)

# -----------------------------------------------------------------------------
# OE-Core build
# -----------------------------------------------------------------------------

.PHONY: core-qemux86
core-qemux86:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemux86 nodistro \
        core-image-minimal-initramfs

.PHONY: core-qemux86-64
core-qemux86-64:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemux86-64 nodistro \
        core-image-minimal-initramfs

.PHONY: core-qemuarm
core-qemuarm:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemuarm nodistro \
        core-image-minimal-initramfs

.PHONY: core-qemuarm64
core-qemuarm64:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemuarm64 nodistro \
        core-image-minimal-initramfs

.PHONY: core-qemumips
core-qemumips:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemumips nodistro \
        core-image-minimal-initramfs

.PHONY: core-qemuppc
core-qemuppc:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemuppc nodistro \
        core-image-minimal-initramfs

.PHONY: core-all
core-all: core-qemux86 core-qemux86-64 core-qemuxarm core-qemuxarm64 \
          core-qemumips core-qemuppc

# -----------------------------------------------------------------------------
# Openembedded build
# -----------------------------------------------------------------------------

.PHONY: oe-qemux86
oe-qemux86:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemux86 nodistro \
        core-image-minimal-initramfs

.PHONY: oe-qemux86-64
oe-qemux86-64:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemux86-64 nodistro \
        core-image-minimal-initramfs

.PHONY: oe-qemuarm
oe-qemuarm:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemuarm nodistro \
        core-image-minimal-initramfs

.PHONY: oe-qemuarm64
oe-qemuarm64:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemuarm64 nodistro \
        core-image-minimal-initramfs

.PHONY: oe-qemumips
oe-qemumips:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemumips nodistro \
        core-image-minimal-initramfs

.PHONY: oe-qemuppc
oe-qemuppc:
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/oe.conf qemuppc nodistro \
        core-image-minimal-initramfs

.PHONY: oe-all
oe-all: oe-qemux86 oe-qemux86-64 oe-qemumips oe-qemuarm oe-qemuarm64 oe-qemuppc

# -----------------------------------------------------------------------------
# Poky build
# -----------------------------------------------------------------------------

.PHONY: poky-qemux86
poky-qemux86:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/poky.conf qemux86 poky core-image-minimal-initramfs

.PHONY: poky-qemux86-64
poky-qemux86-64:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/poky.conf qemux86-64 poky core-image-minimal-initramfs

.PHONY: poky-qemuarm
poky-qemuarm:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/poky.conf qemuarm poky core-image-minimal-initramfs

.PHONY: poky-qemuarm64
poky-qemuarm64:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/poky-build-easy \
        $(CONF_DIR)/poky.conf qemuarm64 poky core-image-minimal-initramfs

.PHONY: poky-qemumips
poky-qemumips:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/poky-build-easy \
        $(CONF_DIR)/poky.conf qemumips poky core-image-minimal-initramfs

.PHONY: poky-qemuppc
poky-qemuppc:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/poky-build-easy \
        $(CONF_DIR)/poky.conf qemuppc poky core-image-minimal-initramfs

.PHONY: poky-all
poky-all: poky-qemux86 poky-qemux86-64 poky-qemuarm poky-qemuarm64 \
    poky-qemumips poky-qemuppc

# -----------------------------------------------------------------------------
# Exiguous build
# -----------------------------------------------------------------------------

.PHONY: exiguous-qemux86
exiguous-qemux86:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemux86 exiguous core-image-minimal-initramfs

.PHONY: exiguous-qemux86-64
exiguous-qemux86-64:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemux86-64 exiguous core-image-minimal-initramfs

.PHONY: exiguous-qemuarm
exiguous-qemuarm:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemuarm exiguous core-image-minimal-initramfs

.PHONY: exiguous-qemuarm64
exiguous-qemuarm64:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemuarm64 exiguous core-image-minimal-initramfs

.PHONY: exiguous-qemumips
exiguous-qemumips:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemumips exiguous core-image-minimal-initramfs

.PHONY: exiguous-qemuppc
exiguous-qemuppc:
	TEMPLATECONF=meta-yocto/conf $(ROOT_DIR)/oe-build-easy \
        $(CONF_DIR)/exiguous.conf qemuppc exiguous core-image-minimal-initramfs

.PHONY: exiguous-all
exiguous-all: exiguous-qemux86 exiguous-qemux86-64 exiguous-qemuarm \
    exiguous-qemuarm64 exiguous-qemumips exiguous-qemuppc

# -----------------------------------------------------------------------------
# all
# -----------------------------------------------------------------------------
.PHONY: all
all: mrproper core-all oe-all poky-all exiguous-all

# -----------------------------------------------------------------------------
# tests
# -----------------------------------------------------------------------------
.PHONY: ci-tests
ci-tests: mrproper
	$(ROOT_DIR)/oe-build-easy $(CONF_DIR)/core.conf qemux86-64 nodistro \
        core-image-minimal-initramfs --not-build

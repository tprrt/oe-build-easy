# -----------------------------------------------------------------------------
# configugration
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := all

NPROC := $(shell nproc)

TOOLS_NEEDED := repo git gawk wget diffstat unzip chrpath xterm \
                python realpath patch

ROOT_DIR := $(shell pwd)

DEFAULT_MANIFEST_URL := $(shell echo "git@github.com:tprrt/manifest.git")
DEFAULT_MANIFEST_BRANCH := master
DEFAULT_MANIFEST := master.xml
MANIFEST_URL ?= ${DEFAULT_MANIFEST_URL}
MANIFEST_BRANCH ?= ${DEFAULT_MANIFEST_BRANCH}
MANIFEST ?= ${DEFAULT_MANIFEST}

DEFAULT_COMPO_DIR := ${ROOT_DIR}/components
DEFAULT_COMBO_DIR := ${ROOT_DIR}/combination
DEFAULT_BUILD_DIR := ${ROOT_DIR}/build
COMPO_DIR ?= ${DEFAULT_COMPO_DIR}
COMBO_DIR ?= ${DEFAULT_COMBO_DIR}
BUILD_DIR ?= ${DEFAULT_BUILD_DIR}

OE_BUILD_EASY_SCRIPT := ${COMPO_DIR}/meta-exiguous/scripts/oe-build-easy
DEFAULT_CONF_PATH := ${COMPO_DIR}/meta-exiguous/conf/combo-layer.conf
CONF_PATH ?= ${DEFAULT_CONF_PATH}

AVAILABLE_TARGETS := qemux86-64 x86_64 raspberrypi raspberrypi2 beaglebone
AVAILABLE_DISTROS := nodistro poky oe exiguous
AVAILABLE_IMAGES := core-image-minimal

DEFAULT_OPTIONS :=
DEFAULT_DISTRO := exiguous
DEFAULT_TARGET := qemux86-64
DEFAULT_IMAGE := core-image-minimal

OPTIONS ?= ${DEFAULT_OPTIONS}
DISTRO ?= ${DEFAULT_DISTRO}
TARGET ?= ${DEFAULT_TARGET}
IMAGE ?= ${DEFAULT_IMAGE}

# -----------------------------------------------------------------------------
# Print configuration information
# -----------------------------------------------------------------------------

.PHONY:config
config:
        $(info Manifest URL: ${MANIFEST_URL})
        $(info Branch manifest: ${MANIFEST_BRANCH})
        $(info Branch manifest: ${MANIFEST})
        $(info )
        $(info Components: ${COMPO_DIR})
        $(info Combination: ${COMBO_DIR})
        $(info Build: ${BUILD_DIR})
        $(info )
        $(info Combo configuration: ${CONF_PATH})
        $(info )
        $(info Distribution: ${DISTRO})
        $(info Target: ${TARGET})
        $(info Image: ${IMAGE})
        $(info Options: ${OPTIONS})
        $(info )

# -----------------------------------------------------------------------------
# clean the build environment
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	$(info Clean root folder...)
	@find ${ROOT_DIR} -type f -name "*~" -delete
	$(info Remove combination folder...)
	@rm -rf ${COMBO_DIR}

.PHONY: mrproper
mrproper: clean
	$(info Remove combination folder...)
	@rm -rf ${ROOT_DIR}/.repo
	@rm -rf ${COMPO_DIR}
	$(info Remove build folder...)
	@rm -rf ${BUILD_DIR}

# -----------------------------------------------------------------------------
# Check if all tools need are already installed
# -----------------------------------------------------------------------------

.PHONY: check
check:
	$(info Check if all tools need to build are available...)
        $(foreach TOOL, ${TOOLS_NEEDED}, $(shell which ${TOOL} >/dev/null || \
                echo "${TOOL} is not available" >&2; exit 1))

# -----------------------------------------------------------------------------
# Initialize the environment
# -----------------------------------------------------------------------------

${COMPO_DIR} ${COMBO_DIR}:
	repo init -u ${MANIFEST_URL} -b ${MANIFEST_BRANCH} -m ${MANIFEST} && repo sync -c -j${NPROC}
	repo sync -c -j${NPROC}
	repo start ${MANIFEST_BRANCH} --all

.PHONY: init
init: ${COMPO_DIR} ${COMBO_DIR}
        $(info Initialize environment to build...)

# -----------------------------------------------------------------------------
# build
# -----------------------------------------------------------------------------

.PHONY: ${BUILD_DIR}
${BUILD_DIR}: ${COMPO_DIR} ${COMBO_DIR}
	${OE_BUILD_EASY_SCRIPT} ${CONF_PATH} \
                --compodir ${COMPO_DIR} \
                --combodir ${COMBO_DIR} \
                --image ${IMAGE} \
                --machine ${TARGET} \
                --distro ${DISTRO} \
                --build $@ \
                --options ${OPTIONS}

.PHONY: build
build: ${BUILD_DIR}

# TODO build all available target

# -----------------------------------------------------------------------------
# oe-selftest
# -----------------------------------------------------------------------------

# TODO

# -----------------------------------------------------------------------------
# Update combination layer
# -----------------------------------------------------------------------------

# TODO

# -----------------------------------------------------------------------------
# Publish images built
# -----------------------------------------------------------------------------

# TODO

# -----------------------------------------------------------------------------
# Build world
# -----------------------------------------------------------------------------

# TODO

# -----------------------------------------------------------------------------
# all
# -----------------------------------------------------------------------------

.PHONY: all
all: config check init build
# all: info check init build oe-selftest update publish

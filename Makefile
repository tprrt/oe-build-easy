# -----------------------------------------------------------------------------
# configugration
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := all

NPROC := $(shell nproc)
DATETIME ?= $(shell date +%Y-%m-%d-%H:%M:%S)

TOOLS_NEEDED := repo git gawk wget diffstat unzip chrpath xterm \
                python realpath patch

ROOT_DIR := $(shell pwd)

DEFAULT_MANIFEST_URL := $(shell echo "git@github.com:tprrt/exiguous-manifest.git")
MANIFEST_URL ?= ${DEFAULT_MANIFEST_URL}
DEFAULT_MANIFEST_BRANCH := master
MANIFEST_BRANCH ?= ${DEFAULT_MANIFEST_BRANCH}
DEFAULT_MANIFEST := master.xml
MANIFEST ?= ${DEFAULT_MANIFEST}

DEFAULT_COMPO_DIR := ${ROOT_DIR}/components
COMPO_DIR ?= ${DEFAULT_COMPO_DIR}
export LOCAL_REPO_DIR=${COMPO_DIR}

DEFAULT_COMBO_DIR := ${ROOT_DIR}/combination
COMBO_DIR ?= ${DEFAULT_COMBO_DIR}
COMBO_URL := http://cgit.openembedded.org/openembedded-core/plain/scripts/combo-layer
# COMBO_URL := http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/combo-layer
export DEST_DIR=${COMBO_DIR}

SRC_SCRIPTS_DIR := ${COMBO_DIR}/scripts
SRC_COMBO_SCRIPT := ${SRC_SCRIPTS_DIR}/combo-layer
SRC_CONF_DIR := ${COMBO_DIR}/conf
SRC_CONF_PATH := ${SRC_CONF_DIR}/combo-layer.conf

DEFAULT_BUILD_DIR := ${ROOT_DIR}/build
BUILD_DIR ?= ${DEFAULT_BUILD_DIR}

DEFAULT_HISTORY_DIR := ${BUILD_DIR}/buildhistory
HISTORY_DIR ?= ${DEFAULT_HISTORY_DIR}

OE_BUILD_EASY_SCRIPT ?= ${COMPO_DIR}/meta-exiguous/scripts/oe-build-easy
OE_SELFTEST_SCRIPT := ${COMBO_DIR}/scripts/oe-selftest
OE_TEST_DEPENDENCIES_SCRIPT := ${COMBO_DIR}/scripts/test-dependencies.sh

DEFAULT_CONF_PATH := ${COMPO_DIR}/meta-exiguous/conf/$(basename ${MANIFEST}).conf
CONF_PATH ?= ${DEFAULT_CONF_PATH}

ifneq ("$(wildcard ${COMBO_DIR})","")
AVAILABLE_MACHINES := $(shell find ${COMBO_DIR} -regex ".*/meta.*/conf/machine/[^/]*.conf")
AVAILABLE_DISTROS := $(shell find ${COMBO_DIR} -regex ".*/meta.*/conf/distro/[^/]*.conf" )
AVAILABLE_IMAGES := $(shell find ${COMBO_DIR} -regex ".*/meta.*/recipes-.*/images/[^/].*.bb")
endif

DEFAULT_OPTIONS :=
DEFAULT_DISTRO := exiguous
DEFAULT_MACHINE := qemu-exiguous
DEFAULT_IMAGE := exiguous-image

OPTIONS ?= ${DEFAULT_OPTIONS}
DISTRO ?= ${DEFAULT_DISTRO}
MACHINE ?= ${DEFAULT_MACHINE}
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
        $(info Buildhistory: ${HISTORY_DIR})
        $(info )
        $(info Combo configuration: ${CONF_PATH})
        $(info )
        $(info Distribution: ${DISTRO})
        $(info Machine: ${MACHINE})
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
	$(foreach TOOL, ${TOOLS_NEEDED}, $(shell which ${TOOL} >/dev/null \
                || (echo "${TOOL} is not available" >&2; exit 1)))

# -----------------------------------------------------------------------------
# Initialize the environment
# -----------------------------------------------------------------------------

.PHONY: components
components:
	repo init -u ${MANIFEST_URL} -b ${MANIFEST_BRANCH} -m ${MANIFEST}
	repo sync --force-sync -j${NPROC}
	repo start $(basename ${MANIFEST}) --all || repo checkout $(basename ${MANIFEST})
	repo sync --force-sync -j${NPROC}

${COMPO_DIR}: components

.PHONY: combination
combination: ${COMPO_DIR}
	[ -d ${SRC_SCRIPTS_DIR} ] || mkdir -p ${SRC_SCRIPTS_DIR}
	[ -d ${SRC_CONF_DIR} ] || mkdir -p ${SRC_CONF_DIR}
	[ -f ${SRC_COMBO_SCRIPT} ] || ( wget ${COMBO_URL} -O ${SRC_COMBO_SCRIPT} && chmod a+x ${SRC_COMBO_SCRIPT} )
	[ -f ${SRC_CONF_PATH} ] || cp ${CONF_PATH} ${SRC_CONF_PATH}
	cd ${COMBO_DIR} && ${SRC_COMBO_SCRIPT} init -c ${SRC_CONF_PATH}
	(cd ${COMBO_DIR} && git add . && git commit -m "Updated on ${DATETIME}" 2>/dev/null) || true
	cd ${COMBO_DIR} && ${SRC_COMBO_SCRIPT} update -c ${SRC_CONF_PATH}

${COMBO_DIR}: combination

.PHONY: init
init: ${COMPO_DIR} ${COMBO_DIR} ${BUILD_DIR}
        $(info Initialize environment to build...)

# -----------------------------------------------------------------------------
# Parse recipes, also used to create the build folder
# -----------------------------------------------------------------------------

.PHONY: parse-only
parse-only: ${COMPO_DIR}
	${OE_BUILD_EASY_SCRIPT} ${CONF_PATH} \
		--compodir ${COMPO_DIR} \
		--combodir ${COMBO_DIR} \
		--image ${IMAGE} \
		--machine ${MACHINE} \
		--distro ${DISTRO} \
		--build ${BUILD_DIR} \
		--history ${HISTORY_DIR} \
		--options "--parse-only"

${BUILD_DIR}: parse-only

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------

.PHONY: build
build: ${COMPO_DIR}
	${OE_BUILD_EASY_SCRIPT} ${CONF_PATH} \
		--compodir ${COMPO_DIR} \
		--combodir ${COMBO_DIR} \
		--image ${IMAGE} \
		--machine ${MACHINE} \
		--distro ${DISTRO} \
		--build $@ \
		--history ${HISTORY_DIR} \
		--options ${OPTIONS}

# -----------------------------------------------------------------------------
# test-dependencies
# -----------------------------------------------------------------------------

.PHONY:test-dependencies
test-dependencies: ${BUILD_DIR}
	rm -rf ${BUILD_DIR}/test-dependencies
	mkdir ${BUILD_DIR}/test-dependencies
	cd ${BUILD_DIR} && ${OE_TEST_DEPENDENCIES_SCRIPT} \
		--targets="${IMAGE}" \
		--tmpdir="${BUILD_DIR}/test-dependencies"

# -----------------------------------------------------------------------------
# oe-selftest
# -----------------------------------------------------------------------------

.PHONY:oe-selftest
oe-selftest: ${BUILD_DIR}
	cd ${BUILD_DIR} && ${OE_SELFTEST_SCRIPT} --run-all-tests

# -----------------------------------------------------------------------------
# Update combination layer
# -----------------------------------------------------------------------------

# FIXME [script] Add a target to update combination layer

# -----------------------------------------------------------------------------
# Publish images built
# -----------------------------------------------------------------------------

# FIXME [script] Add a target to publish images built

# -----------------------------------------------------------------------------
# Build world
# -----------------------------------------------------------------------------

# FIXME [script] Add a target to build world

# -----------------------------------------------------------------------------
# all
# -----------------------------------------------------------------------------

.PHONY: all
all: clean config check init build
# all: clean config check init build test-dependencies oe-selftest update publish

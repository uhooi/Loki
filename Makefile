# Variables

PRODUCT_NAME := Loki
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 14 Pro Max
TEST_OS ?= 16.2
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

XCODEBUILD_BUILD_LOG_NAME := ${PRODUCT_NAME}_${PROJECT_NAME}_Build.log

FULL_PROJECT_NAME := Full

# Targets

.PHONY: setup
setup:
	$(MAKE) open

.PHONY: open
open:
	open ./${WORKSPACE_NAME}

.PHONY: build-debug-full
build-debug-full:
	$(MAKE) build-debug PROJECT_NAME=${FULL_PROJECT_NAME}

.PHONY: build-debug
build-debug:
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme '${PROJECT_NAME}' \
-destination ${TEST_DESTINATION} \
clean build \
| tee ./${XCODEBUILD_BUILD_LOG_NAME}


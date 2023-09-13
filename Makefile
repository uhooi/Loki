# Variables

PRODUCT_NAME := Loki
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 15 Pro Max
TEST_OS ?= 17.0
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

XCODEBUILD_BUILD_LOG_NAME := ${PRODUCT_NAME}_${PROJECT_NAME}_Build.log

PRODUCTION_PROJECT_NAME := Production
DEVELOP_PROJECT_NAME := Develop

PACKAGE_PATH := ./${PRODUCT_NAME}Package

# Targets

.PHONY: setup
setup:
	$(MAKE) open

.PHONY: open
open:
	open ./${WORKSPACE_NAME}

.PHONY: build-debug-production
build-debug-production:
	$(MAKE) build-debug PROJECT_NAME=${PRODUCTION_PROJECT_NAME}

.PHONY: build-debug-develop
build-debug-develop:
	$(MAKE) build-debug PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: build-debug
build-debug:
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme '${PROJECT_NAME}' \
-destination ${TEST_DESTINATION} \
-skipPackagePluginValidation \
clean build \
| tee ./${XCODEBUILD_BUILD_LOG_NAME}

.PHONY: lint
lint:
	swift package --package-path ${PACKAGE_PATH} plugin lint-source-code

.PHONY: format
format:
	swift package --package-path ${PACKAGE_PATH} plugin --allow-writing-to-package-directory format-source-code

.PHONY: analyze
analyze:
	swift package --package-path ${PACKAGE_PATH} plugin --allow-writing-to-package-directory analyze-source-code --fix --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

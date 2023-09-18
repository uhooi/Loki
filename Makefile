# Variables

PRODUCT_NAME := Loki
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 14 Pro Max
TEST_OS ?= 17.0
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

XCODEBUILD_BUILD_LOG_NAME := ${PRODUCT_NAME}_${PROJECT_NAME}_Build.log

PRODUCTION_PROJECT_NAME := Production
DEVELOP_PROJECT_NAME := Develop

SWIFTLINT := mint run realm/SwiftLint swiftlint

export MINT_PATH := ./.mint/lib
export MINT_LINK_PATH := ./.mint/bin

# Targets

.PHONY: setup
setup:
	$(MAKE) install-mint-dependencies
	$(MAKE) open

.PHONY: install-mint-dependencies
install-mint-dependencies:
	mint bootstrap --overwrite y

.PHONY: open
open:
	open ./${WORKSPACE_NAME}

.PHINY: clean
clean:
	rm -rf ./LokiPackage/.build/

.PHINY: distclean
distclean:
	rm -rf ./.mint
	rm -rf ~/Library/Developer/Xcode/DerivedData
	rm -rf ./LokiPackage/.swiftpm/
	$(MAKE) clean

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
	$(SWIFTLINT)

.PHONY: fix
fix:
	$(SWIFTLINT) --fix --format

.PHONY: analyze
analyze:
	$(MAKE) build-debug-develop
	$(SWIFTLINT) analyze --fix --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

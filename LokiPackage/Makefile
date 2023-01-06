# Variables

PRODUCT_NAME := Loki
FULL_PROJECT_NAME := Full
XCODEBUILD_BUILD_LOG_NAME := ${PRODUCT_NAME}_${FULL_PROJECT_NAME}_Build.log

# Targets

.PHONY: lint
lint:
	swift package plugin lint-source-code

.PHONY: format
format:
	swift package plugin --allow-writing-to-package-directory format-source-code

.PHONY: analyze
analyze:
	swift package plugin --allow-writing-to-package-directory analyze-source-code --fix --compiler-log-path ../${XCODEBUILD_BUILD_LOG_NAME}

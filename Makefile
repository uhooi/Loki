# Variables

PRODUCT_NAME := Loki
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

# Targets

.PHONY: setup
setup:
	$(MAKE) open

.PHONY: open
open:
	open ./${WORKSPACE_NAME}


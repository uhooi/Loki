# Variables

PRODUCT_NAME := Totonoi
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

# Targets

.PHONY: setup
setup:
	$(MAKE) open

.PHONY: open
open:
	open ./${WORKSPACE_NAME}


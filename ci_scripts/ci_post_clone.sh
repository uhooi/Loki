#!/bin/bash
# ref: https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/7
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool true

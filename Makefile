PREFIX?=/usr/local

CP=$(shell whereis cp) -Rf
MKDIR=$(shell whereis mkdir) -p
RM=$(shell whereis rm) -rf
RSYNC=$(shell whereis rsync) --archive --delete
SWIFT=$(shell whereis swift)
XCODEBUILD=$(shell whereis xcodebuild)

BINARY_DIRECTORY=$(PREFIX)/bin
FRAMEWORKS_DIRECTORY=$(PREFIX)/Frameworks
BINARY_NAME=unxip
FRAMEWORK_NAME=UnxipKit.framework

BUILD_DIRECTORY=$(shell pwd)/build/Release
OUTPUT_EXECUTABLE=$(BUILD_DIRECTORY)/$(BINARY_NAME)
OUTPUT_FRAMEWORK_PATH=$(BUILD_DIRECTORY)/$(FRAMEWORK_NAME)

INSTALL_EXECUTABLE_PATH=$(BINARY_DIRECTORY)/$(BINARY_NAME)
INSTALL_FRAMEWORK_PATH=$(BINARY_DIRECTORY)/$(FRAMEWORK_NAME)

.PHONY: build
build: generate-xcodeproj
	$(XCODEBUILD) build -target Unxip

.PHONY: install
install: build
	$(RSYNC) "$(OUTPUT_FRAMEWORK_PATH)" "$(BINARY_DIRECTORY)"
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: generate-xcodeproj
generate-xcodeproj:
	$(SWIFT) package generate-xcodeproj --xcconfig-overrides Configs.xcconfig

.PHONY: clean
clean:
	$(XCODEBUILD) clean
	$(SWIFT) package clean
	$(RM) build *.xcodeproj

PREFIX?=/usr/local

CD=cd
CP=$(shell whereis cp) -Rf
MKDIR=$(shell whereis mkdir) -p
RM=$(shell whereis rm) -rf
RSYNC=$(shell whereis rsync) --archive --delete
SWIFT=$(shell whereis swift)
XCODEBUILD=$(shell whereis xcodebuild)
ZIP=$(shell whereis zip) -q -r

BINARY_DIRECTORY=$(PREFIX)/bin
FRAMEWORKS_DIRECTORY=$(PREFIX)/Frameworks
BINARY_NAME=unxip
FRAMEWORK_NAME=UnxipKit.framework
PACKAGE_NAME=Unxip

BUILD_DIRECTORY=$(shell pwd)/build/Release
OUTPUT_EXECUTABLE=$(BUILD_DIRECTORY)/$(BINARY_NAME)
OUTPUT_FRAMEWORK_PATH=$(BUILD_DIRECTORY)/$(FRAMEWORK_NAME)

INSTALL_EXECUTABLE_PATH=$(BINARY_DIRECTORY)/$(BINARY_NAME)
INSTALL_FRAMEWORK_PATH=$(BINARY_DIRECTORY)/$(FRAMEWORK_NAME)

.PHONY: build
build:
	$(XCODEBUILD) build -project UnxipStatic.xcodeproj -target unxip

.PHONY: package
package: build
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP)  "$(PACKAGE_NAME).zip" "$(BINARY_NAME)"

.PHONY: install
install: build
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: spm-build
spm-build: spm-generate-xcodeproj
	$(XCODEBUILD) build -project Unxip.xcodeproj -target Unxip

.PHONY: spm-install
spm-install: spm-build
	$(RSYNC) "$(OUTPUT_FRAMEWORK_PATH)" "$(BINARY_DIRECTORY)"
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: spm-package
spm-package: spm-build
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP)  "$(PACKAGE_NAME).zip" "$(BINARY_NAME)" "$(FRAMEWORK_NAME)"

.PHONY: spm-generate-xcodeproj
spm-generate-xcodeproj:
	$(SWIFT) package generate-xcodeproj --xcconfig-overrides Configs.xcconfig

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(BINARY_NAME)" "$(BUILD_DIRECTORY)/$(FRAMEWORK_NAME)"

.PHONY: clean
clean:
	$(XCODEBUILD) clean -project UnxipStatic.xcodeproj
	$(RM) build

.PHONY: spm-clean
spm-clean:
	$(XCODEBUILD) clean -project Unxip.xcodeproj
	$(SWIFT) package clean
	$(RM) Unxip.xcodeproj

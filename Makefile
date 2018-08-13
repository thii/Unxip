PREFIX?=/usr/local

CD=cd
CP=$(shell whereis cp) -Rf
MKDIR=$(shell whereis mkdir) -p
RM=$(shell whereis rm) -rf
RSYNC=$(shell whereis rsync) --archive --delete
SWIFT=$(shell whereis swift)
XCODEBUILD=$(shell whereis xcodebuild)
ZIP=$(shell whereis zip) -r

TARGET_PLATFORM=x86_64-apple-macosx10.10

BINARY_DIRECTORY=$(PREFIX)/bin
FRAMEWORKS_DIRECTORY=$(PREFIX)/Frameworks
BINARY_NAME=unxip

BUILD_DIRECTORY=$(shell pwd)/.build/$(TARGET_PLATFORM)/release
OUTPUT_EXECUTABLE=$(BUILD_DIRECTORY)/$(BINARY_NAME)
INSTALL_EXECUTABLE_PATH=$(BINARY_DIRECTORY)/$(BINARY_NAME)

.PHONY: build
build:
	$(SWIFT) build -c release -Xswiftc -static-stdlib -Xswiftc -target -Xswiftc $(TARGET_PLATFORM) -Xlinker -F/System/Library/PrivateFrameworks -Xlinker -framework -Xlinker PackageKit

.PHONY: install
install: build
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: build
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(BINARY_NAME).zip" "$(BINARY_NAME)"

.PHONY: generate-xcodeproj
generate-xcodeproj:
	$(SWIFT) package generate-xcodeproj --xcconfig-overrides Configs.xcconfig

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(BINARY_NAME)" "$(BINARY_DIRECTORY)/$(FRAMEWORK_NAME)"

.PHONY: clean
clean:
	$(SWIFT) package clean
	$(RM) Unxip.xcodeproj

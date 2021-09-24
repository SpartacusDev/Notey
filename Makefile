PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
export TARGET := iphone:clang:latest:13.0
# TARGET = simulator:clang::13.0
export INSTALL_TARGET_PROCESSES = SpringBoard
export ARCHS = arm64 arm64e
# ARCHS = x86_64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Notey

BUNDLE_NAME = com.spartacus.notey

$(BUNDLE_NAME)_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
$(TWEAK_NAME)_FILES = $(wildcard *.x) $(wildcard Notey/*.m)
${TWEAK_NAME}_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit
${TWEAK_NAME}_EXTRA_FRAMEWORKS = Cephei CepheiUI

include $(THEOS)/makefiles/bundle.mk

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
SUBPROJECTS += CCModule
include $(THEOS_MAKE_PATH)/aggregate.mk

setup:: clean all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@codesign -f -s - /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@~/Documents/simject/bin/resim

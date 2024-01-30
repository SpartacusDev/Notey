ifeq ($(SIMULATOR), 1)
	export TARGET = simulator:clang::13.0
	ifeq ($(INTEL), 1)
		export ARCHS = x86_64
	else
		export ARCHS = arm64e
	endif
else
	export TARGET := iphone:clang:latest:13.0
	export ARCHS = arm64 arm64e
	export SYSROOT = $(THEOS)/sdks/iPhoneOS13.7.sdk
endif

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_DEVICE_IP=Spartacus-iPhone-2.local

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Notey

BUNDLE_NAME = com.spartacus.notey

$(BUNDLE_NAME)_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
$(TWEAK_NAME)_FILES = $(wildcard *.x) $(wildcard Notey/*.m)
${TWEAK_NAME}_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit

ifneq ($(ARCHS), x86_64)
	${TWEAK_NAME}_EXTRA_FRAMEWORKS = Cephei CepheiUI
endif

include $(THEOS)/makefiles/bundle.mk

include $(THEOS_MAKE_PATH)/tweak.mk

ifneq ($(SIMULATOR), 1)
	SUBPROJECTS += Prefs
	SUBPROJECTS += CCModule
	SUBPROJECTS += Activator
	include $(THEOS_MAKE_PATH)/aggregate.mk
endif

simulator:: clean all
	@rm -rf /opt/simject/$(TWEAK_NAME).dylib /opt/simject/$(BUNDLE_NAME).bundle /opt/simject/$(TWEAK_NAME)Prefs.bundle
	@mkdir -p /opt/simject/System/Library/PreferenceBundles

	@cp $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -r $(THEOS_OBJ_DIR)/$(BUNDLE_NAME).bundle /opt/simject/$(BUNDLE_NAME).bundle
	@cp -r $(THEOS_OBJ_DIR)/$(TWEAK_NAME)Prefs.bundle /opt/simject/System/Library/PreferenceBundles/$(TWEAK_NAME)Prefs.bundle
	@cp $(PWD)/$(TWEAK_NAME).plist /opt/simject

	@codesign -f -s - /opt/simject/$(TWEAK_NAME).dylib

	@resim

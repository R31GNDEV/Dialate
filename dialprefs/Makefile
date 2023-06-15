TARGET := iphone:clang:14.5:12.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = dialprefs

dialprefs_FILES = DIALRootListController.m
dialprefs_FRAMEWORKS = UIKit
dialprefs_PRIVATE_FRAMEWORKS = Preferences
dialprefs_INSTALL_PATH = /Library/PreferenceBundles
dialprefs_CFLAGS = -fobjc-arc
dialprefs_LIBRARIES = colorpicker
#dialprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis

include $(THEOS_MAKE_PATH)/bundle.mk

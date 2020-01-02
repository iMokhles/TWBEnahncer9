GO_EASY_ON_ME = 1

DEBUG = 0

#THEOS_DEVICE_IP = 192.168.0.10

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:9.0

export ADDITIONAL_LDFLAGS = -Wl,-segalign,4000

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = TWBEnhancerByPass
TWBEnhancerByPass_FILES = Tweak.xm
TWBEnhancerByPass_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts AssetsLibrary AdSupport MediaPlayer SystemConfiguration Security WebKit Photos LocalAuthentication
TWBEnhancerByPass_LIBRARIES = MobileGestalt substrate

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PTHCommon"

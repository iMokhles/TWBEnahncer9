GO_EASY_ON_ME = 1

DEBUG = 0

THEOS_DEVICE_IP = 192.168.0.10

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:9.0:9.0

export ADDITIONAL_LDFLAGS = -Wl,-segalign,4000

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = TWBEnhancer9
TWBEnhancer9_CFLAGS = -fobjc-arc
TWBEnhancer9_FILES = TWBEnhancer9.xm TWBEnhancer9Helper.m TWBEnhancer9MU.m $(wildcard vendors/*.m) $(wildcard STTwitter/*.m) $(wildcard vendors/AFNetwork/*.m) $(wildcard progress/*.m) $(wildcard progress/*.mm) TWBEnhancer9Font.m TWBEnhancer9MutableArray.m
TWBEnhancer9_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage ImageIO Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts AssetsLibrary AdSupport MediaPlayer SystemConfiguration Security WebKit Photos LocalAuthentication
TWBEnhancer9_PRIVATE_FRAMEWORKS = MarkupUI AnnotationKit
TWBEnhancer9_LIBRARIES = MobileGestalt substrate imodevtools2 imounbox

include $(THEOS_MAKE_PATH)/tweak.mk

before-package::

	$(ECHO_NOTHING)echo " Installing Library"$(ECHO_END)
	$(ECHO_NOTHING)sudo ldid -Sentitlements.xml  $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/TWBEnhancer9.dylib$(ECHO_END)

after-install::
	install.exec "killall -9 Tweetbot"
#SUBPROJECTS += twbenhancerbypass
include $(THEOS_MAKE_PATH)/aggregate.mk

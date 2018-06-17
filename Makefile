ifdef JAILED
MODULES = jailed
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BedtimeStory
BedtimeStory_FILES = Tweak.xm
BedtimeStory_CFLAGS = -fobjc-arc

# Jailed
DISPLAY_NAME = Storytel
BUNDLE_ID = se.christofferhenriksson.bedtimestory-jailed
BedtimeStory_IPA = com.storytel.iphone.ipa

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Storytel"

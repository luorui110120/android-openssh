BIG_LOCAL_PATH := $(call my-dir)

include $(BIG_LOCAL_PATH)/external/openssl/Android.mk
include $(BIG_LOCAL_PATH)/external/openssh/Android.mk
LOCAL_CFLAGS           += -fPIE
LOCAL_LDFLAGS          += -pie -fPIE
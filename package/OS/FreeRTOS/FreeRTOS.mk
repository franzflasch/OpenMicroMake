PKG_NAME := FreeRTOS
PKG_REVISION := 8.2.1
PKG_URI := http://sourceforge.net/projects/freertos/files/FreeRTOS/V$(PKG_REVISION)/FreeRTOSV$(PKG_REVISION).zip

PKG_SRC := FreeRTOSV8.2.1/FreeRTOS/Source/croutine.c
PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/event_groups.c
PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/list.c
PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/queue.c
PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/tasks.c
PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/timers.c

PKG_INC := FreeRTOSV8.2.1/FreeRTOS/Source/include
PKG_INC += .

ifeq ($(ARCH),arm)
	ifeq ($(MACH),stm32f1)
		PKG_INC += FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CM3/
		PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c
		PKG_SRC += FreeRTOSV8.2.1/FreeRTOS/Source/portable/MemMang/heap_1.c
	endif
	
	ifeq ($(UCLIB),st_library)
		PKG_DEFS = FREERTOS_USE_STLIB
	endif
	
	ifeq ($(UCLIB),libopencm3)
		PKG_DEFS = FREERTOS_USE_LIBOPENCM3
	endif
endif

include scripts/OMM_package_rules.mk

$(eval $(call Package/Setup,$(PKG_NAME)))

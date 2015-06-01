PKG_NAME := stm32f1lib
PKG_URI := http://www.st.com/st-web-ui/static/active/en/st_prod_software_internet/resource/technical/software/firmware/stsw-stm32054.zip

FILES = misc.c \
stm32f10x_adc.c \
stm32f10x_bkp.c \
stm32f10x_can.c \
stm32f10x_cec.c \
stm32f10x_crc.c \
stm32f10x_dac.c \
stm32f10x_dbgmcu.c \
stm32f10x_dma.c \
stm32f10x_exti.c \
stm32f10x_flash.c \
stm32f10x_fsmc.c \
stm32f10x_gpio.c \
stm32f10x_i2c.c \
stm32f10x_iwdg.c \
stm32f10x_pwr.c \
stm32f10x_rcc.c \
stm32f10x_rtc.c \
stm32f10x_sdio.c \
stm32f10x_spi.c \
stm32f10x_tim.c \
stm32f10x_usart.c \
stm32f10x_wwdg.c

# just take all c files in the source folder:
PKG_SRC := $(patsubst %,STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/STM32F10x_StdPeriph_Driver/src/%,$(FILES))
PKG_SRC += STM32F10x_StdPeriph_Lib_V3.5.0/Project/STM32F10x_StdPeriph_Template/system_stm32f10x.c

PKG_ASM_SRC = STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md_vl.s

PKG_INC := STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/STM32F10x_StdPeriph_Driver/inc/
PKG_INC += STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/
PKG_INC += STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/CoreSupport/
PKG_INC += STM32F10x_StdPeriph_Lib_V3.5.0/Project/STM32F10x_StdPeriph_Template/

# Used defines for this project
PKG_DEFS = USE_STDPERIPH_DRIVER

include scripts/OMM_package.mk

#define Package/$(PKG_NAME)/Info
#	$(info Package info:)
#	$(info $(PKG_NAME))
#	$(info $(PKG_SRC))
#endef

#define Package/Download/$(PKG_NAME)
#	$(info Hey I am overriding the default download method!:)
#endef

#define Package/Build/$(PKG_NAME)
#	$(info overiding default $(PKG_NAME) build)
#endef

$(eval $(call Package/Setup,$(PKG_NAME)))

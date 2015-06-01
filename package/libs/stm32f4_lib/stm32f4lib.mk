PKG_NAME := stm32f4lib
PKG_URI := http://www.st.com/st-web-ui/static/active/en/st_prod_software_internet/resource/technical/software/firmware/stm32f4_dsp_stdperiph_lib.zip

FILES := misc.c \
stm32f4xx_adc.c \
stm32f4xx_can.c \
stm32f4xx_cec.c \
stm32f4xx_crc.c \
stm32f4xx_cryp_aes.c \
stm32f4xx_cryp.c \
stm32f4xx_cryp_des.c \
stm32f4xx_cryp_tdes.c \
stm32f4xx_dac.c \
stm32f4xx_dbgmcu.c \
stm32f4xx_dcmi.c \
stm32f4xx_dma2d.c \
stm32f4xx_dma.c \
stm32f4xx_exti.c \
stm32f4xx_flash.c \
stm32f4xx_flash_ramfunc.c \
stm32f4xx_fmpi2c.c \
stm32f4xx_gpio.c \
stm32f4xx_hash.c \
stm32f4xx_hash_md5.c \
stm32f4xx_hash_sha1.c \
stm32f4xx_i2c.c \
stm32f4xx_iwdg.c \
stm32f4xx_ltdc.c \
stm32f4xx_pwr.c \
stm32f4xx_qspi.c \
stm32f4xx_rcc.c \
stm32f4xx_rng.c \
stm32f4xx_rtc.c \
stm32f4xx_sai.c \
stm32f4xx_sdio.c \
stm32f4xx_spdifrx.c \
stm32f4xx_spi.c \
stm32f4xx_syscfg.c \
stm32f4xx_tim.c \
stm32f4xx_usart.c \
stm32f4xx_wwdg.c

# just take all c files in the source folder:
PKG_SRC := $(patsubst %,STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Libraries/STM32F4xx_StdPeriph_Driver/src/%,$(FILES))
PKG_SRC += STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Project/STM32F4xx_StdPeriph_Templates/system_stm32f4xx.c

PKG_ASM_SRC := STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc_ride7/startup_stm32f40_41xxx.s

PKG_INC := STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Libraries/STM32F4xx_StdPeriph_Driver/inc/
PKG_INC += STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Libraries/CMSIS/Include/
PKG_INC += STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Libraries/CMSIS/Device/ST/STM32F4xx/Include/
PKG_INC += STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Project/STM32F4xx_StdPeriph_Templates/

# Used defines for this project
PKG_DEFS := USE_STDPERIPH_DRIVER


include scripts/OMM_package.mk

define Package/BeforeLink/$(PKG_NAME)
	$(eval LINKERSCRIPT := $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/STM32F4xx_DSP_StdPeriph_Lib_V1.5.1/Project/STM32F4xx_StdPeriph_Templates/TrueSTUDIO/STM32F40_41xxx/STM32F417IG_FLASH.ld)
	$(eval LD_FLAGS += -T$(LINKERSCRIPT))
endef

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

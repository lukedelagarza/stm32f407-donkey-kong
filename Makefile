########################################################################
# Project
########################################################################
TARGET   = firmware
BUILD    = build

########################################################################
# Toolchain
########################################################################
PREFIX   = arm-none-eabi-
CC       = $(PREFIX)gcc
AS       = $(PREFIX)gcc
LD       = $(PREFIX)gcc
OC       = $(PREFIX)objcopy
OD       = $(PREFIX)objdump
SZ       = $(PREFIX)size
NM       = $(PREFIX)nm
GDB      = $(PREFIX)gdb

########################################################################
# Linker script
########################################################################
LDSCRIPT = STM32F407VGTX_FLASH.ld

########################################################################
# Sources
########################################################################
C_SRCS   = src/main.c         \
           src/clock_verify.c \
           system_stm32f4xx.c \
           syscalls.c         \
           sysmem.c

AS_SRCS  = startup_stm32f407vgtx.s

OBJS     = $(addprefix $(BUILD)/, $(C_SRCS:.c=.o)) \
           $(addprefix $(BUILD)/, $(AS_SRCS:.s=.o))

DEPS     = $(OBJS:.o=.d)

########################################################################
# Flags
########################################################################
CPU_FLAGS  = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

INCLUDES   = -I cmsis -I inc

CFLAGS     = $(CPU_FLAGS)                           \
             $(INCLUDES)                            \
             -DSTM32F407xx                          \
             -Wall -Wextra                          \
             -Wshadow                               \
             -Wdouble-promotion                     \
             -Wformat=2                             \
             -Wundef                                \
             -fdata-sections                        \
             -ffunction-sections                    \
             -fno-common                            \
             -fsigned-char                          \
             -O0 -g3                                \
             -std=c11                               \
             -MMD -MP

CFLAGS    += $(EXTRA_CFLAGS)

ASFLAGS    = $(CPU_FLAGS)                           \
             -x assembler-with-cpp                  \
             -MMD -MP

LDFLAGS    = $(CPU_FLAGS)                           \
             -T$(LDSCRIPT)                          \
             -Wl,--gc-sections                      \
             -Wl,-Map=$(BUILD)/$(TARGET).map,--cref \
             -Wl,--print-memory-usage               \
             --specs=nano.specs                     \
             --specs=nosys.specs

########################################################################
# Flashing / debugging  (OpenOCD + ST-Link)
########################################################################
OPENOCD        = openocd
OPENOCD_IFACE  = interface/stlink.cfg
OPENOCD_TARGET = target/stm32f4x.cfg
OPENOCD_FLAGS  = -f $(OPENOCD_IFACE) -f $(OPENOCD_TARGET)

ST_FLASH       = st-flash
FLASH_ORIGIN   = 0x8000000

########################################################################
# Verbosity — run "make V=1" to echo full commands
########################################################################
ifeq ($(V),1)
  Q =
else
  Q = @
  MAKEFLAGS += --no-print-directory
endif

########################################################################
# Default target
########################################################################
.PHONY: all clean flash flash-stlink debug size hex list dump help

all: $(BUILD)/$(TARGET).elf $(BUILD)/$(TARGET).bin $(BUILD)/$(TARGET).hex
	@echo ""
	$(Q)$(SZ) --format=berkeley $(BUILD)/$(TARGET).elf

########################################################################
# Link
########################################################################
$(BUILD)/$(TARGET).elf: $(OBJS)
	@echo "  LD    $@"
	$(Q)$(LD) $(LDFLAGS) $^ -o $@

########################################################################
# Binary / Intel HEX / interleaved listing
########################################################################
$(BUILD)/$(TARGET).bin: $(BUILD)/$(TARGET).elf
	@echo "  BIN   $@"
	$(Q)$(OC) -O binary $< $@

$(BUILD)/$(TARGET).hex: $(BUILD)/$(TARGET).elf
	@echo "  HEX   $@"
	$(Q)$(OC) -O ihex $< $@

$(BUILD)/$(TARGET).lst: $(BUILD)/$(TARGET).elf
	@echo "  LST   $@"
	$(Q)$(OD) -S $< > $@

########################################################################
# Compile C
########################################################################
$(BUILD)/%.o: %.c
	@echo "  CC    $<"
	@mkdir -p $(@D)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

########################################################################
# Assemble
########################################################################
$(BUILD)/%.o: %.s
	@echo "  AS    $<"
	@mkdir -p $(@D)
	$(Q)$(AS) $(ASFLAGS) -c $< -o $@

########################################################################
# Auto-generated header dependencies
########################################################################
-include $(DEPS)

########################################################################
# Utility targets
########################################################################
size: $(BUILD)/$(TARGET).elf
	$(Q)$(SZ) --format=berkeley $<

hex: $(BUILD)/$(TARGET).hex

list: $(BUILD)/$(TARGET).lst

dump: $(BUILD)/$(TARGET).elf
	$(Q)$(OD) -D $< | less

flash: $(BUILD)/$(TARGET).elf
	$(OPENOCD) $(OPENOCD_FLAGS) \
	  -c "program $< verify reset exit"

flash-stlink: $(BUILD)/$(TARGET).bin
	$(ST_FLASH) write $< $(FLASH_ORIGIN)

debug: $(BUILD)/$(TARGET).elf
	$(OPENOCD) $(OPENOCD_FLAGS) & \
	sleep 1 && \
	$(GDB) -ex "target remote :3333" \
	       -ex "monitor reset halt"   \
	       -ex "load"                 \
	       $<

clean:
	rm -rf $(BUILD)

help:
	@echo "Usage: make [target] [V=1]"
	@echo ""
	@echo "Build targets:"
	@echo "  all    build ELF, BIN, and HEX (default)"
	@echo "  hex    produce Intel HEX only"
	@echo "  list   generate interleaved source/asm listing (.lst)"
	@echo "  size   print section sizes (text/data/bss)"
	@echo "  dump   disassemble ELF and pipe to less"
	@echo "  clean  remove $(BUILD)/ directory"
	@echo ""
	@echo "Hardware targets:"
	@echo "  flash         program ELF via OpenOCD"
	@echo "  flash-stlink  program BIN via st-flash (0x8000000)"
	@echo "  debug         start OpenOCD GDB server and attach GDB"
	@echo ""
	@echo "Options:"
	@echo "  V=1                          verbose — echo full compiler/linker commands"
	@echo "  EXTRA_CFLAGS=-DCLOCK_VERIFY  enable clock output on PA8/PB8/PC9"

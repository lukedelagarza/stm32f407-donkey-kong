# Reference Documentation

Datasheets and reference manuals for the STM32F407VG (Cortex-M4F) target used in this project.

**The PDFs in this directory are not committed.** They are gitignored (`docs/*.pdf`) to keep the
repository small and to avoid redistributing copyrighted vendor material. This file is the
manifest — download the documents listed below from their official sources.

Naming convention: `vendor-topic-docid.pdf` (lowercase, hyphen-separated).

## ARM — Cortex-M4 core architecture

| File | Doc ID | Contents | Source |
|------|--------|----------|--------|
| `arm-armv7m-architecture-reference-manual-ddi0403e.pdf` | DDI0403E | Authoritative ARMv7-M architecture spec: instruction encodings, exception model, system-level programmer's model. | [Arm Developer](https://developer.arm.com/documentation/ddi0403/latest/) |
| `arm-cortex-m4-generic-user-guide-dui0553.pdf` | DUI0553 | Device-programmer's view: core registers, NVIC / SysTick / SCB / MPU, instruction set summary. | [Arm Developer](https://developer.arm.com/documentation/dui0553/latest/) |
| `arm-cortex-m4-technical-reference-manual-ddi0439.pdf` | DDI0439 | Processor implementation: pipeline, FPU, bus interfaces, debug / trace units. | [Arm Developer](https://developer.arm.com/documentation/ddi0439/latest/) |
| `arm-thumb2-instruction-set-quick-ref.pdf` | QRC0001L | ARM and Thumb-2 instruction set quick reference card. | [Arm Developer](https://developer.arm.com/documentation/qrc0001/latest/) |

## STMicroelectronics — STM32F407 silicon & board

| File | Doc ID | Contents | Source |
|------|--------|----------|--------|
| `st-stm32f4-reference-manual-rm0090.pdf` | RM0090 | Register-level description of every peripheral — the primary bare-metal reference. | [st.com](https://www.st.com/en/product/stm32f407vg) |
| `st-stm32-cortex-m4-programming-manual-pm0214.pdf` | PM0214 | ST's programming manual for STM32 Cortex-M4 parts: core, NVIC, MPU, FPU, instruction set. | [st.com](https://www.st.com/en/product/stm32f407vg) |
| `st-stm32f405-407-datasheet-ds8626.pdf` | DS8626 | Electrical characteristics, pinout, peripheral overview, packaging. | [st.com](https://www.st.com/en/product/stm32f407vg) |
| `st-stm32f407-discovery-user-manual-um1472.pdf` | UM1472 | STM32F4DISCOVERY board: schematics, LEDs / buttons, ST-LINK, headers. | [st.com](https://www.st.com/en/evaluation-tools/stm32f4discovery) |

## Which document for which task

- **Register programming (day-to-day):** RM0090
- **Core, NVIC, FPU, instruction details:** PM0214 (ST) or DUI0553 (ARM)
- **Pinout, electrical, package decisions:** DS8626
- **Board wiring (LEDs, buttons, ST-LINK):** UM1472
- **Deep architecture / instruction encodings:** DDI0403E

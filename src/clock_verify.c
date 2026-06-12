/**
 * @file    clock_verify.c
 * @author  Luke De la Garza <luke.delagarza03@utexas.edu>
 * @brief   Testing functions for clock accuracy.
 */

#include "stm32f4xx.h"
#include "clock_verify.h"

#ifdef CLOCK_VERIFY

#define CLOCK_ASSERT(cond) do { if (!(cond)) { __disable_irq(); while (1) { } } } while (0)

/**
 * @brief   Enables GPIOA clock to output the HSE on MCO1.
 *
 *          PA8:
 *          Mode: Alternate function
 *          Output type: Push-pull
 *          Output speed: Medium speed
 *          Pull-up/pull-down: None
 */
static void mco1_pin_init(void) {
    SET_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOAEN);
    (void)READ_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOAEN);
    MODIFY_REG(GPIOA->MODER,   GPIO_MODER_MODER8,    (0b10 << GPIO_MODER_MODER8_Pos));
    MODIFY_REG(GPIOA->OSPEEDR, GPIO_OSPEEDR_OSPEED8, (0b01 << GPIO_OSPEEDR_OSPEED8_Pos));
}

/**
 * @brief   Enables GPIOC clock to output the PLL on MCO2.
 *
 *          PC9:
 *          Mode: Alternate function
 *          Output type: Push-pull
 *          Output speed: High speed
 *          Pull-up/pull-down: None
 */
static void mco2_pin_init(void) {
    SET_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOCEN);
    (void)READ_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOCEN);
    MODIFY_REG(GPIOC->MODER,   GPIO_MODER_MODER9,    (0b10 << GPIO_MODER_MODER9_Pos));
    MODIFY_REG(GPIOC->OSPEEDR, GPIO_OSPEEDR_OSPEED9, (0b10 << GPIO_OSPEEDR_OSPEED9_Pos));
}

/**
 * @brief   Enable GPIOB clock to output a 100 kHz square wave
 *          using TIM10 channel 1.
 *
 *          PB8:
 *          Mode: Alternate function
 *          Output type: Push-pull
 *          Output speed: Low speed
 *          Pull-up/pull-down: None
 *          Alternate function: TIM10_CH1
 *
 *          TIM10:
 *          Capture/compare mode: Output toggle
 */
static void tim10_probe_init(void) {
    SET_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOBEN);
    (void)READ_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIOBEN);
    MODIFY_REG(GPIOB->MODER,   GPIO_MODER_MODER8,    GPIO_MODER_MODER8_1);
    MODIFY_REG(GPIOB->OSPEEDR, GPIO_OSPEEDR_OSPEED8, (0U << GPIO_OSPEEDR_OSPEED8_Pos));
    MODIFY_REG(GPIOB->AFR[1],  GPIO_AFRH_AFSEL8,     (3U << GPIO_AFRH_AFSEL8_Pos));

    SET_BIT(RCC->APB2ENR, RCC_APB2ENR_TIM10EN);
    (void)READ_BIT(RCC->APB2ENR, RCC_APB2ENR_TIM10EN);
    MODIFY_REG(TIM10->ARR,   TIM_ARR_ARR,    (839U  << TIM_ARR_ARR_Pos));
    MODIFY_REG(TIM10->CCMR1, TIM_CCMR1_OC1M, (0b011 << TIM_CCMR1_OC1M_Pos));
    SET_BIT(TIM10->CCER, TIM_CCER_CC1E);
    SET_BIT(TIM10->CR1,  TIM_CR1_CEN);
}

void clock_verify_init(void) {
    CLOCK_ASSERT(READ_BIT(RCC->CFGR, RCC_CFGR_SWS) == RCC_CFGR_SWS_PLL);
    CLOCK_ASSERT(SystemCoreClock == 168000000U);

    mco1_pin_init();
    mco2_pin_init();
    tim10_probe_init();
}

#endif

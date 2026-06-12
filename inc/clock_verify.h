/**
 * @file    clock_verify.h
 * @author  Luke De la Garza <luke.delagarza03@utexas.edu>
 * @brief   Provide clock_verify_init() function for
 *          oscilloscope/logic analyzer testing.
 */

#ifndef CLOCK_VERIFY_H
#define CLOCK_VERIFY_H

#ifdef CLOCK_VERIFY

/**
 * @brief   Initialize pins PA8, PB8, and PC9 for clock frequency
 *          testing using an oscilloscope/logic analyzer.
 *
 *          | Pins | Peripheral | Clock Source |         Expected Frequency         |
 *          | PA8  |   MCO1     |     HSE      |              ~8 MHz                |
 *          | PB8  | TIM10_CH1  |     PLL      |   CK_INT / ((ARR+1)*2) = ~100 kHz  |
 *          | PC9  |   MCO2     |     PLL      |        PLL / 5 = ~33.6 MHz         |
 */
void clock_verify_init(void);

#endif  /* CLOCK_VERIFY   */
#endif  /* CLOCK_VERIFY_H */

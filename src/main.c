#include "stm32f4xx.h"
#include "clock_verify.h"

int main(void) {
    SystemCoreClockUpdate();

#ifdef CLOCK_VERIFY
    clock_verify_init();
#endif

    while (1) {}
    return 0;
}

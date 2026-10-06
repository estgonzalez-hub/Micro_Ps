// main.c
//This file prints the revs/sec by calling encoder and velocity files. 
// Esteban Gonzalez
// estgonzalez@g.hmc.edu
// 10/5/26

#include "main.h"
#include "encoder.h"
#include "velocity.h"

// Set to 1 to print edge count and 0 for velocity
#define COUNT_TEST_MODE  0
#define COUNT_PERIOD_US  250000u

// printf
int _write(int file, char *ptr, int len) {
    for (int i = 0; i < len; i++) {
        ITM_SendChar(*ptr++);
    }
    return len;
}

static void printVelocity(float rev_per_s) {
    int32_t milli = (int32_t)(rev_per_s * MILLI_PER_UNIT);
    const char *direction = (milli > 0) ? "CCW " : (milli < 0) ? "CW" : "---";
    if (milli < 0) milli = -milli;

    printf("%s %ld.%03ld rev/s\n", direction,
           (long)(milli / MILLI_PER_UNIT), (long)(milli % MILLI_PER_UNIT));
}

static void printCount(void) {
    encoder_snapshot_t snap;
    encoderSnapshot(&snap);
    printf("count = %ld\n", (long)snap.count);
}

int main(void) {
    initTimestampTIM(TS_TIM);   
    encoderInit();
    velocityInit();

    uint32_t last_print = readTimestampMicros(TS_TIM);

#if COUNT_TEST_MODE
    const uint32_t period = COUNT_PERIOD_US;
#else
    const uint32_t period = PRINT_PERIOD_US;
#endif

    while (1) {
        if ((readTimestampMicros(TS_TIM) - last_print) >= period) {
            last_print += period;
#if COUNT_TEST_MODE
            printCount();
#else
            printVelocity(velocityUpdate());
#endif
        }
    }
}
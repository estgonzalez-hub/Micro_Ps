//This file contains the calculations to find the count and revs/sec of the motor.
//Call encoder in order to get the values to do the math
//Esteban Gonzalez
//estgonzalez@g.hmc.edu
//10/5/2026


#include "velocity.h"
#include "encoder.h"

#define COUNTS_PER_REV  450.0f     
#define TIMEOUT_US      1500000u   // if no edges for this period, speed is 0
#define MICROS_PER_SEC  1000000.0f

static int32_t  prev_count = 0;
static uint32_t prev_edge_time = 0;
static float    speed_rev_per_s = 0.0f;

void velocityInit(void) {
    encoder_snapshot_t snap;
    encoderSnapshot(&snap);
    prev_count = snap.count;
    prev_edge_time = snap.last_edge_time;
    speed_rev_per_s = 0.0f;
}

float velocityUpdate(void) {
    encoder_snapshot_t snap;
    encoderSnapshot(&snap);

    int32_t  delta_count = snap.count - prev_count;
    uint32_t delta_time  = snap.last_edge_time - prev_edge_time;  

    if (delta_count != 0 && delta_time != 0)  {
        float seconds = (float)delta_time / MICROS_PER_SEC;
        speed_rev_per_s = ((float)delta_count / seconds) / COUNTS_PER_REV;
        prev_count = snap.count;
        prev_edge_time = snap.last_edge_time;
    } else if ((snap.now - snap.last_edge_time) > TIMEOUT_US) {
        speed_rev_per_s = 0.0f;
        prev_count = snap.count;
        prev_edge_time = snap.last_edge_time;
    }

    return speed_rev_per_s;
}
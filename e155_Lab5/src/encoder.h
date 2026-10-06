#ifndef ENCODER_H
#define ENCODER_H

#include <stdint.h>

// Hardware assumptions (PA8 = A, PA9 = B, both 5V-tolerant, EXTI lines 8 and 9).
// Changing pins means changing encoder.c (EXTICR fields and the IRQ handler name).
#define ENCODER_A_PIN  PA8
#define ENCODER_B_PIN  PA9

typedef struct {
    int32_t  count;          // signed edge count (x4 decoding)
    uint32_t last_edge_time; // timestamp of most recent edge, in microseconds
    uint32_t now;            // timestamp when this snapshot was taken
} encoder_snapshot_t;

void encoderInit(void);
void encoderSnapshot(encoder_snapshot_t *snapshot);

#endif
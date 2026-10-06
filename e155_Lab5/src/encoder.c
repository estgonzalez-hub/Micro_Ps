//File that takes in the encoder inputs A and B, and finds the time of a pulse rise and fall,
//and whether to add to the count.
//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/5/2026


#include "encoder.h"
#include "STM32L432KC.h"

#define ENCODER_TIM       TIM2
#define ENC_A_LINE        8
#define ENC_B_LINE        9
#define ENC_LINE_MASK     ((1 << ENC_A_LINE) | (1 << ENC_B_LINE))
#define ENC_EXTICR_INDEX  2                 // lines 8-11 are in EXTICR3
#define ENC_EXTICR_A_SHIFT 0                // line 8 field
#define ENC_EXTICR_B_SHIFT 4                // line 9 field
#define EXTICR_FIELD_MASK 0xFu
#define STATE_TABLE_SIZE  16
#define STATE_BITS        2


static volatile int32_t  enc_count = 0;
static volatile uint32_t enc_last_edge_time = 0;
static volatile uint8_t  enc_prev_state = 0;

// Entries of 0 are "no change" or an invalid jump
//Coloumns and rows are ordered 00 01 10  11
static const int8_t quad_table[STATE_TABLE_SIZE] = {
     0, +1, -1,  0,
    -1,  0,  0, +1,
    +1,  0,  0, -1,
     0, -1, +1,  0
};

static uint8_t readEncoderState(void) {
    uint32_t idr = GPIOA->IDR;
    uint8_t a = (idr >> ENC_A_LINE) & 1;
    uint8_t b = (idr >> ENC_B_LINE) & 1;
    return (uint8_t)((a << 1) | b);
}

static void configureExti(void) {
    RCC->APB2ENR |= (1 << 0);
    SYSCFG->EXTICR[ENC_EXTICR_INDEX] &= ~((EXTICR_FIELD_MASK << ENC_EXTICR_A_SHIFT) |(EXTICR_FIELD_MASK << ENC_EXTICR_B_SHIFT)); // port A, set to 0000

    EXTI->IMR1  |= ENC_LINE_MASK;   // unmask
    EXTI->RTSR1 |= ENC_LINE_MASK;   // rising edge
    EXTI->FTSR1 |= ENC_LINE_MASK;   // falling edge
}

void encoderInit(void) {
    gpioEnable(GPIO_PORT_A);
    pinMode(ENCODER_A_PIN, GPIO_INPUT);
    pinMode(ENCODER_B_PIN, GPIO_INPUT);

    configureExti();

    // Set state before enabling the interrupt so the first edge decodes correctly
    enc_prev_state = readEncoderState();
    enc_last_edge_time = readTimestampMicros(ENCODER_TIM);

    NVIC_EnableIRQ(EXTI9_5_IRQn);
    __enable_irq(); //enable global interrupts
}

void encoderSnapshot(encoder_snapshot_t *snapshot) {
    NVIC_DisableIRQ(EXTI9_5_IRQn);                       // disable interrupts to read the current values
    snapshot->count          = enc_count;
    snapshot->last_edge_time = enc_last_edge_time;
    snapshot->now            = readTimestampMicros(ENCODER_TIM);
    NVIC_EnableIRQ(EXTI9_5_IRQn);
}


void EXTI9_5_IRQHandler(void) {
    EXTI->PR1 = ENC_LINE_MASK;             // write 1 to clear

    uint8_t curr = readEncoderState();
    enc_count += quad_table[(enc_prev_state << STATE_BITS) | curr];
    enc_last_edge_time = readTimestampMicros(ENCODER_TIM);
    enc_prev_state = curr;
}
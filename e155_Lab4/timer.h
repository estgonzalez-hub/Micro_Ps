// STM32L432KC_TIM16.h
// Header for TIM16 functions

#ifndef STM32L4_TIM16_H
#define STM32L4_TIM16_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

// Base address
#define TIM16_BASE (0x40014400UL)


#define TIM16_CR1_CEN   0    // counter enable
#define TIM16_CR1_ARPE  7    // auto-reload preload enable
#define TIM16_SR_UIF    0    // update interrupt flag
#define TIM16_EGR_UG    0    // update generation
#define TIM16_BDTR_MOE  15   // main output enable 
#define TIM16_CCMR1_OC1PE 3 // output compare 1 preload enable 
#define TIM16_CCMR1_OC1M 4 // OC1M[2:0] at bits 6:4 
#define TIM16_CCER_CC1E 0 // channel 1 output enable 


///////////////////////////////////////////////////////////////////////////////
// Register struct
///////////////////////////////////////////////////////////////////////////////

typedef struct {
    volatile uint32_t CR1;       // Offset 0x00
    volatile uint32_t CR2;       // Offset 0x04
    uint32_t          RESERVED0; // Offset 0x08
    volatile uint32_t DIER;      // Offset 0x0C
    volatile uint32_t SR;        // Offset 0x10
    volatile uint32_t EGR;       // Offset 0x14
    volatile uint32_t CCMR1;     // Offset 0x18
    uint32_t          RESERVED1; // Offset 0x1C
    volatile uint32_t CCER;      // Offset 0x20
    volatile uint32_t CNT;       // Offset 0x24
    volatile uint32_t PSC;       // Offset 0x28
    volatile uint32_t ARR;       // Offset 0x2C
    volatile uint32_t RCR;       // Offset 0x30
    volatile uint32_t CCR1;      // Offset 0x34
    uint32_t          RESERVED2[3]; // Offsets 0x38, 0x3C, 0x40
    volatile uint32_t BDTR;      // Offset 0x44
    volatile uint32_t DCR;       // Offset 0x48
    volatile uint32_t DMAR;      // Offset 0x4C
    volatile uint32_t OR1;       // Offset 0x50
    uint32_t          RESERVED3[3]; // Offsets 0x54, 0x58, 0x5C
    volatile uint32_t OR2;       // Offset 0x60
} TIM16_TypeDef;

#define TIM16 ((TIM16_TypeDef *) TIM16_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void initTIM16(void);


#endif
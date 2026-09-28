#ifndef STM32L4_TIMER_H
#define STM32L4_TIMER_H

#include <stdint.h>


#define TIM15_BASE (0x40014000UL)



#define TIM15_CR1_CEN 0 // counter enable 
#define TIM15_CR1_ARPE 7 // auto-reload preload enable 
#define TIM15_SR_UIF 0 // update interrupt flag 
#define TIM15_EGR_UG 0 // update generation 
#define TIM15_CCMR1_OC1PE 3 // output compare 1 preload enable 
#define TIM15_CCMR1_OC1M 4 // OC1M[2:0] at bits 6:4 
#define TIM15_CCER_CC1E 0 // channel 1 output enable 
#define TIM15_BDTR_MOE 15 // main output enable



typedef struct {
    volatile uint32_t CR1;          // 0x00
    volatile uint32_t CR2;          // 0x04
    volatile uint32_t SMCR;         // 0x08
    volatile uint32_t DIER;         // 0x0C
    volatile uint32_t SR;           // 0x10
    volatile uint32_t EGR;          // 0x14
    volatile uint32_t CCMR1;        // 0x18
    uint32_t          RESERVED0;    // 0x1C
    volatile uint32_t CCER;         // 0x20
    volatile uint32_t CNT;          // 0x24
    volatile uint32_t PSC;          // 0x28
    volatile uint32_t ARR;          // 0x2C
    volatile uint32_t RCR;          // 0x30
    volatile uint32_t CCR1;         // 0x34
    volatile uint32_t CCR2;         // 0x38
    uint32_t          RESERVED1[2]; // 0x3C, 0x40
    volatile uint32_t BDTR;         // 0x44
    volatile uint32_t DCR;          // 0x48
    volatile uint32_t DMAR;         // 0x4C
    volatile uint32_t OR1;          // 0x50
    uint32_t          RESERVED2[3]; // 0x54, 0x58, 0x5C
    volatile uint32_t OR2;          // 0x60
} TIM15_TypeDef;

#define TIM15 ((TIM15_TypeDef *) TIM15_BASE)

void initTIM15(void);
void setFreq(uint32_t freq_hz);
void delay_millis(TIM15_TypeDef *TIMx, uint32_t ms);

#endif
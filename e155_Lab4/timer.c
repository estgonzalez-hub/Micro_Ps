// STM32L432KC_TIMER.c
// Source code for TIM16 pitch generation (PWM on PA6)

#include "timer.h"
#include "STM32L432KC_RCC.h"

#define TIMER_CLK_HZ 80000000UL   // system clock after configureClock()

void initTIM16(void) {
    // Enable clocks: GPIOA (AHB2ENR bit 0) and TIM16 (APB2ENR bit 17)
    RCC->AHB2ENR |= (1 << 0);
    RCC->APB2ENR |= (1 << 17);

    // PA6 -> alternate function 14 (TIM16_CH1). Verify in the datasheet AF table.
    volatile uint32_t *GPIOA_MODER = (volatile uint32_t *)(0x48000000UL + 0x00);
    volatile uint32_t *GPIOA_AFRL  = (volatile uint32_t *)(0x48000000UL + 0x20);
    *GPIOA_MODER &= ~(0b11 << (6 * 2));
    *GPIOA_MODER |=  (0b10 << (6 * 2));      // 10 = alternate function
    *GPIOA_AFRL  &= ~(0xF << (6 * 4));
    *GPIOA_AFRL  |=  (14  << (6 * 4));       // AF14

    // PWM mode 1 on channel 1 (OC1M = 110), with preload enabled
    TIM16->CCMR1 &= ~(0b111 << TIM16_CCMR1_OC1M);
    TIM16->CCMR1 |=  (0b110 << TIM16_CCMR1_OC1M);
    TIM16->CCMR1 |=  (1 << TIM16_CCMR1_OC1PE);

    TIM16->CCER |= (1 << TIM16_CCER_CC1E);     // enable channel 1 output
    TIM16->BDTR |= (1 << TIM16_BDTR_MOE);      // main output enable
    TIM16->CR1  |= (1 << TIM16_CR1_ARPE);      // buffer ARR
    TIM16->CR1  |= (1 << TIM16_CR1_CEN);       // start counter
}

void setFreq(uint32_t freq_hz) {
    if (freq_hz == 0) {
        TIM16->CCR1 = 0;                     // CCR = 0 keeps the pin low (rest)
        TIM16->EGR |= (1 << TIM16_EGR_UG);
        return;
    }

    uint32_t total = TIMER_CLK_HZ / freq_hz;
    uint32_t psc   = total / 65536;
    uint32_t arr   = (total / (psc + 1)) - 1;

    TIM16->PSC  = psc;
    TIM16->ARR  = arr;
    TIM16->CCR1 = (arr + 1) / 2;             // 50% duty = square wave
    TIM16->EGR |= (1 << TIM16_EGR_UG);         // load new values immediately
}


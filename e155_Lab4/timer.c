// STM32L432KC_TIMER.c
// Source code for TIM16 pitch generation (PWM on PA6)

#include "timer.h"
#include "STM32L432KC_RCC.h"

#define TIMER_CLK_HZ 80000000UL   // system clock after configureClock()

void initTIM16(void) {
    // Enable clocks: GPIOA and TIM16
    RCC->AHB2ENR |= (1 << 0);
    RCC->APB2ENR |= (1 << 17);

    volatile uint32_t *GPIOA_MODER = (volatile uint32_t *)(0x48000000UL + 0x00);
    volatile uint32_t *GPIOA_AFRL  = (volatile uint32_t *)(0x48000000UL + 0x20);
    *GPIOA_MODER &= ~(0b11 << (12));
    *GPIOA_MODER |=  (0b10 << (12));      
    *GPIOA_AFRL  &= ~(0xF << (24));
    *GPIOA_AFRL  |=  (14  << (24));       

    // PWM mode 1 on channel 1 sets all the necessary settings
    TIM16->CCMR1 &= ~(0b111 << TIM16_CCMR1_OC1M);
    TIM16->CCMR1 |=  (0b110 << TIM16_CCMR1_OC1M);
    TIM16->CCMR1 |=  (1 << TIM16_CCMR1_OC1PE);

    TIM16->CCER |= (1 << TIM16_CCER_CC1E);     
    TIM16->BDTR |= (1 << TIM16_BDTR_MOE);      
    TIM16->CR1  |= (1 << TIM16_CR1_ARPE);      
    TIM16->CR1  |= (1 << TIM16_CR1_CEN);       
}

void setFreq(uint32_t freq_hz) {
    if (freq_hz == 0) {
        TIM16->CCR1 = 0;                     // CCR = 0 keeps the pin low (rest)
        TIM16->EGR |= (1 << TIM16_EGR_UG);
        return;
    }

    uint32_t total = TIMER_CLK_HZ / freq_hz; // 80 MHz divided by the frequency, Time Period
    uint32_t psc   = total / 65536; //65536 is the max value the arr register can go, 16 bits wide
    uint32_t arr   = (total / (psc + 1)) - 1; // solve for the arr register. It is necessary to +1 then -1

    TIM16->PSC  = psc; // sets how fast the counter increments by
    TIM16->ARR  = arr; // when it reaches this value it resets down to zero 
    TIM16->CCR1 = (arr + 1) / 2;             // 50% duty = square wave, makes it symmetrical 
    TIM16->EGR |= (1 << TIM16_EGR_UG);         // load new values immediately to avoid delay
}

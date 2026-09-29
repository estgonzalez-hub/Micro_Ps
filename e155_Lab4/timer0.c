// Source code for TIM15 millisecond delay

#include "timer0.h"
#include "STM32L432KC_RCC.h"

void initTIM15(void) {
    RCC->APB2ENR |= (1 << 16);                 // enable TIM15

    // 80 MHz / (79+1) = 1 MHz tick; 1000 counts = 1 ms
    TIM15->PSC = 79;
    TIM15->ARR = 999;

    TIM15->EGR |= (1 << TIM15_EGR_UG);         // load PSC/ARR now
    TIM15->SR  &= ~(1 << TIM15_SR_UIF);        // clear flag set by UG
    TIM15->CR1 |= (1 << TIM15_CR1_CEN);        // start counter
}

void delay_millis(TIM15_TypeDef *TIMx, uint32_t ms) { //TIMx bc it can be used by TIM15 or TIM16
    TIMx->SR &= ~(1 << TIM15_SR_UIF);          // clear any flag first
    while (ms-- > 0) {
        while (!(TIMx->SR & (1 << TIM15_SR_UIF)));
        TIMx->SR &= ~(1 << TIM15_SR_UIF);
    }
}


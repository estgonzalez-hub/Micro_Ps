// STM32L432KC_TIM.c
// Free-running microsecond timestamp timer

#include "STM32L432KC_TIM.h"
#include "STM32L432KC_RCC.h"

#define TIM_ONE_MHZ     1000000u
#define TIM_32BIT_MAX   0xFFFFFFFFu
#define TIM_CEN         (1u << 0)   // CR1: counter enable
#define TIM_UG          (1u << 0)   // EGR: update generation

void initTimestampTIM(TIM_TypeDef * TIMx){
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;             // TIM2 clock (this function assumes TIM2)
  TIMx->PSC  = (SystemCoreClock / TIM_ONE_MHZ) - 1; // 1 us per tick
  TIMx->ARR  = TIM_32BIT_MAX;                       // free-running, 32-bit
  TIMx->EGR |= TIM_UG;                              // load prescaler
  TIMx->CR1 |= TIM_CEN;                             // start counting
}

uint32_t readTimestampMicros(TIM_TypeDef * TIMx){
  return TIMx->CNT;
}
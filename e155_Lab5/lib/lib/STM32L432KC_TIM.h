#ifndef STM32L4_TIM_H
#define STM32L4_TIM_H

#include <stdint.h>
#include <stm32l432xx.h>
#include "STM32L432KC_GPIO.h"

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void initTimestampTIM(TIM_TypeDef * TIMx);
uint32_t readTimestampMicros(TIM_TypeDef * TIMx);

#endif
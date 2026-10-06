// main.h
// Josh Brake
// jbrake@hmc.edu
// 10/31/22

#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include <stm32l432xx.h>

///////////////////////////////////////////////////////////////////////////////
// Custom defines
///////////////////////////////////////////////////////////////////////////////

#define ENC_A_PIN PA8
#define ENC_B_PIN PA9
#define TIM    TIM2

#define TS_TIM           TIM2
#define PRINT_PERIOD_US  1000000u   // 1 Hz display update
#define MILLI_PER_UNIT   1000

#endif

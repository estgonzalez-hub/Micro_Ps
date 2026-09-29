// STM32L432KC_RCC.c
// Source code for RCC functions

#include "STM32L432KC_RCC.h"

void configurePLL() {
    // Set clock to 80 MHz
    // Output freq = (src_clk) * (N/M) / R
    // (4 MHz) * (N/M) / R = 80 MHz
    // M: XX, N: XX, R: XX
    // Use MSI as PLLSRC

    // TODO: Turn off PLL
    RCC->CR &= ~(1 << 24);
    // TODO: Wait till PLL is unlocked (e.g., off)
    while ((RCC->CR >> 25) & 0b1);
    
    // Load configuration
    // TODO: Set PLL SRC to MSI
    RCC->PLLCFGR &= ~(0b11 << 0);   // clear PLLSRC bits [1:0]
    RCC->PLLCFGR |= (0b01 << 0);   // 01 = MSI selected as PLL source

    // TODO: Set PLLN
    RCC->PLLCFGR &= ~(0b111 << 4); // clear PLLM bits [6:4]
    RCC->PLLCFGR |= (0b000 << 4); // M = 1 (000 = divide by 1)


    // TODO: Set PLLM
    RCC->PLLCFGR &= ~(0b1111111 << 8); // clear PLLN bits [14:8]
    RCC->PLLCFGR |= (40 << 8);         // N = 40
    

    // TODO: Set PLLR
    RCC->PLLCFGR &= ~(0b11 << 25); // clear PLLR bits [26:25]
    RCC->PLLCFGR |= (0b00 << 25); // 00 = divide by 2

    // TODO: Enable PLLR output
    RCC->PLLCFGR |= (1 << 24); // PLLREN = bit 24

    // TODO: Enable PLL
    RCC->CR |= (1 << 24); // PLLON = bit 24, set to enable
  
    // TODO: Wait until PLL is locked
    while (!((RCC->CR >> 25) & 0b1)); // PLLRDY = bit 25, wait until set (locked)
    
}

void configureClock(){
    // Configure and turn on PLL
    configurePLL();

    // Select PLL as clock source
    RCC->CFGR |= (0b11 << 0);
    while(!((RCC->CFGR >> 2) & 0b11));
}
 //main.c
 //Code to play music from STM32 MCU
 //Esteban Gonzalez
 //estgonzalez@g.hmc.edu
 //9/27/26

// Plays Für Elise: TIM16 generates the pitch (PWM on PA6), TIM15 times the notes

#include "STM32L432KC_RCC.h"
#include "STM32L432KC_FLASH.h"
#include "timer.h"
#include "timer0.h"

// Set to 1 for a steady 440 Hz tone (scope check), 0 to play the song
#define TEST_TONE 0


// Pitch in Hz, duration in ms
const int notes[][2] = {
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{416, 125},
{494, 125},
{523, 250},
{  0, 125},
{330, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{523, 125},
{494, 125},
{440, 250},
{  0, 125},
{494, 125},
{523, 125},
{587, 125},
{659, 375},
{392, 125},
{699, 125},
{659, 125},
{587, 375},
{349, 125},
{659, 125},
{587, 125},
{523, 375},
{330, 125},
{587, 125},
{523, 125},
{494, 250},
{  0, 125},
{330, 125},
{659, 125},
{  0, 250},
{659, 125},
{1319, 125},
{  0, 250},
{623, 125},
{659, 125},
{  0, 250},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{416, 125},
{494, 125},
{523, 250},
{  0, 125},
{330, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{523, 125},
{494, 125},
{440, 500},
{  0, 0}};

int main(void) {
    configureFlash();   // wait states first, before going to 80 MHz
    configureClock();   // switch the system clock to 80 MHz
    initTIM15();        // 1 ms delay timer
    initTIM16();        // pitch PWM on PA6 (header pin A5)

#if TEST_TONE
    setFreq(440);       // steady A4 for the scope
    while (1);
#else
    // Play until the {0, 0} end marker
    for (int i = 0; notes[i][1] != 0; i++) {
        setFreq(notes[i][0]);                        // 0 Hz = rest
        delay_millis(TIM15, notes[i][1] - 10);       // hold the note
        setFreq(0);                                  // short gap so repeated notes stay distinct
        delay_millis(TIM15, 10);
    }

    setFreq(0);         // silence at the end
    while (1);
#endif
}
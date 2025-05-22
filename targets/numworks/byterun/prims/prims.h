/* C-interface between:                             */
/*   -> prims/bindings.c                            */
/*   -> simul/sf-regs.c | numworks/numworkslib.c    */

#include <stdint.h>
#include <stdbool.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifndef PRIMS_H_NUMWORKS
#define PRIMS_H_NUMWORKS

void delay_usec(uint64_t us);

void display_draw_string(const char * text, uint16_t x, uint16_t y);
void display_draw_string_small(const char * text, uint16_t x, uint16_t y);
void display_draw_string_full(const char * text, uint16_t x, uint16_t y, bool large_font, uint16_t text_color, uint16_t background_color);

void display_push_rect_uniform(uint16_t color, uint16_t x, uint16_t y, uint16_t width, uint16_t height);
void display_push_allscreen_uniform(uint16_t color);

void backlight_set_brightness(uint8_t brightness);

#endif

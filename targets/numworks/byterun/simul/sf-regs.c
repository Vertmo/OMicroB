#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void delay_usec(uint64_t us) {
  micro_sleep(us);
}

/******************************************************************************/

void display_draw_string(const char *text, uint16_t x, uint16_t y) {
  printf("%s", text);
}

void display_draw_string_small(const char *text, uint16_t x, uint16_t y) {
  printf("%s", text);
}

void display_draw_string_full(const char *text, uint16_t x, uint16_t y, bool large_font, uint16_t text_color, uint16_t bg_color) {
  printf("%s", text);
}

void display_push_rect_uniform(uint16_t color, uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
  // TODO
}

void display_push_allscreen_uniform(uint16_t color) {
  // TODO
}

/******************************************************************************/

uint8_t brightness = 0;

uint8_t eadk_backlight_brightness() {
  return brightness;
}

void eadk_backlight_set_brightness(uint8_t bright) {
  brightness = bright;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

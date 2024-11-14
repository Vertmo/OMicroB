/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __OCAML__
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
// #include <caml/fiber.h>
#endif

#if defined(__OCAML__) || defined(__PC__) || defined(__NUMWORKS__)

#include "prims.h"
#include "storage.h"


/************************************************************************/
/*********************** caml_numworks functions ************************/
/************************************************************************/

value caml_delay_usec(value us) {
  delay_usec(Val_int(us));
  return Val_unit;
}

/******************************************************************************/
/******************************* EADK library *********************************/
/******************************************************************************/

// TODO: write here some useful functions written as bindings for the eadh.k library

/***********/
/* Display */
/***********/

value caml_display_draw_string(value text, value x, value y) {
  #ifdef __OCAML__
  display_draw_string(String_val(text), Int_val(x), Int_val(y));
  #else
  int n = caml_string_length(text); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(text, i);
  buf[n] = '\0';
  display_draw_string(buf, Int_val(x), Int_val(y));
  #endif
  return Val_unit;
}

value caml_display_draw_string_small(value text, value x, value y) {
  #ifdef __OCAML__
  display_draw_string_small(String_val(text), Int_val(x), Int_val(y));
  #else
  int n = caml_string_length(text); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(text, i);
  buf[n] = '\0';
  display_draw_string_small(buf, Int_val(x), Int_val(y));
  #endif
  return Val_unit;
}

/* value caml_display_draw_string_full(value text, value x, value y, value large_font, value text_color, value background_color) { */
/*   #ifdef __OCAML__ */
/*   display_draw_string_full(String_val(text), Int_val(x), Int_val(y), Bool_val(large_font), Int_val(text_color), Int_val(background_color)); */
/*   #else */
/*   int n = caml_string_length(text); int i; */
/*   char buf[n+1]; */
/*   for(i = 0; i < n; i++) buf[i] = String_field(text, i); */
/*   buf[n] = '\0'; */
/*   display_draw_string_full(buf, Int_val(x), Int_val(y), Bool_val(large_font), Int_val(text_color), Int_val(background_color)); */
/*   #endif */
/*   return Val_unit; */
/* } */

value caml_display_push_rect_uniform(value background_color, value x, value y, value width, value height) {
  display_push_rect_uniform(Int_val(background_color), Int_val(x), Int_val(y), Int_val(width), Int_val(height));
  return Val_unit;
}

value caml_display_push_allscreen_uniform(value background_color) {
  display_push_allscreen_uniform(Int_val(background_color));
  return Val_unit;
}

/*************/
/* Backlight */
/*************/

value caml_backlight_set_brightness(value brightness) {
  eadk_backlight_set_brightness((uint8_t) Val_int(brightness));
  return Val_unit;
}
value caml_backlight_brightness(value unit) {
  return Val_int(eadk_backlight_brightness());
}

/***********/
/* Battery */
/***********/

// value caml_battery_is_charging(value unit) {
//   return Val_bool(battery_is_charging());
// }

// value caml_battery_level(value unit) {
//   return Val_int(battery_level());
// }

// value caml_battery_voltage(value unit) {
//   double bv = battery_voltage();
//   value result;
//   * (double*) result = bv;
//   // Store_double_val(result, bv);
//   return result;
//   // return Val_double(battery_voltage());  // FIXME: Val_double is unavailable?
// }

/********/
/* Misc */
/********/

value caml_random(value unit) {
  return Val_int(random ());
}

// value caml_usb_is_plugged(value unit) {
//   return Val_bool(usb_is_plugged ());
// }

/******************************************************************************/
/***************************** Storage.c library ******************************/
/******************************************************************************/


static const uint16_t color_black = 0x0;
static const uint16_t color_white = 0xFFFF;
static const uint16_t color_red   = 0xF800;
static const uint16_t color_green = 0x07E0;
static const uint16_t color_blue  = 0x001F;

// Read the content of the 'ocaml.py' file from the Calculator local storage, and returns it as a OCaml string, to be used from OCaml code.
value caml_read_any_file(value v) {
  // We read filename from the OCaml value v, for example 'ocaml.py'
  #ifdef __OCAML__
  const char * filename = String_val(v);
  #else
  int n = caml_string_length(v); int i;
  char filename[n+1];
  for(i = 0; i < n; i++) filename[i] = String_field(v, i);
  filename[n] = '\0';
  #endif

  size_t file_len = 0;
  const char * content = extapp_fileRead(filename, &file_len);

  if (content == NULL) {
    display_push_allscreen_uniform(color_red);
    display_draw_string_full("Local file not found:", 0, 0, true, color_black, color_red);
    display_draw_string_full(filename, 0, 18, true, color_black, color_red);
    delay(5000);

    #ifdef __OCAML__
    return (value)caml_copy_string("");
    #else
    const char * fake_content = "";
    return (value)copy_bytes(fake_content);
    #endif
  }

  // The file is found, so we return his content
  #ifdef __OCAML__
  return (value)caml_copy_string(content);
  #else
  return (value)copy_bytes(content);
  #endif
}

#endif

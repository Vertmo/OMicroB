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

  // The file is found, so we return his content (content + 1 is for the autoimport status), converted to a value
  // Create a new OCaml string, using caml_copy_string(char* s), see https://ocaml.org/manual/5.2/intfc.html#ss:c-block-allocation
  #ifdef __OCAML__
  return (value)caml_copy_string(content + 1);
  #else
  return (value)copy_bytes(content + 1);
  #endif
}


/**********************************************************************/
/************************** caml_lex_engine ***************************/
/**********************************************************************/

// Manual implementation of caml_lex_engine from ocaml/runtime/lexing.c
// See https://github.com/ocaml/ocaml/blob/fd41e1ab55fa11cbb98df2dab96e43b5540db31c/runtime/lexing.c#L65
#ifndef __OCAML__
struct lexer_buffer {
  value refill_buff;
  value lex_buffer;
  value lex_buffer_len;
  value lex_abs_pos;
  value lex_start_pos;
  value lex_curr_pos;
  value lex_last_pos;
  value lex_last_action;
  value lex_eof_reached;
  value lex_mem;
  value lex_start_p;
  value lex_curr_p;
};

struct lexing_table {
  value lex_base;
  value lex_backtrk;
  value lex_default;
  value lex_trans;
  value lex_check;
  value lex_base_code;
  value lex_backtrk_code;
  value lex_default_code;
  value lex_trans_code;
  value lex_check_code;
  value lex_code;
};

#if defined(ARCH_BIG_ENDIAN) || SIZEOF_SHORT != 2
#define Short(tbl,n) \
  (*((unsigned char *)((tbl) + (n) * 2)) + \
          (*((signed char *)((tbl) + (n) * 2 + 1)) << 8))
#define UShort(tbl,n) \
  (*((unsigned char *)((tbl) + (n) * 2)) + \
          (*((unsigned char *)((tbl) + (n) * 2 + 1)) << 8))
#else
#define Short(tbl,n) (((short *)(tbl))[(n)])
#define UShort(tbl,n) (((unsigned short *)(tbl))[(n)])
#endif

#define Byte_u(x, i) (((unsigned char *) (x)) [i]) /* Also an l-value. */

value caml_lex_engine(value vtbl, value start_state, value vlexbuf)
{
  struct lexing_table * tbl = (struct lexing_table *) vtbl;
  struct lexer_buffer * lexbuf = (struct lexer_buffer *) vlexbuf;
  int state, base, backtrk, c;

  state = Int_val(start_state);
  if (state >= 0) {
    /* First entry */
    lexbuf->lex_last_pos = lexbuf->lex_start_pos = lexbuf->lex_curr_pos;
    lexbuf->lex_last_action = Val_int(-1);
  } else {
    /* Reentry after refill */
    state = -state - 1;
  }
  while(1) {
    /* Lookup base address or action number for current state */
    base = Short(tbl->lex_base, state);
    if (base < 0) return Val_int(-base-1);
    /* See if it's a backtrack point */
    backtrk = Short(tbl->lex_backtrk, state);
    if (backtrk >= 0) {
      lexbuf->lex_last_pos = lexbuf->lex_curr_pos;
      lexbuf->lex_last_action = Val_int(backtrk);
    }
    /* See if we need a refill */
    if (lexbuf->lex_curr_pos >= lexbuf->lex_buffer_len){
      if (lexbuf->lex_eof_reached == Val_bool (0)){
        return Val_int(-state - 1);
      }else{
        c = 256;
      }
    }else{
      /* Read next input char */
      c = Byte_u(lexbuf->lex_buffer, Int_val(lexbuf->lex_curr_pos));
      lexbuf->lex_curr_pos += 2;
    }
    /* Determine next state */
    if (Short(tbl->lex_check, base + c) == state)
      state = Short(tbl->lex_trans, base + c);
    else
      state = Short(tbl->lex_default, state);
    /* If no transition on this char, return to last backtrack point */
    if (state < 0) {
      lexbuf->lex_curr_pos = lexbuf->lex_last_pos;
      if (lexbuf->lex_last_action == Val_int(-1)) {
        // caml_failwith("lexing: empty token");
        printf("lexing error: empty token");
      } else {
        return lexbuf->lex_last_action;
      }
    }else{
      /* Erase the EOF condition only if the EOF pseudo-character was
         consumed by the automaton (i.e. there was no backtrack above)
       */
      if (c == 256) lexbuf->lex_eof_reached = Val_bool (0);
    }
  }
}
#endif


#endif

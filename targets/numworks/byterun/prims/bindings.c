/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __OCAML__
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/custom.h>
#include <caml/signals.h>
// #include <caml/fiber.h>
#endif

#if defined(__OCAML__) || defined(__PC__) || defined(__NUMWORKS__)

#include "prims.h"
#include "eadk.h"
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

/***********/
/* Display */
/***********/

value caml_display_draw_string_full(value text, value x, value y, value large_font, value colors) {
  value text_color = Field(colors, 0);
  value background_color = Field(colors, 1);
  #ifdef __OCAML__
  display_draw_string_full(String_val(text), Int_val(x), Int_val(y), Bool_val(large_font), Int_val(text_color), Int_val(background_color));
  #else
  int n = caml_string_length(text); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(text, i);
  buf[n] = '\0';
  display_draw_string_full(buf, Int_val(x), Int_val(y), Bool_val(large_font), Int_val(text_color), Int_val(background_color));
  #endif
  return Val_unit;
}

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

/********/
/* Keys */
/********/

value caml_numworks_keyboard_scan(value unit) {
  #ifdef __NUMWORKS__
  return value_of_int64(eadk_keyboard_scan());
  #endif
  return Val_unit;
}

// Conversion from OCaml enum to eadk key numbers
eadk_key_t keys[] = {
  eadk_key_left,
  eadk_key_up,
  eadk_key_down,
  eadk_key_right,
  eadk_key_ok,
  eadk_key_back,
  eadk_key_home,
  eadk_key_on_off,
  eadk_key_shift,
  eadk_key_alpha,
  eadk_key_xnt,
  eadk_key_var,
  eadk_key_toolbox,
  eadk_key_backspace,
  eadk_key_exp,
  eadk_key_ln,
  eadk_key_log,
  eadk_key_imaginary,
  eadk_key_comma,
  eadk_key_power,
  eadk_key_sine,
  eadk_key_cosine,
  eadk_key_tangent,
  eadk_key_pi,
  eadk_key_sqrt,
  eadk_key_square,
  eadk_key_seven,
  eadk_key_eight,
  eadk_key_nine,
  eadk_key_left_parenthesis,
  eadk_key_right_parenthesis,
  eadk_key_four,
  eadk_key_five,
  eadk_key_six,
  eadk_key_multiplication,
  eadk_key_division,
  eadk_key_one,
  eadk_key_two,
  eadk_key_three,
  eadk_key_plus,
  eadk_key_minus,
  eadk_key_zero,
  eadk_key_dot,
  eadk_key_ee,
  eadk_key_ans,
  eadk_key_exe
};

value caml_numworks_keyboard_key_down(value state, value key) {
  #ifdef __NUMWORKS__
  eadk_keyboard_state_t st = Int64_val(state);
  return Val_int(eadk_keyboard_key_down(st, keys[Int_val(key)]));
  #else
  return Val_int(0); // TODO
  #endif
}

/******************************************************************************/
/***************************** Storage.c library ******************************/
/******************************************************************************/


static const uint16_t color_black = 0x0;
static const uint16_t color_white = 0xFFFF;
static const uint16_t color_red   = 0xF800;
static const uint16_t color_green = 0x07E0;
static const uint16_t color_blue  = 0x001F;

typedef struct {
  char *curptr;
  char *endptr;
} storage_ptr;

value numworks_ml_open_in(value v) {
  // Read filename from v
  #ifdef __OCAML__
  const char * filename = String_val(v);
  #else
  int n = caml_string_length(v); int i;
  char filename[n+1];
  for(i = 0; i < n; i++) filename[i] = String_field(v, i);
  filename[n] = '\0';
  #endif

  value ret;

  #if defined(__OCAML__)
  FILE *f = fopen(filename, "r");
  if(!f) caml_raise_not_found();
  ret = caml_alloc(1, Custom_tag);
  Field(ret, 0) = (long)f;
  #elif defined(__PC__)
  FILE *f = fopen(filename, "r");
  if(!f) caml_raise(OCAML_Not_found);
  ret = value_of_int64((long)f);
  #else
  unsigned int len;
  char *ofs = extapp_fileRead(filename, &len);
  len = len - strlen(filename) - 5; // size + filename + \0 + autoimport status
  if(!ofs) caml_raise(OCAML_Not_found);

  storage_ptr *ptr = malloc(sizeof(storage_ptr));
  ptr->curptr = ofs;
  ptr->endptr = ofs + len;
  ret = value_of_int64((long)ptr); // TODO what size ?
  #endif

  return ret;
}

value numworks_ml_close_in(value fd) {
  #if defined(__OCAML__)
  FILE *f = (FILE*)Field(fd, 0);
  fclose(f);
  #elif defined(__PC__)
  /* FILE *f = (FILE*)Int64_val(fd); */
  /* fclose(f); */ // TODO ?
  #else
  storage_ptr *ptr = (storage_ptr*)Int64_val(fd);
  free(ptr);
  #endif
  return Val_unit;
}

value numworks_ml_input(value fd, value dest, value vofs, value vlen) {
  int len = Int_val(vlen);
  int ofs = Int_val(vofs);
  int nbread;
  #if defined(__OCAML__)
  FILE *f = (FILE*)Field(fd, 0);
  nbread = fread(String_val(dest)+ofs, 1, len, f);
  #elif defined(__PC__)
  FILE *f = (FILE*)Int64_val(fd);
  char buf[len];
  nbread = fread(buf, 1, len, f);
  for(int i = 0; i < nbread; i++) String_field(dest, ofs+i) = buf[i];
  #else
  storage_ptr *ptr = (storage_ptr*)Int64_val(fd);
  for(nbread = 0; nbread < len; nbread++) {
    if(ptr->curptr >= ptr->endptr) break;
    Ram_string_field(dest, ofs+nbread) = *ptr->curptr;
    ptr->curptr++;
  }
  #endif
  return Val_int(nbread);
}

value numworks_ml_input_char(value fd) {
  char buf[1];
  #if defined(__OCAML__)
  FILE *f = (FILE*)Field(fd, 0);
  int nb = fread(buf, 1, 1, f);
  if(!nb) caml_raise_end_of_file();
  #elif defined(__PC__)
  FILE *f = (FILE*)Int64_val(fd);
  int nb = fread(buf, 1, 1, f);
  if(!nb) caml_raise(OCAML_End_of_file);
  #else
  storage_ptr *ptr = (storage_ptr*)Int64_val(fd);
  if(ptr->curptr >= ptr->endptr) caml_raise(OCAML_End_of_file);
  buf[0] = *(ptr->curptr);
  ptr->curptr++;
  #endif
  return Val_int(buf[0]);
}

/******************************************************************************/
/******************************** Events **************************************/
/******************************************************************************/

// eadk event -> OCaml key
int key_of_event(eadk_event_t ev) {
  if(ev < 6) return (int)ev; // left-back
  if(ev >= 12 && ev < 35) return (int)(ev-4); // shift-right par
  if(ev >= 36 && ev < 41) return (int)(ev-5); // four-division
  if(ev >= 42 && ev < 47) return (int)(ev-6); // one-minus
  if(ev >= 48 && ev < 53) return (int)(ev-7); // zero-exe
  if(ev >= 54 && ev < 58) return (int)(ev-54); // shift left-right
  if(ev >= 67 && ev < 84) return (int)(ev-58); // shift alpha-greater
  // lower-case chars
  if(ev >= 122 && ev < 143) return (int)(ev-112);
  if(ev >= 144 && ev < 149) return (int)(ev-113);
  if(ev >= 150 && ev < 155) return (int)(ev-114);
  if(ev >= 156 && ev < 158) return (int)(ev-115);
  // upper-case chars
  if(ev >= 180 && ev < 197) return (int)(ev-166);
  if(ev >= 198 && ev < 203) return (int)(ev-167);
  if(ev >= 204 && ev < 208) return (int)(ev-168);
  return -1; // Undefined
}

value caml_numworks_get_event(value unit) {
  #ifdef __NUMWORKS__
  int32_t timeout = 1000;
  int key;
  do {
    eadk_event_t ev = eadk_event_get(&timeout);
    key = key_of_event(ev);
  } while (key == -1);
  return Val_int(key);
  #endif
  // TODO simul
  return Val_int(0);
}


/*****************************************************************/

// TODO: include the io.c library?

/* #include <unistd.h> */

/* #ifndef IO_BUFFER_SIZE */
/* #define IO_BUFFER_SIZE 65536 */
/* #endif */

/* #if defined(_WIN32) */
/* typedef __int64 file_offset; */
/* #elif defined(HAS_OFF_T) */
/* #include <sys/types.h> */
/* typedef off_t file_offset; */
/* #else */
/* typedef long file_offset; */
/* #endif */

/* struct channel { */
/*   int fd;                       /\* Unix file descriptor *\/ */
/*   file_offset offset;           /\* Absolute position of fd in the file *\/ */
/*   char * end;                   /\* Physical end of the buffer *\/ */
/*   char * curr;                  /\* Current position in the buffer *\/ */
/*   char * max;                   /\* Logical end of the buffer (for input) *\/ */
/*   void * mutex;                 /\* Placeholder for mutex (for systhreads) *\/ */
/*   struct channel * next, * prev;/\* Double chaining of channels (flush_all) *\/ */
/*   int revealed;                 /\* For Cash only *\/ */
/*   int old_revealed;             /\* For Cash only *\/ */
/*   int refcount;                 /\* For flush_all and for Cash *\/ */
/*   int flags;                    /\* Bitfield *\/ */
/*   char buff[IO_BUFFER_SIZE];    /\* The buffer itself *\/ */
/*   char * name;                  /\* Optional name (to report fd leaks) *\/ */
/* }; */

/* #ifndef SEEK_SET */
/* #define SEEK_SET 0 */
/* #define SEEK_CUR 1 */
/* #define SEEK_END 2 */
/* #endif */

/* List of opened channels */
/* struct channel * numworks_caml_all_opened_channels = NULL; */

/* Basic functions over type struct channel *.
   These functions can be called directly from C.
   No locking is performed. */

/* Functions shared between input and output */
/* value caml_alloc_dummy(value ml_size); */

/* struct channel * numworks_caml_open_descriptor_in(int fd) */
/* { */
/*   struct channel * channel; */

/*   // channel = (struct channel *) caml_stat_alloc(sizeof(struct channel)); // FIXME: commenting this will fail when ran... */
/*   channel = (struct channel *) caml_alloc_dummy(sizeof(struct channel)); */
/*   channel->fd = fd; */
/*   // caml_enter_blocking_section(); // XXX durty hack? */
/*   channel->offset = lseek(fd, 0, SEEK_CUR); */
/*   // caml_leave_blocking_section(); // XXX durty hack? */
/*   channel->curr = channel->max = channel->buff; */
/*   channel->end = channel->buff + IO_BUFFER_SIZE; */
/*   channel->mutex = NULL; */
/*   channel->revealed = 0; */
/*   channel->old_revealed = 0; */
/*   channel->refcount = 0; */
/*   channel->flags = 0; */
/*   channel->next = numworks_caml_all_opened_channels; */
/*   channel->prev = NULL; */
/*   channel->name = NULL; */
/*   if (numworks_caml_all_opened_channels != NULL) */
/*     numworks_caml_all_opened_channels->prev = channel; */
/*   numworks_caml_all_opened_channels = channel; */
/*   return channel; */
/* }; */

/* enum { */
/*   CHANNEL_FLAG_FROM_SOCKET = 1,  /\* For Windows *\/ */
/* #if defined(NATIVE_CODE) && defined(WITH_SPACETIME) */
/*   CHANNEL_FLAG_BLOCKING_WRITE = 2, /\* Don't release master lock when writing *\/ */
/* #endif */
/*   CHANNEL_FLAG_MANAGED_BY_GC = 4,  /\* Free and close using GC finalization *\/ */
/* }; */

/* struct channel * numworks_caml_open_descriptor_out(int fd) */
/* { */
/*   struct channel * channel; */

/*   channel = numworks_caml_open_descriptor_in(fd); */
/*   channel->max = NULL; */
/*   return channel; */
/* } */

/* Extract a struct channel * from the heap object representing it */

/* #define LField(x, i) (((value *)(x)) [i])           /\* Also an l-value. *\/ */
/* #define Data_custom_val(v) ((void *) &LField((v), 1)) */
/* #define Channel(v) (*((struct channel **) (Data_custom_val(v)))) */

// static struct custom_operations channel_operations = {
//   "_chan",
//   caml_finalize_channel,
//   compare_channel,
//   hash_channel,
//   custom_serialize_default,
//   custom_deserialize_default,
//   custom_compare_ext_default
// };


/* value numworks_caml_alloc_channel(struct channel *chan) */
/* { */
/*   value res; */
/*   chan->refcount++;             /\* prevent finalization during next alloc *\/ */
/*   // res = caml_alloc_custom(&channel_operations, sizeof(struct channel *), 1, 1000);  // FIXME: */
/*   res = caml_alloc_dummy(sizeof(struct channel *));  // FIXME: */
/*   Channel(res) = chan; */
/*   return res; */
/* } */

/* value numworks_caml_ml_open_descriptor_in(value fd) { */
/*   /\* struct channel * chan = numworks_caml_open_descriptor_in(Int_val(fd)); *\/ */
/*   /\* chan->flags |= CHANNEL_FLAG_MANAGED_BY_GC; *\/ */
/*   /\* return numworks_caml_alloc_channel(chan); *\/ */
/*   return Val_unit; // FIXME */
/* } */

/* value numworks_caml_ml_open_descriptor_out(value fd) { */
/*   /\* struct channel * chan = numworks_caml_open_descriptor_out(Int_val(fd)); *\/ */
/*   /\* chan->flags |= CHANNEL_FLAG_MANAGED_BY_GC; *\/ */
/*   /\* return numworks_caml_alloc_channel(chan); *\/ */
/*   return Val_unit; // FIXME */
/* } */

/*****************************************************************/


#endif

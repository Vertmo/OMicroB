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


/*****************************************************************/

// TODO: include the io.c library?

#include <unistd.h>

#ifndef IO_BUFFER_SIZE
#define IO_BUFFER_SIZE 65536
#endif

#if defined(_WIN32)
typedef __int64 file_offset;
#elif defined(HAS_OFF_T)
#include <sys/types.h>
typedef off_t file_offset;
#else
typedef long file_offset;
#endif

struct channel {
  int fd;                       /* Unix file descriptor */
  file_offset offset;           /* Absolute position of fd in the file */
  char * end;                   /* Physical end of the buffer */
  char * curr;                  /* Current position in the buffer */
  char * max;                   /* Logical end of the buffer (for input) */
  void * mutex;                 /* Placeholder for mutex (for systhreads) */
  struct channel * next, * prev;/* Double chaining of channels (flush_all) */
  int revealed;                 /* For Cash only */
  int old_revealed;             /* For Cash only */
  int refcount;                 /* For flush_all and for Cash */
  int flags;                    /* Bitfield */
  char buff[IO_BUFFER_SIZE];    /* The buffer itself */
  char * name;                  /* Optional name (to report fd leaks) */
};

#ifndef SEEK_SET
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif

/* List of opened channels */
struct channel * numworks_caml_all_opened_channels = NULL;

/* Basic functions over type struct channel *.
   These functions can be called directly from C.
   No locking is performed. */

/* Functions shared between input and output */
value caml_alloc_dummy(value ml_size);

struct channel * numworks_caml_open_descriptor_in(int fd)
{
  struct channel * channel;

  // channel = (struct channel *) caml_stat_alloc(sizeof(struct channel)); // FIXME: commenting this will fail when ran...
  channel = (struct channel *) caml_alloc_dummy(sizeof(struct channel));
  channel->fd = fd;
  // caml_enter_blocking_section(); // XXX durty hack?
  channel->offset = lseek(fd, 0, SEEK_CUR);
  // caml_leave_blocking_section(); // XXX durty hack?
  channel->curr = channel->max = channel->buff;
  channel->end = channel->buff + IO_BUFFER_SIZE;
  channel->mutex = NULL;
  channel->revealed = 0;
  channel->old_revealed = 0;
  channel->refcount = 0;
  channel->flags = 0;
  channel->next = numworks_caml_all_opened_channels;
  channel->prev = NULL;
  channel->name = NULL;
  if (numworks_caml_all_opened_channels != NULL)
    numworks_caml_all_opened_channels->prev = channel;
  numworks_caml_all_opened_channels = channel;
  return channel;
};

enum {
  CHANNEL_FLAG_FROM_SOCKET = 1,  /* For Windows */
#if defined(NATIVE_CODE) && defined(WITH_SPACETIME)
  CHANNEL_FLAG_BLOCKING_WRITE = 2, /* Don't release master lock when writing */
#endif
  CHANNEL_FLAG_MANAGED_BY_GC = 4,  /* Free and close using GC finalization */
};

struct channel * numworks_caml_open_descriptor_out(int fd)
{
  struct channel * channel;

  channel = numworks_caml_open_descriptor_in(fd);
  channel->max = NULL;
  return channel;
}

/* Extract a struct channel * from the heap object representing it */

#define Field(x, i) (((value *)(x)) [i])           /* Also an l-value. */
#define Data_custom_val(v) ((void *) &Field((v), 1))
#define Channel(v) (*((struct channel **) (Data_custom_val(v))))

// static struct custom_operations channel_operations = {
//   "_chan",
//   caml_finalize_channel,
//   compare_channel,
//   hash_channel,
//   custom_serialize_default,
//   custom_deserialize_default,
//   custom_compare_ext_default
// };


value numworks_caml_alloc_channel(struct channel *chan)
{
  value res;
  chan->refcount++;             /* prevent finalization during next alloc */
  // res = caml_alloc_custom(&channel_operations, sizeof(struct channel *), 1, 1000);  // FIXME:
  res = caml_alloc_dummy(sizeof(struct channel *));  // FIXME:
  Channel(res) = chan;
  return res;
}

value numworks_caml_ml_open_descriptor_in(value fd) {
  /* struct channel * chan = numworks_caml_open_descriptor_in(Int_val(fd)); */
  /* chan->flags |= CHANNEL_FLAG_MANAGED_BY_GC; */
  /* return numworks_caml_alloc_channel(chan); */
  return Val_unit; // FIXME
}

value numworks_caml_ml_open_descriptor_out(value fd) {
  /* struct channel * chan = numworks_caml_open_descriptor_out(Int_val(fd)); */
  /* chan->flags |= CHANNEL_FLAG_MANAGED_BY_GC; */
  /* return numworks_caml_alloc_channel(chan); */
  return Val_unit; // FIXME
}

/*****************************************************************/


#endif

#include <eadk.h>
#include "arch-specific.h"

/******************************************************************************/
/**************************** App Config **************************************/
/******************************************************************************/

#ifndef EADK_APP_NAME
#define EADK_APP_NAME "OMicroB OCaml"
#endif

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = EADK_APP_NAME;

/******************************************************************************/
/************************ General operations **********************************/
/******************************************************************************/

void device_init(const char **argv) {
    /* timer_init(); */
    /* serial_init(); */
}

void device_finish() {
  /* delay_loop(10); */
}

/******************************************************************************/
/********************************** Debug *************************************/
/******************************************************************************/

void debug_blink_error(void) {
  while(1) {
    printf("Error!");
  }
}

void debug_blink_uncatched_exception(void) {
  while(1) {
    printf("Uncatched exception!");
  }
}

void debug_blink_message(int n) {
  printf("Error: %d\n", n);
}

void debug_blink_pause(void) {
  printf("pause");
  eadk_timing_msleep(1000);
}

void uncaught_exception(value v) {
  debug_blink_error();
}

/******************************************************************************/

#define TRACE_INSTRUCTION(instr_name)

void print_value(value v) {
  printf("0x%08" PRIflag "lx / ", v);
  if (OCAML_VIRTUAL_ARCH != 16 && Maybe_code_pointer(v)) {
    printf("@%" PRIflag "ld (code pointer)", Codeptr_val(v));
  } else if (Is_int(v)) {
    printf("(int = %" PRIflag "ld / float = %" PRIflag "f)", Int_val(v), (double)Float_val(v));
  } else if (Is_block_in_dynamic_heap(v)) {
    printf("@%p (block in dynamic heap)", Ram_block_val(v));
  } else if (Is_block_in_static_heap(v)) {
    printf("@%p (block in static heap)", Ram_block_val(v));
  } else if (Is_block_in_flash_heap(v)) {
    printf("@%p (block in flash heap)", Flash_block_val(v));
  } else if (v == 0) {
    printf("NULL");
  } else if (Float_val(v) >= -1e6 && Float_val(v) <= 1e6) {
    printf("(maybe %f)", (double)Float_val(v));
  } else {
    printf("(?)");
  }
  printf("\n");
  fflush(stdout);
}

static void print_table(const char *name, const value *table, uint32_t table_wosize) {
  const value *ptr;
  int i;

  printf("%s (starts at %p, ends at %p, size = %" PRIu32 " words) : \n", name, table, table + table_wosize, table_wosize);

  for (ptr = table, i = 0; ptr < table + table_wosize; ptr ++, i ++) {
#ifdef OCAML_GC_STOP_AND_COPY
    if (ptr == ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE / 2) {
      printf("======================================================\n");
    }
#endif
    printf("%d  @%p : ", i, ptr);
    print_value(*ptr);
  }
  printf("\n\n\n");
}
void print_dynamic_heap(void) {
  print_table("DYNAMIC HEAP", ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE, OCAML_DYNAMIC_HEAP_WOSIZE);
}

void print_static_heap(void) {
  print_table("STATIC HEAP", ocaml_ram_heap, OCAML_STATIC_HEAP_WOSIZE);
}

void print_flash_heap(void) {}
void print_ram_global_data(void) {}
void print_flash_global_data(void) {}
void print_stack(void) {}

/******************************************************************************/
/**************************** Memory operations *******************************/
/******************************************************************************/

static inline char do_read_byte(const opcode_t *ocaml_bytecode, int pc) {
  return ocaml_bytecode[pc];
}

static inline uint8_t do_read_byte_from_flash(const void *flash_ptr, int ind) {
  return ((uint8_t *)flash_ptr)[ind];
}

static inline void *do_get_primitive(void *const primitives[], uint8_t prim_ind) {
  return primitives[prim_ind];
}

static inline value do_read_flash_data_1B(const value flash_global_data[], uint8_t glob_ind) {
  return flash_global_data[glob_ind];
}

static inline value do_read_flash_data_2B(const value flash_global_data[], uint8_t glob_ind) {
  return flash_global_data[glob_ind];
}

/******************************************************************************/
/********************************* Format *************************************/
/******************************************************************************/

void format_int64(char *buf, int bufsize, value v) {
  snprintf(buf, bufsize, "%lld", Int64_val(v));
}

#if OCAML_VIRTUAL_ARCH == 64
void format_long(char *buf, int bufsize, value v) {
  snprintf(buf, bufsize, "%ld", Int_val(v));
}
#endif

/******************************************************************************/
/********************************* System *************************************/
/******************************************************************************/

void _exit(int code) {
  // TODO: implement this _exit function?
}

void _kill(int pid, int sig) {
  // TODO: implement this _kill function?
}

int _getpid() {
  // TODO: implement this _getpid function?
  return 0;
}

/******************************************************************************/
/******************************** Hardware ************************************/
/******************************************************************************/

bool read_bit(uint8_t reg, uint8_t bit) {
  return 0; // TODO: read_bit should be written?
}

void set_bit(uint8_t reg, uint8_t bit) {
  return; // TODO: set_bit should be written?
}

void clear_bit(uint8_t reg, uint8_t bit) {
  return; // TODO: clear_bit should be written?
}

void write_register(uint8_t reg, uint8_t val) {
  return; // TODO: write_register should be written?
}

uint8_t read_register(uint8_t reg) {
  return 0; // TODO: read_register should be written?
}

void delay(int ms) {
  return eadk_timing_msleep(ms);
}

void delay_usec(uint64_t us) {
  return eadk_timing_usleep(us);
}

int millis() {
  return (int) eadk_timing_millis();
}

/******************************************************************************/
/******************************* EADK library *********************************/
/******************************************************************************/

// TODO: write here some useful functions written as bindings for the eadk.h library

void display_draw_string(const char * text, uint16_t x, uint16_t y) {
  return eadk_display_draw_string(text, (eadk_point_t){(uint16_t)x, (uint16_t)y}, true, eadk_color_black, eadk_color_white);
}

void display_draw_string_small(const char * text, uint16_t x, uint16_t y) {
  return eadk_display_draw_string(text, (eadk_point_t){(uint16_t)x, (uint16_t)y}, false, eadk_color_black, eadk_color_white);
}

// FIXME: this RESET the calculator?
void display_draw_string_full(const char * text, uint16_t x, uint16_t y, bool large_font, uint16_t text_color, uint16_t background_color) {
  return eadk_display_draw_string(text, (eadk_point_t){(uint16_t)x, (uint16_t)y}, large_font, (eadk_color_t) text_color, (eadk_color_t) background_color);
}

void display_push_rect_uniform(uint16_t background_color, uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
  return eadk_display_push_rect_uniform((eadk_rect_t){x, y, width, height}, (eadk_color_t) background_color);
}

void display_push_allscreen_uniform(uint16_t background_color) {
  return eadk_display_push_rect_uniform(eadk_screen_rect, (eadk_color_t) background_color);
}

/*************/
/* Backlight */
/*************/

void backlight_set_brightness(uint8_t brightness) { return eadk_backlight_set_brightness(brightness); }
uint8_t backlight_brightness() { return eadk_backlight_brightness(); }

/***********/
/* Battery */
/***********/

// bool battery_is_charging() { return eadk_battery_is_charging(); }
// uint8_t battery_level() { return eadk_battery_level(); }
// float battery_voltage() { return eadk_battery_voltage(); }

/********/
/* Misc */
/********/

// bool usb_is_plugged() { return eadk_usb_is_plugged(); }
uint32_t random() { return eadk_random(); }

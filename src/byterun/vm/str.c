#include <string.h>
#include <stdio.h>
#include <inttypes.h>
#include "values.h"
#include "str.h"

mlsize_t caml_string_length(value s) {
  mlsize_t temp;
  temp = Bosize_val(s) - 1;
  return temp - String_field(s, temp);
}

value create_bytes(mlsize_t str_len) {
  value res;
  mlsize_t blk_wlen = Wsize_bsize(str_len) + 1;
  mlsize_t blk_blen = Bsize_wsize(blk_wlen);
  OCamlAlloc(res, blk_wlen, String_tag);
  Ram_field(res, blk_wlen - 1) = 0;
  Ram_string_field(res, blk_blen - 1) = blk_blen - str_len - 1;
  return res;
}

value copy_bytes(const char *str) {
  mlsize_t str_len = strlen(str);
  value res = create_bytes(str_len);
  memcpy(Ram_string_val(res), str, str_len);
  return res;
}

value caml_create_string(value ml_len) {
  return create_bytes(Int_val(ml_len));
}

value caml_create_bytes(value ml_len) {
  return create_bytes(Int_val(ml_len));
}

value caml_ml_string_length(value s) {
  return Val_int(caml_string_length(s));
}

value caml_ml_bytes_length(value b) {
  return caml_ml_string_length(b);
}

value caml_blit_string(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  mlsize_t sofs = Int_val(ml_sofs);
  mlsize_t bofs = Int_val(ml_bofs);
  mlsize_t len = Int_val(ml_len);
  mlsize_t i;
  assert(Is_block(ml_b));
  assert(Is_in_ram(ml_b));
  for (i = 0; i < len; i ++) {
    Ram_string_field(ml_b, bofs + i) = String_field(ml_s, sofs + i);
  }
  return Val_unit;
}

value caml_blit_bytes(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  return caml_blit_string(ml_s, ml_sofs, ml_b, ml_bofs, ml_len);
}

value caml_fill_bytes(value ml_b, value ml_ofs, value ml_len, value ml_c) {
  mlsize_t ofs = Int_val(ml_ofs);
  mlsize_t len = Int_val(ml_len);
  uint8_t c = (uint8_t) Int_val(ml_c);
  mlsize_t i;
  assert(Is_block(ml_b));
  assert(Is_in_ram(ml_b));
  for (i = 0; i < len; i ++) {
    Ram_string_field(ml_b, ofs + i) = c;
  }
  return Val_unit;
}

value caml_string_equal(value s1, value s2) {
  mlsize_t sz1, sz2, i;
  if (s1 == s2) return Val_true;
  sz1 = Wosize_val(s1);
  sz2 = Wosize_val(s2);
  if (sz1 != sz2) return Val_false;
  for (i = 0; i < sz1; i ++) {
    value v1 = Field(s1, i);
    value v2 = Field(s2, i);
    if (v1 != v2) return Val_false;
  }
  return Val_true;
}

int string_compare(value s1, value s2) {
  mlsize_t sz1, sz2, sz, i;
  if (s1 == s2) return 0;
  sz1 = Bosize_val(s1);
  sz2 = Bosize_val(s2);
  sz = sz1 < sz2 ? sz1 : sz2;
  for (i = 0; i < sz; i ++) {
    char c1 = String_field(s1, i);
    char c2 = String_field(s2, i);
    if (c1 < c2) return -1;
    if (c1 > c2) return 1;
  }
  if (sz1 == sz2) return 0;
  return sz1 < sz2 ? -1 : 1;
}

value caml_string_compare(value s1, value s2) {
  return Val_int(string_compare(s1, s2));
}

value caml_string_lessthan(value s1, value s2) {
  return caml_string_compare(s1, s2) < Val_int(0) ? Val_true : Val_false;
}

value caml_bytes_compare(value b1, value b2) {
  return caml_string_compare(b1, b2);
}

value caml_bytes_equal(value s1, value s2) {
  return caml_string_equal(s1, s2);
}

value caml_string_notequal(value s1, value s2) {
  return Val_bool(!Bool_val(caml_string_equal(s1, s2)));
}

value caml_string_get(value s, value i) {
  mlsize_t idx = Int_val(i);
  mlsize_t len = caml_string_length(s);
  if (idx >= len) caml_raise_index_out_of_bounds();
  return Val_int(String_field(s, idx));
}

value caml_bytes_get(value b, value i) {
  return caml_string_get(b, i);
}

value caml_bytes_set(value b, value i, value c) {
  assert(Is_block(b));
  assert(Is_in_ram(b));
  mlsize_t idx = Int_val(i);
  mlsize_t len = caml_string_length(b);
  if (idx >= len) caml_raise_index_out_of_bounds();
  Ram_string_field(b, idx) = Int_val(c);
  return Val_unit;
}

value caml_string_of_int(value v) {
  char buf[13];
#if OCAML_VIRTUAL_ARCH == 16
  snprintf(buf, sizeof(buf), "%" PRId16, Int_val(v));
#elif OCAML_VIRTUAL_ARCH == 32
  snprintf(buf, sizeof(buf), "%" PRId32, Int_val(v));
#elif OCAML_VIRTUAL_ARCH == 64
  format_long(buf, sizeof(buf), v);
#endif
  return copy_bytes(buf);
}

value caml_string_of_float(value v) {
  char buf[13];
  double f = Float_val(v);
  // float snprintf does not work on numworks, so we redefine it
  #ifdef __NUMWORKS__
  int l = snprintf(buf, sizeof(buf), "%ld.", (long)f);
  if (l < sizeof(buf)) {
    // round to the nearest 10e-3
    int dec_part = ((int)(f*10000))%10000;
    if (dec_part % 10 < 5) dec_part = dec_part%1000;
    else dec_part = dec_part%1000 + 1;
    snprintf(buf+l, sizeof(buf)-l, "%d", dec_part);
  }
  #else
  snprintf(buf, sizeof(buf), "%.3lg", f);
  #endif
  return copy_bytes(buf);
}

value caml_string_of_bytes(value v){
  return v;
}

value caml_bytes_of_string(value v){
  return v;
}

#define INT_ERRMSG "int_of_string"

static int parse_sign_and_base(/*in*/  value v,
                               /*out*/ unsigned int * base,
                               /*out*/ unsigned int * signedness,
                               /*out*/ int * sign) {
  int pos = 0;
  *sign = 1;
  if (String_field(v, pos) == '-') {
    *sign = -1;
    pos += 1;
  } else if (String_field(v, pos) == '+') {
    pos += 1;
  }
  *base = 10; *signedness = 1;
  if (String_field(v, pos) == '0') {
    switch (String_field(v, pos+1)) {
    case 'x': case 'X':
      *base = 16; *signedness = 0; pos += 2; break;
    case 'o': case 'O':
      *base = 8; *signedness = 0; pos += 2; break;
    case 'b': case 'B':
      *base = 2; *signedness = 0; pos += 2; break;
    case 'u': case 'U':
      *signedness = 0; pos += 2; break;
    }
  }
  return pos;
}

static unsigned int parse_digit(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  else if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  else if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  else return -1;
}

static int parse_intnat(value s, unsigned int nbits, const char *errmsg) {
  unsigned int pos;
  unsigned int res, threshold;
  int sign; unsigned int base, signedness, d;

  pos = parse_sign_and_base(s, &base, &signedness, &sign);
  threshold = ((unsigned int) -1) / base;
  d = parse_digit(String_field(s, pos));
  if (d < 0 || d >= base) caml_raise_failure(errmsg);
  for (pos++, res = d; /*nothing*/; pos++) {
    char c = String_field(s, pos);
    if (c == '_') continue;
    d = parse_digit(c);
    if (d < 0 || d >= base) break;
    /* Detect overflow in multiplication base * res */
    if (res > threshold) caml_raise_failure(errmsg);
    res = base * res + d;
    /* Detect overflow in addition (base * res) + d */
    if (res < d) caml_raise_failure(errmsg);
  }
  if (pos != caml_string_length(s)){
    caml_raise_failure(errmsg);
  }
  if (signedness) {
    /* Signed representation expected, allow -2^(nbits-1) to 2^(nbits-1) - 1 */
    if (sign >= 0) {
      if (res >= (unsigned int)1 << (nbits - 1)) caml_raise_failure(errmsg);
    } else {
      if (res >  (unsigned int)1 << (nbits - 1)) caml_raise_failure(errmsg);
    }
  } else {
    /* Unsigned representation expected, allow 0 to 2^nbits - 1
       and tolerate -(2^nbits - 1) to 0 */
    if (nbits < sizeof(unsigned int) * 8 && res >= (unsigned int)1 << nbits)
      caml_raise_failure(errmsg);
  }
  return sign < 0 ? -res : res;
}

value caml_int_of_string(value v) {
  return Val_int(parse_intnat(v, 8 * sizeof(value) - 1, INT_ERRMSG));
}

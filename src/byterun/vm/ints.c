#include <stdint.h>
#include "values.h"

static int parse_int(char *s, int l) {
  return atoi(s); // TODO this should be more faithful to ocaml's ints (in particular regarding bases)
}

value caml_int_of_string(value s) {
  int n = string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  return Val_int(parse_int(buf, n));
}

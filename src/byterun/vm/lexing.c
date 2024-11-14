#define Block_val(x) (Is_block_in_flash_heap(x) ? Flash_block_val(x) : Ram_block_val(x))

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

#define Short(tbl,n) (((short *)(Block_val(tbl)))[(n)])
#define UShort(tbl,n) (((unsigned short *)(Block_val(tbl)))[(n)])
#define Byte_u(tbl,n) (((unsigned char *)(Block_val(tbl)))[n]) /* Also an l-value. */

value caml_lex_engine(value vtbl, value start_state, value vlexbuf)
{
  struct lexing_table * tbl = (struct lexing_table *) Block_val(vtbl);
  struct lexer_buffer * lexbuf = (struct lexer_buffer *) Block_val(vlexbuf);
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
      lexbuf->lex_curr_pos = Val_int(Int_val(lexbuf->lex_curr_pos) + 1);
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
        caml_raise_failure("lexing: empty token");
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

#!/usr/bin/env bash
r=$(dirname $0)
root=$r/../..
$root/ocaml-src/runtime/ocamlrun $r/lex.byte "$@"

#!/usr/bin/env bash
r=$(dirname $0)
root=$r/../..
$root/ocaml-src/runtime/ocamlrun $r/make_opcodes.byte "$@"

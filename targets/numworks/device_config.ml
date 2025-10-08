(******************************************************************************)

let default_arm_cxx_options = [ "-std=c99" ]
                              @ (String.split_on_char ' ' Config.eadk_cflags)
                              @ [ "-fno-exceptions"; "-fno-unwind-tables" ]
                              @ [ "-Os"; "-Wall"; "-ggdb"]

let nwlink_cmd = [ "npx"; "--yes"; "--"; "nwlink@0.0.19"; "install-nwa" ]

module NumworksConfig : DEVICECONFIG = struct
  let compile_ml ~ppx_options ~mlopts ~cxxopts ~local ~trace ~verbose
        inputs output =
  let libdir = libdir local in
  let vars = [ ("CAMLLIB", libdir) ] in
  let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
  let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
  let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
  let cmd = cmd @ [ "-I"; Filename.concat libdir "targets/numworks";
                    Filename.concat libdir "targets/numworks/numworks.cma";
                    "-open"; "Numworks" ] in
  (* FIXED: this additional flag is here to allow references to the EADK lib values/functions to be added later, by the flashing website ? *)
  (* See: https://stackoverflow.com/questions/5555632/can-gcc-not-complain-about-undefined-references#5556948 for a reference *)
  let cmd = cmd @ [ "-ccopt"; "-Wl,--allow-shlib-undefined,--unresolved-symbols=ignore-all" ] in
  let cmd = cmd @ output @ inputs in
  run ~vars ~verbose cmd

let compile_c_to_hex ~local ~trace:_ ~verbose ~cxxopts input output =
  let includedir = includedir local in
  let numworksdir =
    if local then Filename.concat Config.builddir "src/byterun/numworks"
    else Filename.concat Config.includedir "numworks" in

  let arm_o_file = (Filename.remove_extension input)^".arm_o" in

  (* Compile a .c into a .arm_o *)

  let conc_numworks s = Filename.concat numworksdir s in
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ cxxopts in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ "-I"; Filename.concat includedir "numworks" ] in
  let cmd = cmd @ [ "-o"; arm_o_file ] @ [ "-c"; input ] in
  (* Printf.printf "################## Compile  a .c into a .arm_o\n"; *)
  run ~verbose cmd;
  (* Printf.printf "################## Compiled a .c into a .arm_o\n"; *)

  (* Compile a .arm_o into a .arm_elf *)
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ cxxopts in
  let cmd = cmd @ [ "-Wl,--relocatable" ] in
  let cmd = cmd @ [ "-nostartfiles" ] in
  let cmd = cmd @ [ "-specs=nano.specs" ] in
  let cmd = cmd @ [ "-fdata-sections"; "-ffunction-sections" ] in
  let cmd = cmd @ [ "-Wl,-e,main"; "-Wl,-u,eadk_app_name"; "-Wl,-u,eadk_app_icon"; "-Wl,-u,eadk_api_level" ] in
  let cmd = cmd @ [ "-Wl,--gc-sections" ] in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ arm_o_file; conc_numworks "icon.o" ] in
  let cmd = cmd @ [ "-lm" ] in
  let cmd = cmd @ [ "-o" ; output ] in
  run ~verbose cmd

  let simul_flag = "__SIMUL_NUMWORKS__"

  let flash ~sudo:_ ~verbose hexfile =
    run ~verbose (nwlink_cmd @ [ hexfile ])
end

(******************************************************************************)

(** Choose correct config according to name *)
let get_config name = match name with
  | "numworks" -> (module NumworksConfig : DEVICECONFIG)
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [ "numworks" ] @ (all_config_names ())

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

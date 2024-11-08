(******************************************************************************)

let default_arm_cxx_options = [ "-std=c99" ]
                              @ (String.split_on_char ' ' Config.eadk_cflags)
                              @ [ "-fno-exceptions"; "-fno-unwind-tables" ]
                              @ [ "-Os"; "-Wall"; "-ggdb"]

module NumworksConfig : DEVICECONFIG = struct
  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~local ~trace ~verbose
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
  let cmd = cmd @ inputs @ [ "-o"; output ] in
  Printf.printf "################## Compile  a .ml into a .byte\n";
  run ~vars ~verbose cmd;
  Printf.printf "################## Compiled a .ml into a .byte\n"


let compile_c_to_hex ~local ~trace:_ ~verbose ~cxxopts input output =
  let includedir = includedir local in
  let numworksdir =
    if local then Filename.concat Config.builddir "src/byterun/numworks"
    else Filename.concat Config.includedir "numworks" in

  let arm_o_file = (Filename.remove_extension input)^".arm_o" in
  let arm_elf_file = (Filename.remove_extension input)^".arm_elf" in
  (* let arm_map_file = (Filename.remove_extension input)^".map" in *)

  (* Compile a .c into a .arm_o *)

  let conc_numworks s = Filename.concat numworksdir s in
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ cxxopts in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ "-I"; Filename.concat includedir "numworks" ] in
  let cmd = cmd @ [ "-o"; arm_o_file ] @ [ "-c"; input ] in
  Printf.printf "################## Compile  a .c into a .arm_o\n";
  run ~verbose cmd;
  Printf.printf "################## Compiled a .c into a .arm_o\n";

  (* Compile a .arm_o into a .arm_elf *)
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ cxxopts in
  let cmd = cmd @ [ "-Wl,--relocatable" ] in
  let cmd = cmd @ [ "-nostartfiles" ] in
  (* FIXED: find which -specs=... file should be used *)
  let cmd = cmd @ [ "-specs=nano.specs" ] in
  (* let cmd = cmd @ [ "-specs=nosys.specs" ] in *) (* this one broke everything...*)
  let cmd = cmd @ [ "-fdata-sections"; "-ffunction-sections" ] in
  let cmd = cmd @ [ "-Wl,-e,__start"; "-Wl,-u,eadk_app_name"; "-Wl,-u,eadk_app_icon"; "-Wl,-u,eadk_api_level" ] in
  let cmd = cmd @ [ "-Wl,--gc-sections" ] in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ arm_o_file;
                    conc_numworks "startup.o";
                    conc_numworks "icon.o" ] in
  let cmd = cmd @ [ "-lm" ] in
  let cmd = cmd @ [ "-o" ; arm_elf_file ] in
  List.iter (Printf.printf "%s ") cmd;
  Printf.printf "################## Compile  a .arm_o into a .arm_elf\n";
  run ~verbose cmd;
  Printf.printf "################## Compiled a .arm_o into a .arm_elf\n";

  (* Compile a .arm_elf into a .hex *)
  Printf.printf "################## Compile  a .arm_elf into a .hex\n";
  let cmd = [ "cp"; arm_elf_file; output ] in
  run ~verbose cmd;
  Printf.printf "################## Compiled a .arm_elf into a .hex\n"

  let simul_flag = "__SIMUL_NUMWORKS__"

  let flash ~sudo:_ ~verbose:_ _hexfile =
    failwith "Error: flashing is not supported, use <https://my.numworks.com/apps> instead to flash the resulting NWA app to your Numworks calculator."
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

#require "bistro.bioinfo bistro.utils"

open Bistro.EDSL
open Bistro_bioinfo.Std
open Bistro_utils
open Printf
open Bistro_bioinfo
open Bistro_bioinfo.Spades


(* function to read file to serve as input for Trimmomatic*)

(*read a file line by line *)

(*
let () =
  let ic = open_in "test.txt" in
  try
    while true do
      let line = input_line ic in
      print_endline line
    done
  with End_of_file ->
    close_in ic

*)

let sub_data1 = "sub_data_1.fastq"
let sub_data2 = "sub_data_2.fastq"

(* use spades assembler in bistro to perform assembly *)

let assembly = spades[`sanger] sub_data1 [`sanger] sub_data2


(* use PROKKA to perform annotation *)
let annotation = Prokka.run assembly


(*sauvegarde dans dossier*)
let repo = Bistro_repo.[
  [ "annotation" ] %> annotation
]

let () = Bistro_repo.build ~outdir:"res" ~np:4 ~mem:(4000) repo







#require "bistro.bioinfo bistro.utils"

open Core_kernel.Std;;
open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;

(*let a = Truc.a ;;*)

(* Test Trimmomatic

let env = docker_image ~account:"pveber" ~name:"trimmomatic" ~tag:"0.36" ()

let trimmo reads1 reads2 output1 output2 = 
  workflow ~descr:"trimmomatic" [
    cmd "trimmomatic" ~env[
      string "PE" ; 
      option dep reads1 ; 
      option dep reads2 ;
    ] 
  ]  
*)

let reads1 = input "/home/cecile/projetM2_data/data/reads1_100k.fastq" (* Read file as workflow *)
let reads2 = input "/home/cecile/projetM2_data/data/reads2_100k.fastq"

let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
(* Look at spades.mli in bistro github for the arguments. The function spades returns a type [`spades] directory workflow. 
? means optionnal arguments. Here we provide ~pe arguments which needs a pair of fastq workflow list. reads1 and reads2 are fastq workflow. [reads1] is a fastq workflow list.
() is unit argument *)

let contigs = assembly/Spades.contigs (* Selector for the contigs*)

let annotation = Prokka.run contigs (* Launch prokka with default arguments. See Prokka.mli to see all optionnal arguments *)

let repo = Repo.[
  [ "assembly" ] %> assembly ; 
  [ "annotation" ] %> annotation ; 
]


let logger = Console_logger.create () (* Show more error messages *)

let () = Repo.build ~logger ~outdir:"res" ~np:2 ~mem:(`GB 4) repo;; (* Launch pipeline *)
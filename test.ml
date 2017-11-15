#require "bistro.bioinfo bistro.utils";;

open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;

let reads1 = input "../projetM2_data/data/reads1_test.fastq"   (* Fetch a sample from the SRA database "ERR1073432" : illumina hiseq paired end reads from e coli K12 *)
let reads2 = input "../projetM2_data/data/reads2_test.fastq"

let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()  (* type de ~pe : (sanger fastq bistro workflow list, sanger bistro workflow fastq list) *)

let repo = Repo.[
  [ "test" ] %> assembly ;
]

let logger = Console_logger.create ()

let () = Repo.build ~logger ~outdir:"res" ~np:2 ~mem:(`GB 4) repo;;
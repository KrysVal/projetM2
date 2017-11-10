#require "bistro.bioinfo bistro.utils";;

open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;

let sample = Sra.fetch_srr "ERR1073432";;     (* Fetch a sample from the SRA database "ERR1073432" : illumina hiseq paired end reads from e coli K12 *)
let sample_fq = Sra_toolkit.fastq_dump_pe  sample;;    (* Convert it to FASTQ paired end format *)

let assembly = Spades.spades ~pe:sample_fq ();;   (* type de ~pe : (sanger fastq bistro workflow list, sanger bistro workflow fastq list) *)


let repo = Bistro_repo.[
  [ "assembly" ] %> assembly
];;

let () = Bistro_repo.build ~outdir:"res2" ~np:2 ~mem:2000 repo;;

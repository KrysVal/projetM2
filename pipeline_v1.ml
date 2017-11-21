#require "bistro.bioinfo bistro.utils";;

open Core_kernel.Std;;
open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;


(* Homemade simple prokka *)

let env = docker_image ~account:"pveber" ~name:"prokka" ~tag:"1.12" ()

let gram_expr = function
  | `Plus -> string "+"
  | `Minus -> string "-"

let prokka ?prefix ?addgenes ?locustag ?increment ?gffver ?compliant
    ?centre ?genus ?species ?strain ?plasmid ?kingdom ?gcode ?gram
    ?usegenus ?proteins ?hmms ?metagenome ?rawproduct ?fast ?(threads = 1)
    ?mincontiglen ?evalue ?rfam ?norrna ?notrna ?rnammer fa =
  workflow ~descr:"prokka" ~np:threads ~mem:(3 * 1024) [
    mkdir_p dest ;
    cmd "prokka" ~env [
      string "--force" ;
      option (opt "--prefix" string) prefix ;
      option (flag string "--addgenes") addgenes ;
      option (opt "--locustag" string) locustag ;
      option (opt "--increment" int) increment ;
      option (opt "--gffver" string) gffver ;
      option (flag string "--compliant") compliant ;
      option (opt "--centre" string) centre ;
      option (opt "--genus" string) genus ;
      option (opt "--species" string) species ;
      option (opt "--strain" string) strain ;
      option (opt "--plasmid" string) plasmid ;
      option (opt "--kingdom" string) kingdom ;
      option (opt "--gcode" int) gcode ;
      option (opt "--gram" gram_expr) gram ;
      option (flag string "--usegenus") usegenus ;
      option (opt "--proteins" string) proteins ;
      option (opt "--hmms" string) hmms ;
      option (flag string "--metagenome") metagenome ;
      option (flag string "--rawproduct") rawproduct ;
      option (flag string "--fast") fast ;
      opt "--cpus" ident np ;
      option (opt "--mincontiglen" int) mincontiglen ;
      option (opt "--evalue" float) evalue ;
      option (flag string "--rfam") rfam ;
      option (flag string "--norrna") norrna ;
      option (flag string "--notrna") notrna ;
      option (flag string "--rnammer") rnammer ;
      opt "--outdir" ident dest ;
      dep fa ;
    ] ;
]


let reads1 = input "../projetM2_data/data/reads1_100k.fastq" (* Read file as workflow *)
let reads2 = input "../projetM2_data/data/reads2_100k.fastq"

let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
(* Look at spades.mli in bistro github for the arguments. The function spades returns a type [`spades] directory workflow. 
? means optionnal arguments. Here we provide ~pe arguments which needs a pair of fastq workflow list. reads1 and reads2 are fastq workflow. [reads1] is a fastq workflow list.
() is unit argument *)

let contigs = assembly/Spades.contigs (* Selector for the contigs*)

let annotation = prokka contigs (* Launch prokka with default arguments. See Prokka.mli to see all optionnal arguments *)

let repo = Repo.[
  [ "assembly" ] %> assembly ; 
  [ "annotation" ] %> annotation ; 
]


let logger = Console_logger.create () (* Show more error messages *)

let () = Repo.build ~logger ~outdir:"res" ~np:2 ~mem:(`GB 4) repo;; (* Launch pipeline *)
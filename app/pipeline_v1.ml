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

let reads1 = input "/home/cecile/projetM2_data/data/ERR1073432_1.fastq" (* Read file as workflow *)
let reads2 = input "/home/cecile/projetM2_data/data/ERR1073432_2.fastq"
let reference = input "/home/cecile/projetM2_data/ecoli.fna"
let ref_prot = input "/home/cecile/projetM2_data/data/ref_prot.fa"

let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
(* Look at spades.mli in bistro github for the arguments. The function spades returns a type [`spades] directory workflow. 
? means optionnal arguments. Here we provide ~pe arguments which needs a pair of fastq workflow list. reads1 and reads2 are fastq workflow. [reads1] is a fastq workflow list.
() is unit argument *)

let contigs = assembly/Spades.contigs (* Selector for the contigs*)

let annotation = Prokka2.run contigs (* Launch prokka with default arguments. See Prokka.mli to see all optionnal arguments*)

let prokka_transcripts = annotation/Prokka2.transcripts(* TO DO : add selector to prokka.ml*)
let proteins = annotation/Prokka2.proteins

let dbtype1 = string "nucl"
let dbtype2 = string "prot"
let out_blast1 = "transcripts_vs_allrefgenome.blast"
let out_blast2 = "cds_vs_proteinsref.blast"
let out_blast_xml = "cds_vs_proteinsref.xml"

let blastdb_allgenome = Blast.fastadb reference dbtype1
let blastdb_prot = Blast.fastadb ref_prot dbtype2
let results_blast = Blast.blastn ~threads:2 ~evalue:1e-6 blastdb_allgenome prokka_transcripts out_blast1 
let results_blast2 = Blast.blastp ~threads:2 ~evalue:1e-6 blastdb_prot proteins out_blast2
let results_blast_xml = Blast.blastp ~threads:2 ~evalue:1e-6 ~outfmt:"5" blastdb_prot proteins out_blast_xml 


let repo = Repo.[
  [ "assembly" ] %> assembly ; 
  [ "annotation" ] %> annotation ; 
  [ "blast_nucl" ] %> results_blast ; 
  [ "blast_prot" ] %> results_blast2 ;
  [ "blast_prot_xml" ] %> results_blast_xml ; 
]


let logger = Console_logger.create () (* Show more error messages *)

let () = Repo.build ~logger ~outdir:"resultat_complet" ~np:2 ~mem:(`GB 4) repo;; (* Launch pipeline *)
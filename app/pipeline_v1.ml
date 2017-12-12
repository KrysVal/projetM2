open Core;;
open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;
open Bistro.Std 

 let head ~n w =
    cmd "head" ~stdout:dest [
    
      opt "-n" int n ;
      dep w ;

]

let transform r = 
	match r with 
	r -> head ~n:40000 r 
		
module type Param = sig 
	val fq1 : [`sanger] fastq workflow   
	val fq2 : [`sanger] fastq workflow  
	val reference : fasta workflow option 
	val preview : bool
end 

module Make (P : Param) = struct 
	let reads1 = P.fq1
	let reads2 = P.fq2

	if P.preview then begin 
		transform reads1 ; 
		transform reads2 ; 

	if P.preview then begin 
		let reads1 = head ~n:40000 P.fq1 ; 
		let reads2 = head ~n:40000 P.fq2 ; 
	end 	
	else 	
		let reads1 = P.fq1 ; 
		let reads2 = P.fq2 ; 
	end 	
		
	let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
	let contigs = assembly/Spades.contigs
	let quast_output = Quast.quast ?reference:P.reference ~labels:["spades_assembly"] [contigs]
	let annotation = Prokka2.run contigs
	let repo = Repo.[
	  	[ "assembly" ] %> assembly ; 
		[ "quast" ] %> quast_output ; 
		[ "annotation" ] %> annotation ; 
	]

	
end 	

(*let reads1 = input "/home/cecile/projetM2_data/data/reads1_100k.fastq" (* Read file as workflow *)
let reads2 = input "/home/cecile/projetM2_data/data/reads2_100k.fastq"
let reference = input "/home/cecile/projetM2_data/ecoli.fna"
let ref_prot = input "/home/cecile/projetM2_data/data/ref_prot2.fa"

let ref_quast = input "data/Ref_Genome_ecoli_K12/U00096.fasta"

let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
(* Look at spades.mli in bistro github for the arguments. The function spades returns a type [`spades] directory workflow. 
? means optionnal arguments. Here we provide ~pe arguments which needs a pair of fastq workflow list. reads1 and reads2 are fastq workflow. [reads1] is a fastq workflow list.
() is unit argument *)

let contigs = assembly/Spades.contigs (* Selector for the contigs*)

let quast_output = Quast.quast ~reference:ref_quast  ~labels:["spades_assembly"] [contigs] (* Launch quast with reference assembly file *)

let annotation = Prokka2.run ~gffver:"2" contigs (* Launch prokka with default arguments. See Prokka.mli to see all optionnal arguments*)

let prokka_transcripts = annotation/Prokka2.transcripts
let proteins = annotation/Prokka2.proteins

let dbtype1 = string "nucl"
let dbtype2 = string "prot"

(*let blastdb_allgenome = Blast.fastadb reference dbtype1*)
let blastdb_prot = Blast.makedb ~dbtype:`Prot ref_prot 
(*let results_blast = Blast.blastn ~threads:2 ~evalue:1e-6 blastdb_allgenome prokka_transcripts out_blast1 
let results_blast2 = Blast.blastp ~threads:2 ~evalue:1e-6 blastdb_prot proteins out_blast2*)
let launch_blast = Blast.blastp ~threads:2 ~evalue:1e-6 ~outfmt:"5" blastdb_prot proteins

let blast_results = launch_blast/Blast.blast_align 

let blast_treatment = Blast_treatment.run blast_results

let repo = Repo.[
  [ "assembly" ] %> assembly ; 
  [ "quast" ] %> quast_output; 
  [ "annotation" ] %> annotation ; 
  (*[ "blast_nucl" ] %> results_blast ; 
  [ "blast_prot" ] %> results_blast2 ;
  [ "blast_prot_xml" ] %> results_blast_xml ; *) 
  [ "blast_prot" ] %> launch_blast ; 
  [ "blast_treatment" ] %> blast_treatment ; 

]


let logger = Console_logger.create () (* Show more error messages *)

let () = Repo.build ~logger ~outdir:"test_gff2" ~np:2 ~mem:(`GB 4) repo;; (* Launch pipeline *) *)

open Bistro.Std 
open Core;;
open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;
open Bistro.Std 


let fetch url = 
	Unix_tools.gunzip(Unix_tools.wget url) 

(*let reads1 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_1.fastq.gz"
let reads2 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_2.fastq.gz"*)

(* TROUVER REF URL*)

module type Param = sig  
	val preview : int option

end

module Make (P : Param) = struct 
	let reads1 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_1.fastq.gz"
	let reads2 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_2.fastq.gz"
	let reference = fetch "ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz" (* A voir *)
	let ref_proteins = fetch "ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_protein.faa.gz"
	
	module P2 = struct 
		let fq1 = reads1 
		let fq2 = reads2 
		let reference = Some reference 
		let preview = P.preview
	end
	(*let preview = true*)

	module Pipeline = Pipeline_v1.Make(P2)	
	include Pipeline 

	let proteins = Pipeline.annotation/Prokka2.proteins
	let blastdb_prot = Blast.makedb ~dbtype:`Prot ref_proteins 
	let blast_results = Blast.blastp ~threads:2 ~evalue:1e-6 ~outfmt:"5" blastdb_prot proteins
	let blast_results_70 = Blast.blastp ~threads:2 ~evalue:1e-6 ~query_cov:70.0 ~outfmt:"5" blastdb_prot proteins
	let blast_results_80 = Blast.blastp ~threads:2 ~evalue:1e-6 ~query_cov:80.0 ~outfmt:"5" blastdb_prot proteins
	let blast_results_90 = Blast.blastp ~threads:2 ~evalue:1e-6 ~query_cov:90.0 ~outfmt:"5" blastdb_prot proteins
	let blast_results_100 = Blast.blastp ~threads:2 ~evalue:1e-6 ~query_cov:100.0 ~outfmt:"5" blastdb_prot proteins
	let blast_tr = Blast_treatment.run blast_results
	let blast_tr_70 = Blast_treatment.run blast_results_70
	let blast_tr_80 = Blast_treatment.run blast_results_80
	let blast_tr_90 = Blast_treatment.run blast_results_90
	let blast_tr_100 = Blast_treatment.run blast_results_100

	let repo2 = Repo.[
		[ "eval_blast" ] %> blast_tr ;	
		[ "eval_blast_70" ] %> blast_tr_70 ;	
		[ "eval_blast_80" ] %> blast_tr_80 ;	
		[ "eval_blast_90" ] %> blast_tr_90 ;	
		[ "eval_blast_100"] %> blast_tr_100 
	]	

	let repo = Pipeline.repo@repo2



	end
(*
module P2 = struct 
	let fq1 = reads1 
	let fq2 = reads2 
	let reference = Some reference 
	(*let preview = true*)
end 
*)







 
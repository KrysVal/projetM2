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
	let blast_treatment = Blast_treatment.run blast_results
end

(*
module P2 = struct 
	let fq1 = reads1 
	let fq2 = reads2 
	let reference = Some reference 
	(*let preview = true*)
end 
*)








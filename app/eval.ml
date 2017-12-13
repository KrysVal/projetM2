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
	val preview : bool
end

module Make (P : Param) = struct 
	let reads1 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_1.fastq.gz"
	let reads2 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_2.fastq.gz"
	let reference = fetch "test" (* A voir *)
	module P2 = struct 
		let fq1 = reads1 
		let fq2 = reads2 
		let reference = Some reference 
		let preview = P.preview
	end
	(*let preview = true*)

	module Pipeline = Pipeline_v1.Make(P2)	
	include Pipeline 

	(*let preview = P.preview*)
end

(*
module P2 = struct 
	let fq1 = reads1 
	let fq2 = reads2 
	let reference = Some reference 
	(*let preview = true*)
end 
*)








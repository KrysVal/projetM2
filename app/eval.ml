open Bistro.Std 

let fetch url = 
	Unix_tools.gunzip(Unix_tools.wget url) 

let reads1 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_1.fastq.gz"
let reads2 = fetch "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR107/002/ERR1073432/ERR1073432_2.fastq.gz"

(* TROUVER REF URL*)

let reference = fetch "test" (* A voir *)
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

module Pipeline = Pipeline_v1.Make(P2)	

include Pipeline 





open Core;;
open Bistro.EDSL;;
open Bistro_bioinfo.Std;;
open Bistro_utils;;
open Bistro_bioinfo;;
open Bistro.Std 


(* Creation de la fonction fastq_head pour echantilloner le jeu de donnee *)
(* il s agit d un workflow Bistro auquel on ajoute les options dont on a besoin *)

 let fastq_head ~n w = workflow ~descr:"head" [ 
    cmd "head" ~stdout:dest [                   
    
      opt "-n" int (n*4) ;
      dep w ;
]
]

(* sous fonction pour l echantillonage des reads des fastq pair-end *)
let transform r n = 
	fastq_head ~n:(n*1000) r   
		



(* module qui permet de renseigner les parametres obligatoires et optionnels *)
module type Param = sig  
	val fq1 : [`sanger] fastq workflow   
	val fq2 : [`sanger] fastq workflow  
	val reference : fasta workflow option 
	val preview : int option
end



(* module qui definit les actions a accomplir par le pipeline *)
module Make (P : Param) = struct 
	
let reads1,reads2 = 

	match P.preview with (* Verifie si l'option preview est presente *)
		|None -> P.fq1, P.fq2
		|Some n -> transform P.fq1 n, transform P.fq2 n (* si oui on echantillone les fq *)



	let assembly = Spades.spades ~memory:4 ~pe:([reads1],[reads2]) ()
	let contigs = assembly/Spades.contigs
	let quast_output = Quast.quast ?reference:P.reference ~labels:["spades_assembly"] [contigs]
	let annotation = Prokka2.run contigs
	let repo = Repo.[ (* repo definie les differents dossier resultats cree par le pipeline *)
	  	[ "assembly" ] %> assembly ; 
		[ "quast" ] %> quast_output ; 
		[ "annotation" ] %> annotation ; 
		
	] 

end


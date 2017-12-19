open Sexplib.Std
open Bistro.EDSL
open Bistro_bioinfo.Std
open Bistro_utils

(* Module qui permet de deployer facilement le pipeline sur un serveur web en utilisant la librairie Bistro_server *)

module Pipeline_App = struct 
	type input = { 
		sample_id : string ;  (* dans le input on recupere les saisies de l utilisateur *)
		sample_file1 : string [@file] ; 
		sample_file2 : string [@file] ; 
		(*sample_preview : int ;*)
	}
	[@@deriving sexp, bistro_form] 

	let title = "Assembly and Annotation Pipeline" (* le titre de la page web *)


	let derive ~data i = 
		let module P = struct  
			let fq1 = input (data i.sample_file1) 
			let fq2 = input (data i.sample_file2) 
			let reference = None
			let preview = Some 50
		end in   
		let module Pipeline = Pipeline_v1.Make(P) in 
		Pipeline.repo (* on execute le  pipeline lorsque l utilisateur a saisi les champs obligatoires *)
end 	

(* On lance le serveur web *)
module Server = Bistro_server.Make(Pipeline_App) 

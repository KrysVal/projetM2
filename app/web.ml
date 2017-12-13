open Sexplib.Std
open Bistro.EDSL
open Bistro_bioinfo.Std
open Bistro_utils



module Pipeline_App = struct 
	type input = { 
		sample_id : string ; 
		sample_file1 : string [@file] ; 
		sample_file2 : string [@file] ; 
		(*sample_preview : int ;*)
	}
	[@@deriving sexp, bistro_form]

	let title = "Assembly and Annotation Pipeline"


	let derive ~data i = 
		let module P = struct  
			let fq1 = input (data i.sample_file1) 
			let fq2 = input (data i.sample_file2) 
			let reference = None
			let preview = Some 50
		end in   
		let module Pipeline = Pipeline_v1.Make(P) in 
		Pipeline.repo 
end 	

module Server = Bistro_server.Make(Pipeline_App)

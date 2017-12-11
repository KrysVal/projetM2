open Core;; 
open Bistro_utils;;
open Bistro.EDSL 

let pipeline_main fq1 fq2 outdir () = 
	let logger = Console_logger.create () in (* Show more error messages *)
	let module P = struct 
		let fq1 = input fq1 
		let fq2 = input fq2  
	end in 
	let module Pipeline = Pipeline_v1.Make(P) in 
	let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Pipeline.repo in () (* Launch pipeline *)

let pipeline_spec =
  let open Command.Spec in
  empty
  +> flag "--fq1" (required file) ~doc:"PATH Path to forward reads"
  +> flag "--fq2" (required file) ~doc:"PATH Path to reverse reads"
  +> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"

let pipeline_command =
  Command.basic
    ~summary:""
    pipeline_spec
    pipeline_main



let pipeline_eval_main outdir () = ()  

let pipeline_eval_spec = 
 	let open Command.Spec in
  	empty
  	+> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"

let pipeline_eval_command =
  Command.basic
    ~summary:""
    pipeline_eval_spec
    pipeline_eval_main

let command = 
	Command.group ~summary:"ProjetM2" [("pipeline",pipeline_command); ("eval",pipeline_eval_command)]    

let () = Command.run command

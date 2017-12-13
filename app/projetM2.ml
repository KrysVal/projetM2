open Core;; 
open Bistro_utils;;
open Bistro.EDSL 

let pipeline_main fq1 fq2 outdir preview () = 
	let logger = Console_logger.create () in (* Show more error messages *)
	let module P = struct 
		let fq1 = input fq1 
		let fq2 = input fq2  
		let reference = None
    	let preview = preview


	end in 
	let module Pipeline = Pipeline_v1.Make(P) in 
	let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Pipeline.repo in () (* Launch pipeline *)

let pipeline_spec =
  let open Command.Spec in
  empty
  +> flag "--fq1" (required file) ~doc:"PATH Path to forward reads"
  +> flag "--fq2" (required file) ~doc:"PATH Path to reverse reads"
  +> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
  +> flag "--preview" (optional int) ~doc:"INT specify number of sample reads to test"



let pipeline_command =
  Command.basic
    ~summary:""
    pipeline_spec
    pipeline_main



let pipeline_eval_main outdir preview () =  
	let logger = Console_logger.create () in (* Show more error messages *)
	let module P = struct 
    	let preview = preview

	end in 
	let module Eval = Eval.Make(P) in 
	let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Eval.repo in () (* Launch pipeline *)

let pipeline_eval_spec = 
 	let open Command.Spec in
  	empty
  	+> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
    +> flag "--preview" (optional int) ~doc:"INT number of sample reads (in thousand)"


let pipeline_eval_command =
  Command.basic
    ~summary:""
    pipeline_eval_spec
    pipeline_eval_main


let pipeline_web_main port np mem root_dir () = 
	Lwt_main.run (Web.Server.start ~port ~np ~mem:(`GB mem) ~root_dir ())



let pipeline_web_spec = 
 	let open Command.Spec in 
 	empty
  	+> flag "--port" (required int) ~doc:"INT name of port"
    +> flag "--np" (required int) ~doc:"INT number of processors"
    +> flag "--mem" (required int) ~doc:"INT memory used in GB"
    +> flag "--root-dir" (required string) ~doc:"PATH path to root directory"
  	

let pipeline_web_command =
  Command.basic
    ~summary:""
    pipeline_web_spec
    pipeline_web_main


let command = 
	Command.group ~summary:"ProjetM2" [("pipeline",pipeline_command); ("eval",pipeline_eval_command); ("web", pipeline_web_command)]    

let () = Command.run command



open Core;; 
open Bistro_utils;;

let pipeline_main fq1 fq2 () = 
	let logger = Console_logger.create () in (* Show more error messages *)
	let module P = struct 
		let fq1 = fq1 
		let fq2 = fq2 
	end in 
	let module Pipeline = Pipeline_v1.Make(P) in 
	let () = Repo.build ~logger ~outdir:"test_gff2" ~np:2 ~mem:(`GB 4) Pipeline.repo in () (* Launch pipeline *)

let pipeline_spec =
  let open Command.Spec in
  empty
  +> flag "--fq1" (required file) ~doc:"PATH Path to forward reads"
  +> flag "--fq2" (required file) ~doc:"PATH Path to reverse reads"

let pipeline_command =
  Command.basic
    ~summary:""
    pipeline_spec
    pipeline_main

 let () = Command.run pipeline_command
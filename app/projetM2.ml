open Core;; 
open Bistro_utils;;
open Bistro.EDSL 


(* Le code principal qui est appele par jbuilder pour compiler et construire le programme *)



(* Instructions lorsque la commande pipeline est lance *)
let pipeline_main fq1 fq2 outdir preview () = 
	let logger = Console_logger.create () in (* Show more error messages *)

	let module P = struct (* Definition des parametres du pipeline *) 
		let fq1 = input fq1 (* l'utilisateur doit renseigner ses fichiers fatsq pair-end*)
		let fq2 = input fq2  
		let reference = None
    	let preview = preview 


	end in 
	let module Pipeline = Pipeline_v1.Make(P) in 
	let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Pipeline.repo in () (* Dans le module Pipeline_v1 on cree les repertoires de resultats puis on les construits *) 



(* ajout d une mini doc dans le terminal pour la commande pipeline *)
let pipeline_spec = 
  let open Command.Spec in
  empty
  +> flag "--fq1" (required file) ~doc:"PATH Path to forward reads"
  +> flag "--fq2" (required file) ~doc:"PATH Path to reverse reads"
  +> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
  +> flag "--preview" (optional int) ~doc:"INT specify number of sample reads to test"



let pipeline_command =
  Command.basic
    ~summary:"Launch the pipeline in command lines with your own dataset to assemble, annotate and evaluate the results."
    pipeline_spec
    pipeline_main


(* Instructions lorsque la commande eval est lance *)
let pipeline_eval_main outdir preview () =  
	let logger = Console_logger.create () in (* Show more error messages *)
	let module P = struct 
    	let preview = preview 

	end in 
	let module Eval = Eval.Make(P) in 
	let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Eval.repo in () (* Dans le module Eval on cree les repertoires de resultats puis on les construits *)



(* ajout d une mini doc dans le terminal pour la commande eval *)
let pipeline_eval_spec = 
 	let open Command.Spec in
  	empty
  	+> flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
    +> flag "--preview" (optional int) ~doc:"INT number of sample reads (in thousand)"


let pipeline_eval_command =
  Command.basic
    ~summary:"Launch the evaluation of the pipeline on e.coli data get from the ENA web server."
    pipeline_eval_spec
    pipeline_eval_main


(* Instructions lorsque la commande web est lance *)
let pipeline_web_main port np mem root_dir () = 
	Lwt_main.run (Web.Server.start ~port ~np ~mem:(`GB mem) ~root_dir ())


(* ajout d une mini doc dans le terminal pour la commande web *)
let pipeline_web_spec = 
 	let open Command.Spec in 
 	empty
  	+> flag "--port" (required int) ~doc:"INT name of port"
    +> flag "--np" (required int) ~doc:"INT number of processors"
    +> flag "--mem" (required int) ~doc:"INT memory used in GB"
    +> flag "--root-dir" (required string) ~doc:"PATH path to root directory"
  	

let pipeline_web_command =
  Command.basic
    ~summary:"Launch the web interface of the pipeline."
    pipeline_web_spec
    pipeline_web_main

let sum = "\n\nBistro Assembly and Annotation Launcher\n\n\tWelcome to our bioinformatics pipeline. This pipeline was created in order to automatize recurent analyze such as assembly and annotation on bacterian datasets. It uses SPAdes, QUAST and PROKKA softwares, but also a blast treatment made by our own. The scripts are coded in Ocaml and use Bistro and Bistro_server librairies.\nEnjoy ! " 

(* definition des fonctions a lancer selon la commande entree *)
let command = 
	Command.group ~summary:sum [("pipeline",pipeline_command); ("eval",pipeline_eval_command); ("web", pipeline_web_command)]    

(* execution de la commande correspondante*)
let () = Command.run command 

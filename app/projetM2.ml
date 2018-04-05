open Core
open Bistro_utils
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

let pipeline_command =
  let open Command.Let_syntax in
  Command.basic
    ~summary:"Launch the pipeline in command line."
    [%map_open
      let fq1 = flag "--fq1" (required file) ~doc:"PATH Path to forward reads"
      and fq2 = flag "--fq2" (required file) ~doc:"PATH Path to reverse reads"
      and outdir = flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
      and preview = flag "--preview" (optional int) ~doc:"INT specify number of sample reads to test"
      in
      pipeline_main fq2 fq2 outdir preview]

(* Instructions lorsque la commande eval est lance *)
let pipeline_eval_main outdir preview () =
let logger = Console_logger.create () in (* Show more error messages *)
let module P = struct
    let preview = preview

end in
let module Eval = Eval.Make(P) in
let () = Repo.build ~logger ~outdir ~np:2 ~mem:(`GB 4) Eval.repo in () (* Dans le module Eval on cree les repertoires de resultats puis on les construits *)


let pipeline_eval_command =
  let open Command.Let_syntax in
  Command.basic
    ~summary:"Launch the evaluation of the pipeline on e.coli data set get from the ENA web server."
    [%map_open
      let outdir = flag "--outdir" (required string) ~doc:"PATH Path to outdir directory"
      and preview = flag "--preview" (optional int) ~doc:"INT number of sample reads (in thousand)"
      in
      pipeline_eval_main outdir preview]


(* Instructions lorsque la commande web est lance *)
let pipeline_web_main port np mem root_dir daemon () =
Lwt_main.run (Web.Server.start ~port ~np ~mem:(`GB mem) ~root_dir ~daemon ())


let pipeline_web_command =
  let open Command.Let_syntax in
  Command.basic
    ~summary:"Launch the web interface of the pipeline."
    [%map_open
      let port = flag "--port" (required int) ~doc:"INT name of port"
      and np = flag "--np" (required int) ~doc:"INT number of processors"
      and mem = flag "--mem" (required int) ~doc:"INT memory used in GB"
      and root_dir = flag "--root-dir" (required string) ~doc:"PATH path to root directory"
      and daemon_mode = flag "--daemon" no_arg ~doc:" run in daemon mode"
      in
      pipeline_web_main port np mem root_dir daemon_mode]

let sum = "\n\nBistro Assembly and Annotation Launcher\n\n\tWelcome to our bioinformatics pipeline. This pipeline was created in order to automate recurrent analysis such as assembly and annotation of bacterial data sets. It uses SPAdes, QUAST and PROKKA softwares, but also a blast treatment made by our own. The scripts are coded in Ocaml and use Bistro and Bistro_server librairies.\nEnjoy ! "

(* definition des fonctions a lancer selon la commande entree *)
let command =
Command.group ~summary:sum [("pipeline",pipeline_command); ("eval",pipeline_eval_command); ("web", pipeline_web_command)]

(* execution de la commande correspondante*)
let () = Command.run command

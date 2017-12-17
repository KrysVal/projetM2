open Core
open Bistro.Std
open Bistro.EDSL
open Bistro_bioinfo.Std

type db = [`blast_db] directory
let env = docker_image ~account:"pveber" ~name:"ncbi-blast" ~tag:"2.4.0" ()

let db_name = "db"

let makedb ~dbtype:dbtype fa = 
	let template_of_dbtype x = 
		string (
			match x with
	 		| `Nucl -> "nucl" 	
	 		| `Prot -> "prot"
	 	) (* .mli : [`Nucl | `Prot]) *)
  	in 
	workflow ~descr:"blast.makedb" [
		cmd ~env "makeblastdb" [
			opt "-in" dep fa ;
			opt "-out" ident (dest//db_name) ; 
			opt "-dbtype" template_of_dbtype dbtype ; 	
		] ; 	
	]

(* Basic blastn*)

let results = "results.blast"
let blastp ?evalue ?(threads = 4) ?outfmt ?query_cov db query = workflow ~descr:"blastp_xml" ~np:threads [ 
    cmd "blastp" ~env [
      opt "-db" ident (dep db // db_name) ; 
	  opt "-query" dep query ; 
	  opt "-out" ident dest ; 
	  option (opt "-evalue" float) evalue ;
	  option (opt "-outfmt" string) outfmt ; 
	  option (opt "-qcov_hsp_perc" float) query_cov ;  
    ]
  ]  

(*let blast_align = selector ["results.blast"]*) 
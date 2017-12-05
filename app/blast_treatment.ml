open Core_kernel.Std
open Bistro.EDSL

let env = docker_image ~account:"chilpert" ~name:"blast-treatment" ~tag:"1" ()

let run blast_results = workflow ~descr:"blast_treatment"[
    mkdir_p dest ;
    cmd "python3 quality_annotation_with_blast.py" ~env [
      dep blast_results ;
      ident dest ; 
    ] ;
  ]




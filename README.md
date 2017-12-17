# Bistro Assembly Annotation Launcher (BAAL)

BAAL is a cloud-enabled, bacterial genome assembly and annotation pipeline, based on the OCaml library [bistro](https://github.com/pveber/bistro).

## The Pipeline
BAAL use :
- SPADES for genome assembly
- QUAST to evaluate genome assembly
- PROKKA for genome annotation

> Ajout d'un schéma du pipeline

## Getting Started
All you need to do is to run the script etc/config_VM.sh in you terminal to install BAAL and all it dependencies. Once the installation is over, you can use your browser to acess BAAL web interface on localhost:8080.

##### Running the pipeline using the scripts :
if you don't want to use BAAL web interface, two other modes are available : the pipeline mode and the eval mode.
> Ajout d'un schéma avec les différents modes de BAAL

**Pipeline Mode:** ```_build/default/app/projetM2.exe pipeline --fq1 [PATH to R1 fastq] --fq2 [PATH to R2 fastq] --outdir [a PATH to outdir] ```
The available flags are :
```
	--fq1 PATH   	Path to forward reads -* Mandatory *-
	--fq2 PATH   	Path to reverse reads -* Mandatory *-
	--outdir PATH	Path to outdir directory -* Mandatory *-
	[--preview INT]  specify number of sample reads to test
	[-help]      	print this help text and exit (alias: -?)
```

**Run Eval Mode:** ```_build/default/app/projetM2.exe eval --outdir [a PATH to outdir]  ```
The available flags are :
```
	--outdir PATH	Path to outdir directory -* Mandatory *-
	[--preview INT]  number of sample reads (in thousand)
	[-help]      	print this help text and exit (alias: -?)
```

## Further information
**Dataset used to test BAAL :**
This pipeline was test with the Run [ERR1073432](https://www.ebi.ac.uk/ena/data/view/ERR1073432) of Escherichia coli str. K-12 substr. MG1655 from the European Nucleotide Archive.

**Dependancies :**
- [_opam_](https://opam.ocaml.org/) : package manager for OCaml.
- [_bistro_](https://github.com/pveber/bistro) : A library to build and execute typed scientific workflows.
- [_bistro_server_](https://github.com/pveber/bistro_server.git) : A simple server running bistro workflows.
- [_apt-transport-https_](https://packages.debian.org/en/jessie/apt-transport-https) : Enables the usage of 'deb https://foo distro main' lines in the /etc/apt/sources.list so that all package managers using the libapt-pkg library can access metadata and packages available in sources accessible over https.
- [_ca-certificates_](https://packages.debian.org/en/sid/ca-certificates) : Contains the certificate authorities shipped with Mozilla's browser to allow SSL-based applications to check for the authenticity of SSL connections.
- _curl_ : command line tool for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, TELNET and TFTP.
- _software-properties-common_ : Provides an abstraction of the used apt repositories. It allows you to easily manage your distribution and independent software vendor software sources.
- [_docker-ce_](https://docs.docker.com/)
- _m4_ : a macro processing language


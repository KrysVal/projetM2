# BAAL : Bistro Assembly Annotation Launcher
[Github repository](https://github.com/KrysVal/projetM2).

BAAL is bacterial genome assembly and annotation pipeline, based on the OCaml library [bistro](https://github.com/pveber/bistro). It also uses the library [bistro_server](https://github.com/pveber/bistro_server), which allows the pipeline to run in a web interface. This realease works only in a Linux environment. 

BAAL is an easy-to-use pipeline, which doesn't require major skills in informatics (only to be able to run a bash script in your terminal). Something you have to know before running BAAL, is that you don't need to install the packages and programs BAAL uses. It is automatics. As it runs, it will download docker images which will call the needed programs installed elsewhere. 

## The running modes
BAAL can run in three different modes : 
- Pipeline
- Eval
- Web

The pipeline mode allows you to perform a genome data analysis, including the assembly, evaluation of the assembly and genome annotation. The results will be saved in a repository "BAAL_results". This pipeline mode allows you tu run and use BAAL in command line. We don't recommend to use this mode if you don't have skills in informatics. 

The eval mode is, as its name suggests, an evaluation mode. It was created to evaluate the pipeline mode, and to verify if the results of the assembly and annotation were as expected using a reference genome. So you won't be likely to ever need to run BAAL in this mode. 

The web mode runs the analysis pipeline in your local server. It displays a user-friendly interface to upload your data and submit a job. 


## The pipeline
BAAL uses :
- SPADES (v3.9.1) for genome assembly
- QUAST (v4.3) to evaluate genome assembly
- PROKKA (v1.12) for genome annotation
- BLAST+ (v2.7.1) for genome annotation evaluation


## Getting started

There are two ways of running BAAL: in command line (local installation) or through the cloud (coming soon).

### Installation 

The following installation works for Ubuntu systems (14.04 and 16.04 have been tested)

#### Easy mode 

1. Clone the git repository : ```git clone https://github.com/KrysVal/projetM2```
2. Go to the repository : ```cd projetM2``` 
3. Launch the installation script : ```bash etc/install.sh```. It may take a while. If something goes wrong with this step, try the hardest solution below to see which step doesn't work. 

#### Hardest mode (detailled installation)

You can launch all installations steps one by one, following this : 
1. Update your apt repository : ```sudo apt update```
2. Install apt packages : opam, m4, apt-transport-https, curl, ca-certificates, software-properties-common
```
sudo apt install opam
sudo apt install m4
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
``` 
3. Install docker. You will have to add repository to apt. 
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce
```
4. Initialize opam and install ocaml packages : bistro, bistro_server, ocaml-vdom, projetM2 (this tool)
```
opam init -y --comp=4.05.0
eval `opam config env`
opam pin add -y bistro --dev-repo
opam pin add -y ocaml-vdom git://github.com/lexifi/ocaml-vdom.git
opam pin add -y bistro_server https://github.com/pveber/bistro_server.git
opam pin add -y projetM2 https://github.com/KrysVal/projetM2.git
```

See dependencies links if something goes wrong.  


### Start 

#### Web mode (easy, with web interface)

To access web mode, launch : ```projetM2 web --mem 4 --np 4 --port 8080 --root-dir BAAL_repo```. Then, you can use your browser to acess BAAL web interface on your localhost server (here localhost:8080). 

You can modify the different arguments if you want, The available flags are :
```
  --mem INT        memory used in GB
  --np INT         number of processors
  --port INT       name of port
  --root-dir PATH  path to root directory

```

#### Pipeline mode (command line usage)
After running the bash file, type the following command in your terminal in the same directory where you runned  **etc/install.sh** :  ```projetM2 pipeline --fq1 [PATH to R1 fastq] --fq2 [PATH to R2 fastq] --outdir [a PATH to outdir] ```

The available flags are :
```
    --fq1 PATH       Path to forward reads -* Mandatory *-
    --fq2 PATH       Path to reverse reads -* Mandatory *-
    --outdir PATH    Path to outdir directory -* Mandatory *-
    [--preview INT]  specify number of sample reads to test
    [-help]          print this help text and exit (alias: -?)
```

#### Eval Mode:
This mode is just if you want to check again if the pipeline works correctly with a reference dataset. 
```projetM2 eval --outdir [a PATH to outdir]  ```
The available flags are :
```
    --outdir PATH    Path to outdir directory -* Mandatory *-
    [--preview INT]  number of sample reads (in thousand)
    [-help]          print this help text and exit (alias: -?)
```

## Further information
**Dataset used to test BAAL :**
This pipeline was tested with the Run [ERR1073432](https://www.ebi.ac.uk/ena/data/view/ERR1073432) of Escherichia coli str. K-12 substr. MG1655 from the European Nucleotide Archive. 
The reference genome and protein sequences for evaluation are E.coli K12 sequences (accession number : GCF_000005845.2)

**Dependencies :**
- [_opam_](https://opam.ocaml.org/) : package manager for OCaml.
- [_bistro_](https://github.com/pveber/bistro) : A library to build and execute typed scientific workflows.
- [_utop_](https://github.com/diml/utop) :utop is an improved toplevel for OCaml. It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more. It integrates with the tuareg mode in Emacs.
- [_bistro_server_](https://github.com/pveber/bistro_server.git) : A simple server running bistro workflows.
- [_apt-transport-https_](https://packages.debian.org/en/jessie/apt-transport-https) : Enables the usage of 'deb https://foo distro main' lines in the /etc/apt/sources.list so that all package managers using the libapt-pkg library can access metadata and packages available in sources accessible over https.
- [_ca-certificates_](https://packages.debian.org/en/sid/ca-certificates) : Contains the certificate authorities shipped with Mozilla's browser to allow SSL-based applications to check for the authenticity of SSL connections.
- _curl_ : command line tool for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, TELNET and TFTP.
- _software-properties-common_ : Provides an abstraction of the used apt repositories. It allows you to easily manage your distribution and independent software vendor software sources.
- [_docker-ce_](https://docs.docker.com/)
- _m4_ : a macro processing language



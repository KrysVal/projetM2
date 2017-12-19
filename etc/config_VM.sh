apt update 
apt install opam
apt install m4
opam init -y --comp=4.05.0
#echo "~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> .bashrc
eval `opam config env`
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update
apt install docker-ce
opam pin add -y bistro --dev-repo
opam pin add -y ocaml-vdom git://github.com/lexifi/ocaml-vdom.git
opam pin add -y bistro_server https://github.com/pveber/bistro_server.git
opam pin add -y projetM2 https://github.com/KrysVal/projetM2.git
projetM2 web --mem 4 --np 4 --port 8080 --root-dir BAAL_repo
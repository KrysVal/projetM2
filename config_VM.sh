sudo apt update 
sudo apt install opam
opam init --comp=4.05.0
#echo "~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> .bashrc
eval `opam config env`
#opam install bistro utop
opam pin add -y bistro --dev-repo
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce
sudo apt-get install m4
opam update
opam upgrade
sudo usermod -aG docker $USER
opam pin add ocaml-vdom git://github.com/lexifi/ocaml-vdom.git
opam pin add bistro_server https://github.com/pveber/bistro_server.git
opam pin add projetM2 https://github.com/KrysVal/projetM2.git
projetM2 web --mem 4 --np 4 --port 8080 --root-dir BAAL_repo






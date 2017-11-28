sudo apt update 
sudo apt install opam
opam init --comp=4.05.0
echo "/home/etudiant/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> .bashrc
eval `opam config env`
sudo apt-get install m4
opam install bistro utop
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
sudo usermod -aG docker etudiant




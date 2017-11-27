sudo apt update 
sudo apt install opam
opam init --comp=4.05.0
echo "/home/etudiant/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> .bashrc
eval `opam config env`
opam install bistro utop
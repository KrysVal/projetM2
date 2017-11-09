# Test pipeline 

## 1. Assemblage 

* Utilisation de SPAdes (v3.11.1), paramètres par défaut 

* Données utilisées : ERR1073432 (séquençage paired-end Illumina HiSeq 2000 d'Escherichia coli K12 substr. MG1655) https://www.ebi.ac.uk/ena/data/view/ERR1073432

* Résultats : 175 contigs, 166 scaffolds 

## 2. Annotation 

* Utilisation de PROKKA (v1.12), paramètres par défaut

Prédiction faites par PROKKA (pour ce test) :  
- tRNA et tmRNA en utilisant Aragorn  
- rRNA avec Barrnap
- Recherche de répétitions CRISPR  
- Séquences codantes : prédictions de CDS avec Prodigal et alignement des CDS avec blastp contre les bases de données de références fournies par Prokka.  

**A faire** 

Comparer l'annotation obtenue à l'annotation de référence. Voir comment gérer le fait que les positions ne sont pas les mêmes puisqu'on a plusieurs contigs.  
*Test de BEACON en ligne qui n'a pas fonctionné*  

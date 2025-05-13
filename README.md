# Projet PATIA - Résolution de Problèmes

## 1. Hanoi

Pour resoudre l'exercice des Tours Hanoi avec trois diques en PDDL, j'ai implémenté dans le dossier hanoi:

- Un fichier domain : domain.pddl
- Un fichier problème : p001.pddl

### Les étapes à suivre pour le tester (trouver le plan) :

- On doit executer le fichier de lancement  qui se trouve dans le dossier racine du projet : ./pddl4j.sh

```
./pddl4j.sh
```

- Choisir 2 dans le menu pour FF
- Le fichier du domain

  ```
  ./hanoi/domain.pddl
  ```
- Le fichier du problème

  ```
  ./hanoi/p001.pddl
  ```
- Saisi 200 pour le timeout

## 2 - 0 . Taquin (sans PDDL)

### Description

Implémentation des algorithmes de recherche :

- BFS (Breadth-First Search)
- DFS (Depth-First Search)
- A* (A-Star)

### Structure

taquin/
├── benchmarks/          # Benchmarks générés
├── scripts/
│   ├── generate_npuzzle.py
│   ├── solve_npuzzle.py
│   └── performance_analysis.ipynb
└── README.md

### Utilisation

#### Génération des benchmarks :

```
python3 generate_npuzzle.py -s 3 -ml 10 -n 10 benchmarks -v
```

ou

```
python generate_npuzzle.py -s 3 -ml 10 -n 10 benchmarks -v
```

### Résolution avec algo bfs :

```python scripts/solve_npuzzle.py benchmarks/npuzzle_3x3_len1_0.txt -a bfs -v```

### Résolution avec algo dfs :

```python scripts/solve_npuzzle.py benchmarks/npuzzle_3x3_len1_0.txt -a dfs -v```

### Résolution avec algo astar :

```python scripts/solve_npuzzle.py benchmarks/npuzzle_3x3_len1_0.txt -a astar -v```

### Résolution des benchmarks de manières auto et stocker les résultats dans le fichier results.csv

```
cd n-puzzle
python3 benchmark_runner.py
```

#### Visualiser la courbe de la performance des algos

```
jupyter notebook visualize_benchmark.ipynb
```

NB : C'est pas encore complètement fonctionnel

## 2 - 1. Taquin en pddl

### Toujours dans le dossier n-puzzle :

- Le fichier domain : domain.pddl
- On génère les problèmes pddl depuis les benchmarks du dossier benchmarks dans le dossier pddl_problems en exécutant cette la commande :

  ```
  python3 generate_pddl_problems.py
  ```

  ou

  ```
  python generate_pddl_problems.py
  ```

### Pour tester avec pddl :

On se place dans le dossier racine du projet et exécuter la commande :

```
./pddl4j.sh
```

Puis on suit les étapes tout en choisissant l'option 2 qui est FF

- Le domain :

  ```
  ./n-puzzle/domain.pddl
  ```
- Un exemple de problèm :

  ```
  ./n-puzzle/pddl_problems/npuzzle_3x3_len1_0.pddl
  ```

Pour le timeout : 200

## 3. sokoban

Pour le sokoban, il faut se rendre dans le dossier sokoban

```
cd sokoban
```

### Structure du dossier sokoban (point essentiel)

sokoban/
├── config/          # les fichiers de configuration .json
├── src/
│   ├── main/

│   │   ├── java/

│   │   │   ├── sokoban/

│   │   │    │    ├── Agent.java                           # prend le plan (L,R,U,D) en args pour resoudre la partie

│   │   │    │    ├── Board.java

│    │   │    │    ├── Box.java

│    │   │    │    ├── Cell.java

│    │   │    │    ├── ParserJsonToPDDL.java          # permet de passer le .json en prob.pddl

│    │   │    │    ├── ParserPlanToString.java         # permet de passer les moveements en (L,R,U,D)

│    │   │    │    ├── SokobanMain.java                 # pour lancer le jeu (configuré pour re)

│    │   ├── resources/

│    │   │   ├── pddl_problems/                            # les prob.pddl générés par le ParserJsonToPDDL

│    │   │   ├── plansString/                                 # les plans.txt générés par le ParserPlanToString

│    │   │   ├── domain.pddl                                # le domain.pddl pour resoudre les prob.pddl générés

│    |    ├── test/
│   ├── temp_plan.txt

│   ├── lanceur.sh                                              # le script permettant de faire les manipulation
│   └── pom.xml                                                # contient les packages requis
└── README.md                                               # readme de base

### Processus de test

- 1- Lancer le scripte avec la commande depuis le dossier racine sokoban:

  - ```
    ./lanceur.sh
    ```
- 2- Compiler le projet

  - Choisir l'option 2 du menu puis 5 du sous-menu pour clean, compile et package
- 3- Générer un prob.pddl depuis json

  - Choisir l'option 2 menu principal
  - Puis saisir sur le terminal le nom du fichier à traduire avec .json (EX: test1.json) ces fichiers sont dans le dossier config
  - valider avec la touche ENTRER du clavier
  - le vifier est généré dans le dossier pddl_problems (voir la structure du dossier)
- 4- Choisir un planificateur dans le menu(1 pour HSP, 2 pour FF) si c'est 1 continuer choisir un
- 5-Saisir le temps d'exécution souhaiter en secondes (600 par defaut)
- 6- Suivre l'exécution, il va générer et afficher le plan puis lancer le serveur du jeu pour le web accessible dans cette url : http://localhost:4200/test.html


# 4. Sat

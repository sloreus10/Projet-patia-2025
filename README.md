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

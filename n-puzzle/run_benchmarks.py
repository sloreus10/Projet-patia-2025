import os
import subprocess
import json
import concurrent.futures

# Liste des algorithmes
algorithms = ['bfs', 'dfs', 'astar']

# Dictionnaire pour stocker les résultats
results = {algo: [] for algo in algorithms}

# Fonction pour exécuter un algorithme sur un benchmark
def run_algorithm(algo, benchmark):
    command = ['timeout', '5m', 'python3', 'solve_npuzzle.py', benchmark, '-a', algo, '-v']
    result = subprocess.run(command, capture_output=True, text=True)
    if 'Duration:' in result.stdout:
        duration = float(result.stdout.split('Duration:')[1].strip())
        return (benchmark, duration)
    else:
        return (benchmark, None)

# Fonction principale pour exécuter tous les algorithmes sur tous les benchmarks
def main():
    benchmark_dir = 'benchmarks'
    benchmarks = [os.path.join(benchmark_dir, f) for f in os.listdir(benchmark_dir) if f.endswith('.txt')]

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = []
        for algo in algorithms:
            for benchmark in benchmarks:
                futures.append(executor.submit(run_algorithm, algo, benchmark))

        for future in concurrent.futures.as_completed(futures):
            benchmark, duration = future.result()
            for algo in algorithms:
                if algo in benchmark:
                    results[algo].append({'benchmark': benchmark, 'duration': duration})

    # Enregistrer les résultats dans un fichier JSON
    with open('benchmark_results.json', 'w') as f:
        json.dump(results, f, indent=4)

if __name__ == '__main__':
    main()

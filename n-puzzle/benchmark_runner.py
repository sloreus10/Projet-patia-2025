import os
import csv
import time
import subprocess

ALGORITHMS = ['bfs', 'dfs', 'astar']
TIMEOUT = 300  # secondes = 5 minutes
BENCHMARK_DIR = 'benchmarks'
OUTPUT_CSV = 'results.csv'

def run_benchmark(file_path, algo):
    try:
        start = time.time()
        subprocess.run(
            ['timeout', f'{TIMEOUT}', 'python3', 'solve_npuzzle.py', file_path, '-a', algo],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True
        )
        duration = time.time() - start
        return round(duration, 4)
    except subprocess.CalledProcessError:
        return None

def main():
    with open(OUTPUT_CSV, 'w', newline='') as csvfile:
        fieldnames = ['benchmark', 'algorithm', 'time']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for benchmark in os.listdir(BENCHMARK_DIR):
            file_path = os.path.join(BENCHMARK_DIR, benchmark)
            if not file_path.endswith('.txt'):
                continue

            for algo in ALGORITHMS:
                print(f"Solving {benchmark} with {algo}...")
                t = run_benchmark(file_path, algo)
                writer.writerow({
                    'benchmark': benchmark,
                    'algorithm': algo,
                    'time': t if t is not None else 'timeout'
                })

if __name__ == '__main__':
    main()

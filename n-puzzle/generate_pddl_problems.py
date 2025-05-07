import os
from npuzzle import load_puzzle, create_goal

def generate_pddl_problem(puzzle, filename, size):
    goal = create_goal(size)
    tile_names = [chr(65 + i) for i in range(size * size - 1)]  # A, B, C, ...
    with open(filename, 'w') as f:
        f.write(f"(define (problem npuzzle_{size}x{size})\n")
        f.write(" (:domain npuzzle)\n")
        f.write(" (:objects\n")

        # Define tiles and positions
        positions = [f"p{i}" for i in range(size * size)]
        f.write("  " + " ".join(tile_names) + " - tile\n")
        f.write("  " + " ".join(positions) + " - position\n")
        f.write(" )\n")

        f.write(" (:init\n")
        for i, tile in enumerate(puzzle):
            if tile == 0:
                f.write(f"  (empty p{i})\n")
            else:
                f.write(f"  (at {tile_names[tile - 1]} p{i})\n")

        # Define adjacent positions
        for i in range(size * size):
            if i % size > 0:
                f.write(f"  (left p{i} p{i-1})\n")
                f.write(f"  (right p{i-1} p{i})\n")
            if i % size < size - 1:
                f.write(f"  (right p{i} p{i+1})\n")
                f.write(f"  (left p{i+1} p{i})\n")
            if i >= size:
                f.write(f"  (up p{i} p{i-size})\n")
                f.write(f"  (down p{i-size} p{i})\n")
            if i < size * (size - 1):
                f.write(f"  (down p{i} p{i+size})\n")
                f.write(f"  (up p{i+size} p{i})\n")

        f.write(" )\n")

        f.write(" (:goal\n  (and\n")
        for i, tile in enumerate(goal):
            if tile != 0:
                f.write(f"   (at {tile_names[tile - 1]} p{i})\n")
        f.write("  )\n")
        f.write(" )\n")
        f.write(")\n")

def main():
    benchmark_dir = 'benchmarks'
    pddl_dir = 'pddl_problems'
    os.makedirs(pddl_dir, exist_ok=True)

    for filename in os.listdir(benchmark_dir):
        if filename.endswith(".txt"):
            puzzle = load_puzzle(os.path.join(benchmark_dir, filename))
            size = int(filename.split('_')[1].split('x')[0])
            pddl_filename = os.path.join(pddl_dir, filename.replace(".txt", ".pddl"))
            generate_pddl_problem(puzzle, pddl_filename, size)
            print(f"Generated PDDL problem: {pddl_filename}")

if __name__ == '__main__':
    main()

from npuzzle import (Solution,
                     State,
                     Move,
                     UP,
                     DOWN,
                     LEFT,
                     RIGHT,
                     get_children,
                     is_goal,
                     is_solution,
                     load_puzzle,
                     to_string,
                     create_goal)
from node import Node
from typing import Literal, List, Dict, Tuple
import argparse
import math
import time
import copy

BFS = 'bfs'
DFS = 'dfs'
ASTAR = 'astar'

Algorithm = Literal['bfs', 'dfs', 'astar']

def solve_bfs(open: List[Node]) -> Solution:
    '''Solve the puzzle using the BFS algorithm'''
    dimension = int(math.sqrt(len(open[0].get_state())))
    moves = [UP, DOWN, LEFT, RIGHT]
    while open:
        node = open.pop(0)
        if is_goal(node.get_state()):
            return node.get_path()
        puzzle = node.get_state()
        k = node.cost
        children = get_children(puzzle, moves, dimension)
        for child in children:
            n = Node(state=child[0], move=child[1], parent=node, cost=k + 1)
            open.append(n)
    return []

def solve_dfs(open: List[Node]) -> Solution:
    '''Solve the puzzle using the DFS algorithm with iterative deepening'''
    def dls(node: Node, depth: int, dimension: int, visited: set) -> Solution:
        if is_goal(node.get_state()):
            return node.get_path()
        if depth == 0:
            return []

        visited.add(tuple(node.get_state()))
        puzzle = node.get_state()
        k = node.cost
        children = get_children(puzzle, [UP, DOWN, LEFT, RIGHT], dimension)

        for child in children:
            child_state = tuple(child[0])
            if child_state not in visited:
                n = Node(state=child[0], move=child[1], parent=node, cost=k + 1)
                result = dls(n, depth - 1, dimension, visited)
                if result:
                    return result
        return []

    dimension = int(math.sqrt(len(open[0].get_state())))
    root = open[0]
    max_depth = 50  # Ajustable selon la complexité du puzzle

    for current_depth in range(max_depth + 1):
        visited = set()
        result = dls(root, current_depth, dimension, visited)
        if result:
            return result

    return []

def solve_astar(open: List[Node], close: List[Node]) -> Solution:
    '''Solve the puzzle using the A* algorithm'''
    dimension = int(math.sqrt(len(open[0].get_state())))
    moves = [UP, DOWN, LEFT, RIGHT]
    while open:
        open.sort(key=lambda x: x.cost + x.heuristic)
        node = open.pop(0)
        close.append(node)
        if is_goal(node.get_state()):
            return node.get_path()
        puzzle = node.get_state()
        k = node.cost
        children = get_children(puzzle, moves, dimension)
        for child in children:
            n = Node(state=child[0], move=child[1], parent=node, cost=k + 1, heuristic=heuristic(child[0]))
            if n not in close and n not in open:
                open.append(n)
            elif n in open:
                existing_node = next(x for x in open if x == n)
                if n.cost < existing_node.cost:
                    open.remove(existing_node)
                    open.append(n)
    return []

def heuristic(state: State) -> int:
    '''Calculate the heuristic value of the puzzle'''
    dimension = int(math.sqrt(len(state)))
    goal = create_goal(dimension)
    distance = 0
    for i in range(len(state)):
        if state[i] != 0:
            current_pos = i
            goal_pos = state[i]
            current_row, current_col = divmod(current_pos, dimension)
            goal_row, goal_col = divmod(goal_pos, dimension)
            distance += abs(current_row - goal_row) + abs(current_col - goal_col)
    return distance

def main():
    parser = argparse.ArgumentParser(description='Load an n-puzzle and solve it.')
    parser.add_argument('filename', type=str, help='File name of the puzzle')
    parser.add_argument('-a', '--algo', type=str, choices=['bfs', 'dfs', 'astar'], required=True, help='Algorithm to solve the puzzle')
    parser.add_argument('-v', '--verbose', action='store_true', help='Increase output verbosity')

    args = parser.parse_args()

    puzzle = load_puzzle(args.filename)

    if args.verbose:
        print('Puzzle:\n')
        print(to_string(puzzle))

    if not is_goal(puzzle):
        root = Node(state=puzzle, move=None)
        open = [root]
        close = []  # Initialize the close list

        if args.algo == BFS:
            print('BFS\n')
            start_time = time.time()
            solution = solve_bfs(open)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
            else:
                print('No solution')
        elif args.algo == DFS:
            print('DFS\n')
            start_time = time.time()
            solution = solve_dfs(open)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
            else:
                print('No solution')
        elif args.algo == ASTAR:
            print('A*\n')
            start_time = time.time()
            solution = solve_astar(open, close)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
            else:
                print('No solution')
    else:
        print('Puzzle is already solved')

if __name__ == '__main__':
    main()

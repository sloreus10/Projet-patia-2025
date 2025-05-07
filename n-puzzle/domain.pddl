;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : N-Puzzle     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine N-Puzzle
(define (domain npuzzle)
    (:requirements :strips :typing)
    (:types tile position)

    (:predicates
        (at ?t - tile ?p - position)
        (empty ?p - position)
        (adjacent ?p1 - position ?p2 - position)
        (up ?p1 - position ?p2 - position)
        (down ?p1 - position ?p2 - position)
        (left ?p1 - position ?p2 - position)
        (right ?p1 - position ?p2 - position)
    )

    (:action move_up
        :parameters (?t - tile ?from - position ?to - position)
        :precondition (and (at ?t ?from) (empty ?to) (up ?from ?to))
        :effect (and (at ?t ?to) (empty ?from) (not (at ?t ?from)) (not (empty ?to)))
    )

    (:action move_down
        :parameters (?t - tile ?from - position ?to - position)
        :precondition (and (at ?t ?from) (empty ?to) (down ?from ?to))
        :effect (and (at ?t ?to) (empty ?from) (not (at ?t ?from)) (not (empty ?to)))
    )

    (:action move_left
        :parameters (?t - tile ?from - position ?to - position)
        :precondition (and (at ?t ?from) (empty ?to) (left ?from ?to))
        :effect (and (at ?t ?to) (empty ?from) (not (at ?t ?from)) (not (empty ?to)))
    )

    (:action move_right
        :parameters (?t - tile ?from - position ?to - position)
        :precondition (and (at ?t ?from) (empty ?to) (right ?from ?to))
        :effect (and (at ?t ?to) (empty ?from) (not (at ?t ?from)) (not (empty ?to)))
    )
)

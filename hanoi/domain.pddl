;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine Hanoi
(define (domain hanoi)
    (:requirements :strips :typing)
    (:types object stack)
    (:predicates
        (on ?x - object ?y - object)
        (onstack ?x - object ?p - stack)
        (clear ?x - object)
        (handempty)
        (holding ?x - object)
        (smaller ?x - object ?y - object)
    )
    (:action pick-up
        :parameters (?x - object ?p - stack)
        :precondition (and (clear ?x) (onstack ?x ?p) (handempty))
        :effect (and (holding ?x) (clear ?p) (not (clear ?x)) (not (handempty)) (not (onstack ?x ?p)))
    )
    (:action put-down
        :parameters (?x - object ?p - stack)
        :precondition (and (holding ?x) (clear ?p))
        :effect (and (not (holding ?x)) (not (clear ?p)) (clear ?x) (handempty) (onstack ?x ?p))
    )
    (:action stack
        :parameters (?x - object ?y - object)
        :precondition (and (holding ?x) (clear ?y) (smaller ?x ?y))
        :effect (and (not (holding ?x)) (not (clear ?y)) (clear ?x) (handempty) (on ?x ?y))
    )
    (:action unstack
        :parameters (?x - object ?y - object)
        :precondition (and (clear ?x) (on ?x ?y) (handempty))
        :effect (and (not (on ?x ?y)) (not (clear ?x)) (not (handempty)) (holding ?x) (clear ?y))
    )
)

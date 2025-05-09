;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine Hanoi
(define (domain hanoi)
    (:requirements :strips :typing) ; Requiert STRIPS et le typage
    (:types object stack) ; Déclaration des types : objet et pile

    ; Prédicats utilisés pour décrire l'état du monde
    (:predicates
        (on ?x - object ?y - object) ; ?x est posé sur ?y
        (onstack ?x - object ?p - stack) ; ?x est sur la pile ?p
        (clear ?x - object) ; Le dessus de ?x est libre (rien dessus)
        (handempty) ; La main est vide
        (holding ?x - object) ; L'objet ?x est tenu
        (smaller ?x - object ?y - object) ; ?x est plus petit que ?y
    )

    ; Action : prendre un objet sur une pile
    (:action pick-up
        :parameters (?x - object ?p - stack)
        :precondition (and (clear ?x) (onstack ?x ?p) (handempty))
        :effect (and (holding ?x) (clear ?p) (not (clear ?x)) (not (handempty)) (not (onstack ?x ?p)))
    )

    ; Action : poser un objet sur une pile
    (:action put-down
        :parameters (?x - object ?p - stack)
        :precondition (and (holding ?x) (clear ?p))
        :effect (and (not (holding ?x)) (not (clear ?p)) (clear ?x) (handempty) (onstack ?x ?p))
    )

    ; Action : empiler un objet sur un autre objet
    (:action stack
        :parameters (?x - object ?y - object)
        :precondition (and (holding ?x) (clear ?y) (smaller ?x ?y))
        :effect (and (not (holding ?x)) (not (clear ?y)) (clear ?x) (handempty) (on ?x ?y))
    )

    ; Action : retirer un objet qui est sur un autre
    (:action unstack
        :parameters (?x - object ?y - object)
        :precondition (and (clear ?x) (on ?x ?y) (handempty))
        :effect (and (not (on ?x ?y)) (not (clear ?x)) (not (handempty)) (holding ?x) (clear ?y))
    )
)

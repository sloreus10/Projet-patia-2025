;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Hanoi avec 3 disques
(define (problem hanoi_3_disques)
    (:domain hanoi)
    (:objects
        XL L S - object
        left middle right - stack
    )
    (:init
        (smaller S L)
        (smaller S XL)
        (smaller L XL)
        (onstack XL left)
        (on L XL)
        (on S L)
        (clear S)
        (clear middle)
        (clear right)
        (handempty)
    )
    (:goal
        (and
            (onstack XL right)
            (on L XL)
            (on S L)
        )
    )
)

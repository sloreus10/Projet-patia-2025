;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 2 : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Hanoi avec 4 disques
(define (problem hanoi_4_disques)
    (:domain hanoi)
    (:objects
        XL L M S - object
        left middle right - stack
    )
    (:init
        (smaller S L)
        (smaller S M)
        (smaller S XL)
        (smaller M L)
        (smaller M XL)
        (smaller L XL)
        (onstack XL left)
        (on L XL)
        (on M L)
        (on S M)
        (clear S)
        (clear middle)
        (clear right)
        (handempty)
    )
    (:goal
        (and
            (onstack XL right)
            (on L XL)
            (on M L)
            (on S M)
        )
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 3 : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Hanoi avec 5 disques
(define (problem hanoi_5_disques)
    (:domain hanoi)
    (:objects
        XL L M S XS - object
        left middle right - stack
    )
    (:init
        (smaller XS S)
        (smaller XS L)
        (smaller XS M)
        (smaller XS XL)
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
        (on XS S)
        (clear XS)
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
            (on XS S)
        )
    )
)
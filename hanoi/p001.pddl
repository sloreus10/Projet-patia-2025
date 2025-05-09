;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Hanoi avec 3 disques
(define (problem hanoi_3_disques)
    (:domain hanoi)
    (:objects
        XL L S - object ; Disques : Très grand(XL), Grand(L), Petit(S)
        left middle right - stack ; Piles : gauche, milieu, droite
    )
    (:init ; État initial
        (smaller S L)
        (smaller S XL)
        (smaller L XL)
        (onstack XL left) ; XL est sur la pile gauche
        (on L XL) ; L est sur XL
        (on S L) ; S est sur L
        (clear S) ; S est libre
        (clear middle) ; La pile du milieu est libre
        (clear right) ; La pile de droite est libre
        (handempty) ; La main est vide
    )
    (:goal ; Objectif final
        (and
            (onstack XL right) ; XL est sur la pile droite
            (on L XL) ; L est sur XL
            (on S L) ; S est sur L
        )
    )
)

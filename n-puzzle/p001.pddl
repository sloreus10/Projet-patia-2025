;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : NPuzzle     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème NPuzzle
(define (problem npuzzle_probleme)

    ; Definition du domaine utilisé : "NPuzzle"
    (:domain NPuzzle)

    ; Définition des objets utilisés
    (:objects
        
        ; Un_Un, Un_Deux, Un_Trois, Deux_Un, Deux_Deux, Deux_Trois, Trois_Un, Trois_Deux et Trois_Trois sont des positions
        Un_Un Un_Deux Un_Trois Deux_Un Deux_Deux Deux_Trois Trois_Un Trois_Deux Trois_Trois - position
        
        ; tuile_A, tuile_B, tuile_C, tuile_D, tuile_E, tuile_F, tuile_G, tuile_H et libre sont des tuiles
        tuile_A tuile_B tuile_C tuile_D tuile_E tuile_F tuile_G tuile_H - tuile
    )

    ; Initialisation du problème NPuzzle
    ;
    ;
    ; Les tuiles sont dans la configuration suivante :
    ;
    ;        1     2     3   
    ;     +-----+-----+-----+
    ;  1  | TuA | TuB | TuF |
    ;     +-----+-----+-----+
    ;  2  | TuG | TuC | TuD |
    ;     +-----+-----+-----+
    ;  3  | Lib | TuE | TuH |
    ;     +-----+-----+-----+
    ;
    ;
    (:init
        
        ; La tuile "tuile_A" est positionnee à la position "Un_Un"
        (positionnee Un_Un tuile_A)

        ; La tuile "tuile_B" est positionnee à la position "Un_Deux"
        (positionnee Un_Deux tuile_B)

        ; La tuile "tuile_F" est positionnee à la position "Un_Trois"
        (positionnee Un_Trois tuile_F)

        ; La tuile "tuile_G" est positionnee à la position "Deux_Un"
        (positionnee Deux_Un tuile_G)

        ; La tuile "tuile_C" est positionnee à la position "Deux_Deux"
        (positionnee Deux_Deux tuile_C)

        ; La tuile "tuile_D" est positionnee à la position "Deux_Trois"
        (positionnee Deux_Trois tuile_D)

        ; La tuile "libre" est positionnee à la position "Trois_Un"
        (positionnee Trois_Un libre)

        ; La tuile "tuile_E" est positionnee à la position "Trois_Deux"
        (positionnee Trois_Deux tuile_E)

        ; La tuile "tuile_H" est positionnee à la position "Trois_Trois"
        (positionnee Trois_Trois tuile_H)

        ; Definition des mouvements possibles pour chaque tuile
        ; Deplacement de la tuile A : vers la droite ou vers le bas
        (permuter Un_Un Un_Deux)
        (permuter Un_Un Deux_Un)
        
        ; Deplacement de la tuile B : vers la gauche, la droite ou vers le bas
        ; (permuter Un_Deux Un_Un) deja fait dans le cas de la tuile A
        (permuter Un_Deux Un_Trois)
        (permuter Un_Deux Deux_Deux)

        ; Deplacement de la tuile F : vers la gauche ou vers le bas
        (permuter Un_Trois Un_Deux)
        (permuter Un_Trois Deux_Trois)

        ; Deplacement de la tuile G : vers le haut, la droite ou vers le bas
        ; (permuter Deux_Un Un_Un) deja fait dans le cas de la tuile A
        (permuter Deux_Un Deux_Deux)
        (permuter Deux_Un Trois_Un)

        ; Deplacement de la tuile C : vers le haut, la gauche, la droite ou vers le bas
        ; (permuter Deux_Deux Un_Deux) deja fait dans le cas de la tuile B
        ; (permuter Deux_Deux Deux_Un) deja fait dans le cas de la tuile G
        (permuter Deux_Deux Deux_Trois)
        (permuter Deux_Deux Trois_Deux)

        ; Deplacement de la tuile D : vers le haut, la gauche ou vers le bas
        ; (permuter Deux_Trois Un_Trois) deja fait dans le cas de la tuile F
        ; (permuter Deux_Trois Deux_Deux) deja fait dans le cas de la tuile C
        (permuter Deux_Trois Trois_Trois)

        ; Deplacement de la tuile libre : vers le haut ou vers la droite
        ; (permuter Trois_Un Deux_Un) deja fait dans le cas de la tuile G
        (permuter Trois_Un Trois_Deux)
        
        ; Deplacement de la tuile E : vers le haut, la gauche ou vers la droite
        ; (permuter Trois_Deux Deux_Deux) deja fait dans le cas de la tuile C
        ; (permuter Trois_Deux Trois_Un) deja fait dans le cas de la tuile libre
        (permuter Trois_Deux Trois_Trois)

        ; Deplacement de la tuile H : vers le haut ou vers la gauche
        ; (permuter Trois_Trois Deux_Trois) deja fait dans le cas de la tuile D
        ; (permuter Trois_Trois Trois_Deux) deja fait dans le cas de la tuile E
    )

    ; But Final du problème NPuzzle
    ;
    ;
    ; Les tuiles sont dans la configuration suivante :
    ;
    ;        1     2     3   
    ;     +-----+-----+-----+
    ;  1  | TuA | TuB | TuC |
    ;     +-----+-----+-----+
    ;  2  | TuD | TuE | TuF |
    ;     +-----+-----+-----+
    ;  3  | TuG | TuH | Lib |
    ;     +-----+-----+-----+
    ;
    ;
    (:goal

        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            
            ; La tuile "tuile_A" est positionnee à la position "Un_Un"
            (positionnee Un_Un tuile_A)

            ; La tuile "tuile_B" est positionnee à la position "Un_Deux"
            (positionnee Un_Deux tuile_B)

            ; La tuile "tuile_C" est positionnee à la position "Un_Trois"
            (positionnee Un_Trois tuile_C)

            ; La tuile "tuile_D" est positionnee à la position "Deux_Un"
            (positionnee Deux_Un tuile_D)

            ; La tuile "tuile_E" est positionnee à la position "Deux_Deux"
            (positionnee Deux_Deux tuile_E)

            ; La tuile "tuile_F" est positionnee à la position "Deux_Trois"
            (positionnee Deux_Trois tuile_F)

            ; La tuile "tuile_G" est positionnee à la position "Trois_Un"
            (positionnee Trois_Un tuile_G)

            ; La tuile "tuile_H" est positionnee à la position "Trois_Deux"
            (positionnee Trois_Deux tuile_H)

            ; La tuile "libre" est positionnee à la position "Trois_Trois"
            (positionnee Trois_Trois libre)
        )
    )
)
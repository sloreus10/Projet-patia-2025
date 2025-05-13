(define (domain sokoban)
    (:requirements :strips :typing :negative-preconditions :conditional-effects)
    (:types
        position
    )

    (:predicates
        (has_player ?p - position)
        (has_box ?p - position)
        (is_target ?p - position)
        (free ?p - position)
        (wall ?p - position)
        (adjacent ?from ?to - position)
        (boiteSurCible ?p - position)
    )

    ;; Déplacement du joueur vers une case vide
    (:action move-player
        :parameters (?from ?to - position)
        :precondition (and
            (has_player ?from)
            (adjacent ?from ?to)
            (free ?to)
            (not (has_box ?to))
            (not (wall ?to))
        )
        :effect (and
            (not (has_player ?from))
            (has_player ?to)
            (free ?from)
            (not (free ?to))
        )
    )

    ;; Pousser une boîte d’une case vers une autre (en face du joueur)
    (:action push-box
        :parameters (?p1 ?p2 ?p3 - position)
        :precondition (and
            (has_player ?p1)
            (has_box ?p2)
            (adjacent ?p1 ?p2)
            (adjacent ?p2 ?p3)
            (free ?p3)
            (not (has_box ?p3))
            (not (wall ?p3))
        )
        :effect (and
            (not (has_player ?p1))
            (has_player ?p2)

            (not (has_box ?p2))
            (has_box ?p3)

            (free ?p1)
            (not (free ?p2))
            (not (free ?p3))

            (when
                (is_target ?p2)
                (not (boiteSurCible ?p2)))
            (when
                (is_target ?p3)
                (boiteSurCible ?p3))
        )
    )

)
(define (problem problemSokoban)
(:domain sokoban)
(:objects a1 - agent
    e1 - sol
    e2 - sol
    e3 - sol
    e4 - sol
    e5 - sol
    e6 - sol
    e7 - sol
    e8 - sol
    c1 - sol
    c2 - sol
    b1 - boite
    b2 - boite
)
(:init  (aVoisinDroit e1 e2)
        (aVoisinDroit e3 e4)
        (aVoisinDroit e8 e3)
        (aVoisinDroit c1 c2)
        (aVoisinDroit e5 c1)
        (aVoisinHaut e7 e6)
        (aVoisinHaut e6 e5)
        (aVoisinHaut e5 e4)
        (aVoisinHaut c1 e3)
        (aVoisinHaut e5 e8)
        (aVoisinHaut e4 e2)
        (aVoisinHaut e3 e1)
        (estDestination c1)
        (estDestination c2)
        (agentEstSur a1 e7)
        (boiteEstSur b1 e3)
        (boiteEstSur b2 c1)
        (estLibre e1)
        (estLibre e2)
        (estLibre e4)
        (estLibre e5)
        (estLibre e6)
        (estLibre e7)
        (estLibre e8)
        (estLibre c2)
)

(:goal (and (boiteSurCible b1)
            (boiteSurCible b2))
)

)
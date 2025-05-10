;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sokoban
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain sokoban)

(:requirements :strips :typing)
(:types sol
        boite
        agent)
(:predicates
    (boiteEstSur ?boite - boite ?sol - sol)     ;boiteEstSur : Spécifie que la boite ?boite est sur le sol ?sol
    (agentEstSur ?agent - agent ?sol - sol)     ;agentEstSur : Spécifie que l'agent ?agent est sur le sol ?sol
    (aVoisinDroit ?x - sol ?y - sol)            ;aVoisinDroit : Spécifie que le sol ?y est à droite du sol ?x (indirectement le sol ?x est à gauche du sol ?y)
    (aVoisinHaut ?x - sol ?y - sol)             ;aVoisinHaut : Spécifie que le sol ?y est en haut du sol ?x (indirectement le sol ?x est en bas du sol ?y)
    (estDestination ?sol - sol)                 ;estDestination : Marque le sol ?sol comme étant une destination à atteindre par les boites
    (boiteSurCible ?boite - boite)              ;boiteSurCible : Spécifie que la boite ?boite est sur un sol de destination
    (estLibre ?sol - sol)                       ;estLibre : Spécifie que le sol ?sol est libre
)

;deplacementDroit : Déplace l'agent ?agent1 à droite, du sol ?env1 vers le sol ?env2
(:action deplacementDroit
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and (aVoisinDroit ?env1 ?env2) (agentEstSur ?agent1 ?env1) (estLibre ?env2))
    :effect (and (agentEstSur ?agent1 ?env2) (not (agentEstSur ?agent1 ?env1)))
)

;deplacementHaut : Déplace l'agent ?agent1 en haut, du sol ?env1 vers le sol ?env2
(:action deplacementHaut
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and (agentEstSur ?agent1 ?env1) (aVoisinHaut ?env1 ?env2) (estLibre ?env2))
    :effect (and (agentEstSur ?agent1 ?env2) (not (agentEstSur ?agent1 ?env1)))
)

;deplacementGauche : Déplace l'agent ?agent1 à gauche, du sol ?env1 vers le sol ?env2
(:action deplacementGauche
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and (agentEstSur ?agent1 ?env1) (aVoisinDroit ?env2 ?env1) (estLibre ?env2))
    :effect (and (agentEstSur ?agent1 ?env2) (not (agentEstSur ?agent1 ?env1)))
)

;deplacementBas : Déplace l'agent ?agent1 en bas, du sol ?env1 vers le sol ?env2
(:action deplacementBas
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and (agentEstSur ?agent1 ?env1) (aVoisinHaut ?env2 ?env1) (estLibre ?env2))
    :effect (and (agentEstSur ?agent1 ?env2) (not (agentEstSur ?agent1 ?env1)))
)

;pousserDroit : L'agent ?agent pousse la boite ?boite à droite, se déplaçant du sol ?env1 vers ?env2 pour pousser la boite ?boite s'y trouvant, du sol ?env2 vers ?env3
(:action pousserDroit
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and (agentEstSur ?agent ?env1) (boiteEstSur ?boite ?env2) (aVoisinDroit ?env1 ?env2) (aVoisinDroit ?env2 ?env3) (estLibre ?env3))
    :effect (and (boiteEstSur ?boite ?env3) (not(boiteEstSur ?boite ?env2)) (agentEstSur ?agent ?env2) (not(agentEstSur ?agent ?env1)) (not (boiteSurCible ?boite)) (estLibre ?env2) (not (estLibre ?env3)))
)

;pousserHaut : L'agent ?agent pousse la boite ?boite en haut, se déplaçant du sol ?env1 vers ?env2 pour pousser la boite ?boite s'y trouvant, du sol ?env2 vers ?env3
(:action pousserHaut
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and (agentEstSur ?agent ?env1) (boiteEstSur ?boite ?env2) (aVoisinHaut ?env1 ?env2) (aVoisinHaut ?env2 ?env3) (estLibre ?env3))
    :effect (and (boiteEstSur ?boite ?env3) (not(boiteEstSur ?boite ?env2)) (agentEstSur ?agent ?env2) (not(agentEstSur ?agent ?env1)) (not (boiteSurCible ?boite)) (estLibre ?env2) (not (estLibre ?env3)))
)

;pousserGauche : L'agent ?agent pousse la boite ?boite à gauche, se déplaçant du sol ?env1 vers ?env2 pour pousser la boite ?boite s'y trouvant, du sol ?env2 vers ?env3
(:action pousserGauche
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and (agentEstSur ?agent ?env1) (boiteEstSur ?boite ?env2) (aVoisinDroit ?env2 ?env1) (aVoisinDroit ?env3 ?env2) (estLibre ?env3))
    :effect (and (boiteEstSur ?boite ?env3) (not(boiteEstSur ?boite ?env2)) (agentEstSur ?agent ?env2) (not(agentEstSur ?agent ?env1)) (not (boiteSurCible ?boite)) (estLibre ?env2) (not (estLibre ?env3)))
)

;pousserBas : L'agent ?agent pousse la boite ?boite en bas, se déplaçant du sol ?env1 vers ?env2 pour pousser la boite ?boite s'y trouvant, du sol ?env2 vers ?env3
(:action pousserBas
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and (agentEstSur ?agent ?env1) (boiteEstSur ?boite ?env2) (aVoisinHaut ?env2 ?env1) (aVoisinHaut ?env3 ?env2) (estLibre ?env3))
    :effect (and (boiteEstSur ?boite ?env3) (not(boiteEstSur ?boite ?env2)) (agentEstSur ?agent ?env2) (not(agentEstSur ?agent ?env1)) (not (boiteSurCible ?boite)) (estLibre ?env2) (not (estLibre ?env3)))
)

;marquer : Marque la boite ?boite si le sol ?sol sur lequel elle se trouve est une destination
(:action marquer
    :parameters (?boite - boite ?sol - sol)
    :precondition (and (boiteEstSur ?boite ?sol) (estDestination ?sol))
    :effect (and (boiteSurCible ?boite))
)
)

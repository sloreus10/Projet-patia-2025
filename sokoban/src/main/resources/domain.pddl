;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Domaine PDDL : Sokoban
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain sokoban)

  ;; On utilise STRIPS (base), typing (types d'objets), equality (égalité si besoin), et negative-preconditions
  (:requirements :strips :typing :equality :negative-preconditions)

  ;; Définition des types d'objets
  (:types
    sol      ;; case du sol
    boite    ;; boîte à déplacer
    agent    ;; le joueur (Sokoban)
  )

  ;; Déclaration des prédicats
  (:predicates
    ;; La boîte ?boite est sur la case ?sol
    (boite_est_sur ?boite - boite ?sol - sol)

    ;; L’agent est sur la case ?sol
    (agent_est_sur ?agent - agent ?sol - sol)

    ;; La case ?x a comme voisin à droite la case ?y
    (a_voisin_droit ?x - sol ?y - sol)

    ;; La case ?x a comme voisin au-dessus la case ?y
    (a_voisin_haut ?x - sol ?y - sol)

    ;; La case ?sol est une destination cible
    (est_destination ?sol - sol)

    ;; La boîte ?boite est placée sur une case cible
    (boite_sur_cible ?boite - boite)

    ;; La case ?sol est libre (pas d’agent ni de boîte)
    (est_libre ?sol - sol)

    ;; La case ?sol est un mur
    (est_mur ?sol - sol)
  )

  ;; Déplacement vers la droite
  (:action deplacement_droit
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and
      (a_voisin_droit ?env1 ?env2)      ;; Vérifie si ?env2 est à droite de ?env1
      (agent_est_sur ?agent1 ?env1)    ;; Vérifie si l'agent est sur la case ?env1
      (est_libre ?env2)                ;; Vérifie si la case ?env2 est libre
      (not (est_mur ?env2)))           ;; Vérifie si la case ?env2 n'est pas un mur
    :effect (and
      (agent_est_sur ?agent1 ?env2)     ;; Déplace l'agent vers la case ?env2
      (not (agent_est_sur ?agent1 ?env1)) ;; L'agent n'est plus sur ?env1
      (not (est_libre ?env2))           ;; La case ?env2 n'est plus libre
      (est_libre ?env1))                ;; La case ?env1 devient libre
  )

  ;; Déplacement vers le haut
  (:action deplacement_haut
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and
      (a_voisin_haut ?env1 ?env2)      ;; Vérifie si ?env2 est au-dessus de ?env1
      (agent_est_sur ?agent1 ?env1)    ;; Vérifie si l'agent est sur la case ?env1
      (est_libre ?env2)                ;; Vérifie si la case ?env2 est libre
      (not (est_mur ?env2)))           ;; Vérifie si la case ?env2 n'est pas un mur
    :effect (and
      (agent_est_sur ?agent1 ?env2)     ;; Déplace l'agent vers la case ?env2
      (not (agent_est_sur ?agent1 ?env1)) ;; L'agent n'est plus sur ?env1
      (not (est_libre ?env2))           ;; La case ?env2 n'est plus libre
      (est_libre ?env1))                ;; La case ?env1 devient libre
  )

  ;; Déplacement vers la gauche
  (:action deplacement_gauche
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and
      (a_voisin_droit ?env2 ?env1)      ;; Vérifie si ?env2 est à gauche de ?env1
      (agent_est_sur ?agent1 ?env1)    ;; Vérifie si l'agent est sur la case ?env1
      (est_libre ?env2)                ;; Vérifie si la case ?env2 est libre
      (not (est_mur ?env2)))           ;; Vérifie si la case ?env2 n'est pas un mur
    :effect (and
      (agent_est_sur ?agent1 ?env2)     ;; Déplace l'agent vers la case ?env2
      (not (agent_est_sur ?agent1 ?env1)) ;; L'agent n'est plus sur ?env1
      (not (est_libre ?env2))           ;; La case ?env2 n'est plus libre
      (est_libre ?env1))                ;; La case ?env1 devient libre
  )

  ;; Déplacement vers le bas
  (:action deplacement_bas
    :parameters (?agent1 - agent ?env1 - sol ?env2 - sol)
    :precondition (and
      (a_voisin_haut ?env2 ?env1)      ;; Vérifie si ?env2 est en dessous de ?env1
      (agent_est_sur ?agent1 ?env1)    ;; Vérifie si l'agent est sur la case ?env1
      (est_libre ?env2)                ;; Vérifie si la case ?env2 est libre
      (not (est_mur ?env2)))           ;; Vérifie si la case ?env2 n'est pas un mur
    :effect (and
      (agent_est_sur ?agent1 ?env2)     ;; Déplace l'agent vers la case ?env2
      (not (agent_est_sur ?agent1 ?env1)) ;; L'agent n'est plus sur ?env1
      (not (est_libre ?env2))           ;; La case ?env2 n'est plus libre
      (est_libre ?env1))                ;; La case ?env1 devient libre
  )

  ;; Pousser une boîte vers la droite
  (:action pousser_droit
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and
      (agent_est_sur ?agent ?env1)       ;; L'agent est sur ?env1
      (boite_est_sur ?boite ?env2)       ;; La boîte est sur ?env2
      (a_voisin_droit ?env1 ?env2)       ;; ?env2 est à droite de ?env1
      (a_voisin_droit ?env2 ?env3)       ;; ?env3 est à droite de ?env2
      (est_libre ?env3)                 ;; ?env3 est libre pour accueillir la boîte
      (not (est_mur ?env3)))            ;; Vérifie si la case ?env3 n'est pas un mur
    :effect (and
      (boite_est_sur ?boite ?env3)       ;; Déplace la boîte vers ?env3
      (not (boite_est_sur ?boite ?env2)) ;; La boîte n'est plus sur ?env2
      (agent_est_sur ?agent ?env2)       ;; Déplace l'agent sur ?env2
      (not (agent_est_sur ?agent ?env1)) ;; L'agent n'est plus sur ?env1
      (not (est_libre ?env3))            ;; ?env3 n'est plus libre
      (est_libre ?env2)                  ;; ?env2 devient libre
      (est_libre ?env1))                 ;; ?env1 devient libre
  )

  ;; Pousser une boîte vers le haut
  (:action pousser_haut
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and
      (agent_est_sur ?agent ?env1)
      (boite_est_sur ?boite ?env2)
      (a_voisin_haut ?env1 ?env2)
      (a_voisin_haut ?env2 ?env3)
      (est_libre ?env3)
      (not (est_mur ?env3)))
    :effect (and
      (boite_est_sur ?boite ?env3)
      (not (boite_est_sur ?boite ?env2))
      (agent_est_sur ?agent ?env2)
      (not (agent_est_sur ?agent ?env1))
      (not (est_libre ?env3))
      (est_libre ?env2)
      (est_libre ?env1))
  )

  ;; Pousser une boîte vers la gauche
  (:action pousser_gauche
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and
      (agent_est_sur ?agent ?env1)
      (boite_est_sur ?boite ?env2)
      (a_voisin_droit ?env2 ?env1)
      (a_voisin_droit ?env3 ?env2)
      (est_libre ?env3)
      (not (est_mur ?env3)))
    :effect (and
      (boite_est_sur ?boite ?env3)
      (not (boite_est_sur ?boite ?env2))
      (agent_est_sur ?agent ?env2)
      (not (agent_est_sur ?agent ?env1))
      (not (est_libre ?env3))
      (est_libre ?env2)
      (est_libre ?env1))
  )

  ;; Pousser une boîte vers le bas
  (:action pousser_bas
    :parameters (?agent - agent ?env1 - sol ?env2 - sol ?env3 - sol ?boite - boite)
    :precondition (and
      (agent_est_sur ?agent ?env1)
      (boite_est_sur ?boite ?env2)
      (a_voisin_haut ?env2 ?env1)
      (a_voisin_haut ?env3 ?env2)
      (est_libre ?env3)
      (not (est_mur ?env3)))
    :effect (and
      (boite_est_sur ?boite ?env3)
      (not (boite_est_sur ?boite ?env2))
      (agent_est_sur ?agent ?env2)
      (not (agent_est_sur ?agent ?env1))
      (not (est_libre ?env3))
      (est_libre ?env2)
      (est_libre ?env1))
  )

  ;; Marquer une boîte comme placée sur une cible
  (:action marquer
    :parameters (?boite - boite ?sol - sol)
    :precondition (and
      (boite_est_sur ?boite ?sol)        ;; Vérifie si la boîte est sur la case cible
      (est_destination ?sol))            ;; Vérifie si ?sol est une destination
    :effect (boite_sur_cible ?boite)    ;; Marque la boîte comme placée sur la cible
  )
)

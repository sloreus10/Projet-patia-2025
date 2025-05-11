;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Domaine PDDL : Sokoban
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain sokoban)

  ;; On utilise STRIPS (base), typing (types d'objets) et equality (égalité si besoin)
  (:requirements :strips :typing :equality)

  ;; Définition des types d'objets
  (:types
    sol      ;; case du sol
    boite    ;; boîte à déplacer
    agent    ;; le joueur (Sokoban)
  )

  ;; Déclaration des prédicats
  (:predicates
    ;; La boîte ?b est sur la case ?s
    (boite_est_sur ?b - boite ?s - sol)

    ;; L’agent est sur la case ?s
    (agent_est_sur ?a - agent ?s - sol)

    ;; La case ?x a comme voisin à droite la case ?y
    (a_voisin_droit ?x - sol ?y - sol)

    ;; La case ?x a comme voisin au-dessus la case ?y
    (a_voisin_haut ?x - sol ?y - sol)

    ;; La case ?s est une destination cible
    (est_destination ?s - sol)

    ;; La boîte ?b est placée sur une case cible
    (boite_sur_cible ?b - boite)

    ;; La case ?s est libre (pas d’agent ni de boîte)
    (est_libre ?s - sol)
  )

  ;; Déplacement vers la droite
  (:action deplacement_droit
    :parameters (?a - agent ?s1 - sol ?s2 - sol)
    :precondition (and
      (a_voisin_droit ?s1 ?s2)
      (agent_est_sur ?a ?s1)
      (est_libre ?s2))
    :effect (and
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s2))
      (est_libre ?s1))
  )

  ;; Déplacement vers le haut
  (:action deplacement_haut
    :parameters (?a - agent ?s1 - sol ?s2 - sol)
    :precondition (and
      (a_voisin_haut ?s1 ?s2)
      (agent_est_sur ?a ?s1)
      (est_libre ?s2))
    :effect (and
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s2))
      (est_libre ?s1))
  )

  ;; Déplacement vers la gauche
  (:action deplacement_gauche
    :parameters (?a - agent ?s1 - sol ?s2 - sol)
    :precondition (and
      (a_voisin_droit ?s2 ?s1)
      (agent_est_sur ?a ?s1)
      (est_libre ?s2))
    :effect (and
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s2))
      (est_libre ?s1))
  )

  ;; Déplacement vers le bas
  (:action deplacement_bas
    :parameters (?a - agent ?s1 - sol ?s2 - sol)
    :precondition (and
      (a_voisin_haut ?s2 ?s1)
      (agent_est_sur ?a ?s1)
      (est_libre ?s2))
    :effect (and
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s2))
      (est_libre ?s1))
  )

  ;; Pousser une boîte vers la droite
  (:action pousser_droit
    :parameters (?a - agent ?s1 - sol ?s2 - sol ?s3 - sol ?b - boite)
    :precondition (and
      (agent_est_sur ?a ?s1)       ;; agent est sur la case s1
      (boite_est_sur ?b ?s2)       ;; boîte est sur la case suivante s2
      (a_voisin_droit ?s1 ?s2)       ;; s2 est à droite de s1
      (a_voisin_droit ?s2 ?s3)       ;; s3 est à droite de s2 (prochaine case)
      (est_libre ?s3))                ;; s3 est libre pour accueillir la boîte
    :effect (and
      (boite_est_sur ?b ?s3)
      (not (boite_est_sur ?b ?s2))
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s3))
      (est_libre ?s2)
      (est_libre ?s1))
  )

  ;; Pousser une boîte vers le haut
  (:action pousser_haut
    :parameters (?a - agent ?s1 - sol ?s2 - sol ?s3 - sol ?b - boite)
    :precondition (and
      (agent_est_sur ?a ?s1)
      (boite_est_sur ?b ?s2)
      (a_voisin_haut ?s1 ?s2)
      (a_voisin_haut ?s2 ?s3)
      (est_libre ?s3))
    :effect (and
      (boite_est_sur ?b ?s3)
      (not (boite_est_sur ?b ?s2))
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s3))
      (est_libre ?s2)
      (est_libre ?s1))
  )

  ;; Pousser une boîte vers la gauche
  (:action pousser_gauche
    :parameters (?a - agent ?s1 - sol ?s2 - sol ?s3 - sol ?b - boite)
    :precondition (and
      (agent_est_sur ?a ?s1)
      (boite_est_sur ?b ?s2)
      (a_voisin_droit ?s2 ?s1)
      (a_voisin_droit ?s3 ?s2)
      (est_libre ?s3))
    :effect (and
      (boite_est_sur ?b ?s3)
      (not (boite_est_sur ?b ?s2))
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s3))
      (est_libre ?s2)
      (est_libre ?s1))
  )

  ;; Pousser une boîte vers le bas
  (:action pousser_bas
    :parameters (?a - agent ?s1 - sol ?s2 - sol ?s3 - sol ?b - boite)
    :precondition (and
      (agent_est_sur ?a ?s1)
      (boite_est_sur ?b ?s2)
      (a_voisin_haut ?s2 ?s1)
      (a_voisin_haut ?s3 ?s2)
      (est_libre ?s3))
    :effect (and
      (boite_est_sur ?b ?s3)
      (not (boite_est_sur ?b ?s2))
      (agent_est_sur ?a ?s2)
      (not (agent_est_sur ?a ?s1))
      (not (est_libre ?s3))
      (est_libre ?s2)
      (est_libre ?s1))
  )

  ;; Marquer une boîte comme placée sur une cible
  (:action marquer
    :parameters (?b - boite ?s - sol)
    :precondition (and
      (boite_est_sur ?b ?s)
      (est_destination ?s))
    :effect (boite_sur_cible ?b)
  )

)

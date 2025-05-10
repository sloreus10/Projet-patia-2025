(define (problem sokoban-level1)
  (:domain sokoban)
  (:objects
    l0_0 - sol
    l0_1 - sol
    l0_2 - sol
    l0_3 - sol
    l0_4 - sol
    l0_5 - sol
    l1_0 - sol
    l1_1 - sol
    l1_2 - sol
    l1_3 - sol
    l1_4 - sol
    l1_5 - sol
    l2_0 - sol
    l2_1 - sol
    l2_2 - sol
    l2_3 - sol
    l2_4 - sol
    l2_5 - sol
    l3_0 - sol
    l3_1 - sol
    l3_2 - sol
    l3_3 - sol
    l3_4 - sol
    l3_5 - sol
    l4_0 - sol
    l4_1 - sol
    l4_2 - sol
    l4_3 - sol
    l4_4 - sol
    l4_5 - sol
    l5_0 - sol
    l5_1 - sol
    l5_2 - sol
    l5_3 - sol
    l5_4 - sol
    l5_5 - sol
    l6_0 - sol
    l6_1 - sol
    l6_2 - sol
    l6_3 - sol
    l6_4 - sol
    l6_5 - sol
    l7_0 - sol
    l7_1 - sol
    l7_2 - sol
    l7_3 - sol
    l7_4 - sol
    l7_5 - sol
    a - agent
    b - boite
  )
  (:init
    (a_voisin_droit l0_0 l0_1)
    (a_voisin_haut l0_0 l1_0)
    (a_voisin_droit l0_1 l0_2)
    (a_voisin_haut l0_1 l1_1)
    (a_voisin_droit l0_2 l0_3)
    (a_voisin_haut l0_2 l1_2)
    (a_voisin_droit l0_3 l0_4)
    (a_voisin_haut l0_3 l1_3)
    (a_voisin_droit l0_4 l0_5)
    (a_voisin_haut l0_4 l1_4)
    (a_voisin_haut l0_5 l1_5)
    (a_voisin_droit l1_0 l1_1)
    (a_voisin_haut l1_0 l2_0)
    (a_voisin_droit l1_1 l1_2)
    (a_voisin_haut l1_1 l2_1)
    (a_voisin_droit l1_2 l1_3)
    (a_voisin_haut l1_2 l2_2)
    (a_voisin_droit l1_3 l1_4)
    (a_voisin_haut l1_3 l2_3)
    (a_voisin_droit l1_4 l1_5)
    (a_voisin_haut l1_4 l2_4)
    (a_voisin_haut l1_5 l2_5)
    (a_voisin_droit l2_0 l2_1)
    (a_voisin_haut l2_0 l3_0)
    (a_voisin_droit l2_1 l2_2)
    (a_voisin_haut l2_1 l3_1)
    (a_voisin_droit l2_2 l2_3)
    (a_voisin_haut l2_2 l3_2)
    (a_voisin_droit l2_3 l2_4)
    (a_voisin_haut l2_3 l3_3)
    (a_voisin_droit l2_4 l2_5)
    (a_voisin_haut l2_4 l3_4)
    (a_voisin_haut l2_5 l3_5)
    (a_voisin_droit l3_0 l3_1)
    (a_voisin_haut l3_0 l4_0)
    (a_voisin_droit l3_1 l3_2)
    (a_voisin_haut l3_1 l4_1)
    (a_voisin_droit l3_2 l3_3)
    (a_voisin_haut l3_2 l4_2)
    (a_voisin_droit l3_3 l3_4)
    (a_voisin_haut l3_3 l4_3)
    (a_voisin_droit l3_4 l3_5)
    (a_voisin_haut l3_4 l4_4)
    (a_voisin_haut l3_5 l4_5)
    (a_voisin_droit l4_0 l4_1)
    (a_voisin_haut l4_0 l5_0)
    (a_voisin_droit l4_1 l4_2)
    (a_voisin_haut l4_1 l5_1)
    (a_voisin_droit l4_2 l4_3)
    (a_voisin_haut l4_2 l5_2)
    (a_voisin_droit l4_3 l4_4)
    (a_voisin_haut l4_3 l5_3)
    (a_voisin_droit l4_4 l4_5)
    (a_voisin_haut l4_4 l5_4)
    (a_voisin_haut l4_5 l5_5)
    (a_voisin_droit l5_0 l5_1)
    (a_voisin_haut l5_0 l6_0)
    (a_voisin_droit l5_1 l5_2)
    (a_voisin_haut l5_1 l6_1)
    (a_voisin_droit l5_2 l5_3)
    (a_voisin_haut l5_2 l6_2)
    (a_voisin_droit l5_3 l5_4)
    (a_voisin_haut l5_3 l6_3)
    (a_voisin_droit l5_4 l5_5)
    (a_voisin_haut l5_4 l6_4)
    (a_voisin_haut l5_5 l6_5)
    (a_voisin_droit l6_0 l6_1)
    (a_voisin_haut l6_0 l7_0)
    (a_voisin_droit l6_1 l6_2)
    (a_voisin_haut l6_1 l7_1)
    (a_voisin_droit l6_2 l6_3)
    (a_voisin_haut l6_2 l7_2)
    (a_voisin_droit l6_3 l6_4)
    (a_voisin_haut l6_3 l7_3)
    (a_voisin_droit l6_4 l6_5)
    (a_voisin_haut l6_4 l7_4)
    (a_voisin_haut l6_5 l7_5)
    (a_voisin_droit l7_0 l7_1)
    (a_voisin_droit l7_1 l7_2)
    (a_voisin_droit l7_2 l7_3)
    (a_voisin_droit l7_3 l7_4)
    (a_voisin_droit l7_4 l7_5)
    (est_libre l0_0)
    (est_libre l0_1)
    (est_libre l1_0)
    (est_libre l1_1)
    (est_libre l1_3)
    (est_libre l1_4)
    (est_libre l2_3)
    (est_destination l2_4)
    (est_libre l2_4)
    (est_libre l3_1)
    (est_libre l3_2)
    (est_libre l3_3)
    (est_libre l3_4)
    (est_libre l4_1)
    (agent_est_sur a l4_3)
    (est_libre l4_4)
    (est_libre l5_1)
    (boite_est_sur b l5_2)
    (est_libre l5_3)
    (est_libre l5_4)
    (est_libre l6_2)
    (est_libre l6_3)
    (est_libre l6_4)
    (est_libre l7_0)
  )
  (:goal (and
    (boite_est_sur b l2_4)
  ))
)

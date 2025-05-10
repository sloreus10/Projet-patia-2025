(define (problem sokoban-level1)
  (:domain sokoban)
  (:objects
    l1
    l2
    l3
    l4
    l5
    l6
    l7
    l8
    l9
    l10
    l11
    l12
    l13
    l14
    l15
    l16
    l17
    l18
    l19
    l20
    l21
    l22
    l23
    l24
    l25
    l26
    l27
    l28
    l29
    l30
    l31
    l32
    l33
    l34
    l35
    l36
    l37
    l38
    l39
    l40
    l41
    l42
    l43
    l44
    l45
    l46
    l47
    l48
  )
  (:init
    (wall l3)
    (wall l4)
    (wall l5)
    (wall l6)
    (wall l9)
    (wall l12)
    (wall l13)
    (wall l14)
    (wall l15)
    (goal l17)
    (wall l18)
    (wall l19)
    (wall l24)
    (wall l25)
    (wall l27)
    (player l28)
    (wall l30)
    (wall l31)
    (box l33)
    (wall l36)
    (wall l37)
    (wall l38)
    (wall l42)
    (wall l44)
    (wall l45)
    (wall l46)
    (wall l47)
    (wall l48)
  )
  (:goal (and
    (box l17)
  ))
)

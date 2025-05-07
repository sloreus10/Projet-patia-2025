;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : NPuzzle     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine NPuzzle
(define (domain NPuzzle)

	(:requirements :strips :typing)

	; Types : tuile, position
	(:types tuile position)

	; Constantes : libre (tuile vide)
	(:constants libre - tuile)

	; Prédicats : Fonctions qui décrivent notre domaine
	(:predicates
		
			; La tuile "t" est positionnee à la position "x"
			(positionnee ?x - position ?y - tuile)

			; Permuter la position "x" avec la position "y"
			(permuter ?x - position ?y - position)
	)

	; Actions : Déplacer une tuile
	(:action deplacerTuile
		
		; Paramètres : La tuile "t" à déplacer, la position "depuis" et la position "vers"
		:parameters (?t - tuile ?depuis - position ?vers - position)

		; Préconditions de l'action : Déplacer une tuile
		:precondition

			; Ensemble des préconditions de cette action
			(and
				
				; La tuile "t" est positionnée à la position "depuis"
				(positionnee ?depuis ?t)

				; La tuile "libre" est positionnée à la position "vers"
				(positionnee ?vers libre)

				; Permuter la position "depuis" avec la position "vers"
				(permuter ?depuis ?vers)
			)

		; Effets de l'action : Déplacer une tuile
		:effect

			; Ensemble des effets de cette action
			(and
				
				; La tuile "t" est positionnée à la position "vers"
				(positionnee ?vers ?t)

				; La tuile "libre" est positionnée à la position "depuis"
				(positionnee ?depuis libre)

				; La tuile "t" n'est plus positionnée à la position "depuis"
				(not (positionnee ?depuis ?t))

				; La tuile "libre" n'est plus positionnée à la position "vers"
				(not (positionnee ?vers libre))
			)
	)

	; Actions : Permuter deux positions
	(:action permuterPositions
		
		; Paramètres : La position "depuis" et la position "vers"
		:parameters (?depuis - position ?vers - position)

		; Préconditions de l'action : Permuter deux positions
		:precondition

			; Ensemble des préconditions de cette action
			(and
				
				; Permuter la position "depuis" avec la position "vers"
				(permuter ?depuis ?vers)
			)

		; Effets de l'action : Permuter deux positions
		:effect
		
			; Ensemble des effets de cette action
			(and
				
				; Permuter la position "vers" avec la position "depuis"
				(permuter ?vers ?depuis)
			)
	)
)
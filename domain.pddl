; Domain description
; Describe the relations and transitions that can occur
(define (domain starProblem) ; Domain name must match problem's

  ; Define what the planner must support to execute this domain
  ; Only domain requirements are currently supported
  (:requirements
    :strips                 ; basic preconditions and effects
    :negative-preconditions ; to use not in preconditions
    :equality               ; to use = in preconditions
    ; :typing               ; to define type of objects and parameters
  )

  ; Define the relations
  ; Question mark prefix denotes free variables
  (:predicates
    (clear ?x)      ; An object ?x is clear
    (on ?x ?y)      ; An object ?x is on object ?y
    (smaller ?x ?y) ; An object ?x is smaller than object ?y
    ;
    (currentCenterPiece ?x) ; the object that is currently on pegO, otherwise pegO
    ;
  )

  ; Define a transition to move a disc from one place to another
  (:action moveToCenter
    :parameters (?disc ?from ?to)
    ; Only conjunction or atomic preconditions are supported
    :precondition (and
      (smaller ?disc ?to)
      (smaller ?disc ?from)
      (on ?disc ?from)
      (clear ?disc)
      (clear ?to)
      (not (= ?from ?to)) ; Negative precondition and equality
      ;
      (currentCenterPiece ?to)
      ;
    )

    ; Only conjunction or atomic effects are supported
    :effect (and
      ; Note that adding the new relations is not enough
      (clear ?from)
      (on ?disc ?to)
      ;
      (currentCenterPiece ?disc)
      ;
      ; Remove the old relations, order is not important
      (not (on ?disc ?from))
      (not (clear ?to))
      ;
      (not (currentCenterPiece ?to))
      ;
    )
  )

  ; Define a transition to move a disc from one place to another
  (:action moveFromCenter
    :parameters (?disc ?from ?to)
    ; Only conjunction or atomic preconditions are supported
    :precondition (and
      (smaller ?disc ?to)
      (smaller ?disc ?from)
      (on ?disc ?from)
      (clear ?disc)
      (clear ?to)
      (not (= ?from ?to)) ; Negative precondition and equality
      ;
      (currentCenterPiece ?disc)
      ;
    )

    ; Only conjunction or atomic effects are supported
    :effect (and
      ; Note that adding the new relations is not enough
      (clear ?from)
      (on ?disc ?to)
      ;
      (currentCenterPiece ?from)
      ;
      ; Remove the old relations, order is not important
      (not (on ?disc ?from))
      (not (clear ?to))
      ;
      (not (currentCenterPiece ?disc))
      ;
    )
  )

  ; Other transitions can be defined here
)

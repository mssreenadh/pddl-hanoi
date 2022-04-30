; Problem description
; Describe one scenario within the domain constraints
(define (problem starProblem6Discs)
  (:domain starProblem)

  ; Objects are candidates to replace free variables
  (:objects pegA pegB pegC pegO d1 d2 d3 d4 d5 d6)

  ; The initial state describe what is currently true
  ; Everything else is considered false
  (:init

    (currentCenterPiece pegO)
    ; Discs are smaller than pegs
    (smaller d1 pegA) (smaller d1 pegB) (smaller d1 pegC) (smaller d1 pegO)
    (smaller d2 pegA) (smaller d2 pegB) (smaller d2 pegC) (smaller d2 pegO)
    (smaller d3 pegA) (smaller d3 pegB) (smaller d3 pegC) (smaller d3 pegO)
    (smaller d4 pegA) (smaller d4 pegB) (smaller d4 pegC) (smaller d4 pegO)
    (smaller d5 pegA) (smaller d5 pegB) (smaller d5 pegC) (smaller d5 pegO)
    (smaller d6 pegA) (smaller d6 pegB) (smaller d6 pegC) (smaller d6 pegO)

    ; Discs are also smaller than some other discs
    (smaller d1 d2) ;disc one is smaller than disc two
    (smaller d1 d3) (smaller d2 d3) ;discs one and two are smaller than disc three
    (smaller d1 d4) (smaller d2 d4) (smaller d3 d4) ; discs < 4 are smaller than four
    (smaller d1 d5) (smaller d2 d5) (smaller d3 d5) (smaller d4 d5) ;discs < 5 are smaller than five
    (smaller d1 d6) (smaller d2 d6) (smaller d3 d6) (smaller d4 d6) (smaller d5 d6) ; discs <6 are smaller than six

    ; There is nothing on top of some pegs and disc
    (clear pegB) ;peg B is empty
    (clear pegC) ;peg C is empty
    (clear pegO) ;peg O is empty
    (clear d1)   ;there is not a disc on top of disc one

    ; Discs are stacked on peg1
    (on d6 pegA) ;disc six is on peg A
    (on d5 d6)
    (on d4 d5)   ;disc four is on disc five
    (on d3 d4)   ;disc three is on disc four
    (on d2 d3)   ;disc two is on disc three
    (on d1 d2)   ;disc one is on disc 2
  )

  ; The goal state describe what we desire to achieve
  (:goal (and
    ; Discs stacked on peg3
    (on d6 pegC)
    (on d5 d6)
    (on d4 d5)
    (on d3 d4)
    (on d2 d3)
    (on d1 d2)
  ))
)

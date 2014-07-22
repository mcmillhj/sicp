;; Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

;; Eva demonstrates the program for Alyssa:

;; (new-if (= 2 3) 0 5)
;; 5

;; (new-if (= 1 1) 0 5)
;; 0

;; Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
     guess
          (sqrt-iter (improve guess x)
                     x)))

;; What happens when Alyssa attempts to use this to compute square roots? Explain. 

Recall from the previous sections that (if <predicate> <consequent> <alternative>) is a special form that does two things: 1. It evaluates the predicate 2. If the <predicate> was true it evaluates the <consequent>, otherwise it evaluates the <alternative>. the (new-if ...) procedure doesn't have this special form, so each time the production is applied it evaluates both of its operands and results in an infinite recursion due to the applicative-order evaluation that scheme uses.

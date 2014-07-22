;;; Exercise 1.4.  
;;; Observe that our model of evaluation allows for combinations whose operators 
;;; are compound expression

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;;; The above if expression returns a procedure + or - predicated on whether or not b is greater than 0. 

(a-plus-abs-b 5 -2) => (- 5 -2) => 7
(a-plus-abs-b 5  2) => (+ 5  2) => 7

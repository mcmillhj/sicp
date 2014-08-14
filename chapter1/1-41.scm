;;; Exercise 1.41: 
;;; Define a procedure double that takes a procedure of one argument as argument and returns a procedure that applies the original procedure twice. 
(define (double f)
  (lambda(x) (f (f x))))

(define (inc x) 
  (+ 1 x))

;;; For example, if inc is a procedure that adds 1 to its argument, then (double inc) should be a procedure that adds 2. What value is returned by
(((double (double double)) inc) 5)
; => 21

; the first inner call to (double double) returns a procedure that applies 
; a procedure to itself 4 times 

; the next call to double: (double (double double))
; takes the previous procedure that applies a procedure to itself 4 times
; and returns a procedure that applies a procedure to itself 16 times 
; at first glance it may appear taht this would apply the procedure
; 8 times, but we were given as an argument a procedure that when
; given a procedure applies it to itself 4 times. We then return a
; procedure that applies that quaddrupling procedure to itself: 4 * 4 = 16; 

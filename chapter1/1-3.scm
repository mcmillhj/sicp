;;; Exercise 1.3.  
;;; Define a procedure that takes three numbers as arguments and returns the sum of the i
;;; squares of the two larger numbers. 

(define (max a b)
  (if (< a b) b a))

(define (min a b)
i  (if (< a b) a b))

(define (sum-of-squares a b)
  (+ (square a) (square b)))

(define (biggest-2-sum-of-squares a b c)
  (sum-of-squares (max a b) (max (min a b) c)))

(biggest-2-sum-of-squares 3 4 5)

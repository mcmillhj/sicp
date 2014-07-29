;;; Exercise 1.21.  
;;; Use the smallest-divisor procedure to find the smallest divisor of each of the following numbers: 199, 1999, 19999. 

(define (smallest-divisor n)
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (square x)
    (* x x))
  (find-divisor n 2))

(smallest-divisor 199)   ; => 199
(smallest-divisor 1999)  ; => 1999
(smallest-divisor 19999) ; => 7

;; The results of applying the procedure smallest-divisor to 199, 1999, and 19999 is that we can see that 199 and 1999 are prime; because they are
;; their own smallest divisors. 19999 is not prime because it is divisible by 7

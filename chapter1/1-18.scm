;;; Exercise 1.18.  
;;; Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps

(define (double x)
  (+ x x))
(define (halve x)
  (/ x 2))
(define (even? x)
  (= (remainder x 2) 0))

(define (mult a b)
  (define (mult-iter a b p)
    (cond ((= b 0) p)
	((even? b) (mult-iter (double a) (halve b) p))
	(else (mult-iter a (- b 1) (+ p a)))))
  (mult-iter a b 0))

;; Exercise 1.8.  Newton's method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better approximation is given by the value
;; x/y^2 + 2y
;; ----------
;;     3

We can implement this cube-root procedure in exactly the same fashion as the sqrt procedure above, the only implementation different will be the improve procedure:

(define (cbrt x)
  (define (good-enough? guess previous-guess)
    (< (abs (- guess previous-guess))
       0.001))
  (define (improve guess)
    (/ (+ (/ x (square guess)) (* 2 guess))
       3))
  (define (cube-iter guess previous-guess)
    (if (good-enough? guess previous-guess)
   guess
   (cube-iter (improve guess) guess)))
  (cube-iter 1.0 0))

In fact since they share some functionality, we can factor "(good-enough? ...)" out of both implementations:

(define (good-enough? guess previous-guess)
    (< (abs (- guess previous-guess))
       0.001))
(define (average a b)
  (/ (+ a b) 2))

(define (sqrt x)
  (define (improve guess)
    (average guess (/ x guess)))
  (define (iter guess previous-guess)
    (if (good-enough? guess previous-guess)
   guess
   (iter (improve guess) guess)))
  (iter 1.0 0))

(define (cbrt x)
  (define (improve guess)
    (/ (+ (/ x (square guess)) (* 2 guess)) 3))
  (define (iter guess previous-guess)
    (if (good-enough? guess previous-guess)
   guess
   (iter (improve guess) guess)))
  (iter 1.0 0))

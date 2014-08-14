;;; Exercise 1.46: 
;;; Several of the numerical methods described in this chapter are instances of an extremely general computational strategy known as iterative improvement. 
;;; Iterative improvement says that, to compute something, we start with an initial guess for the answer, 
;;; test if the guess is good enough, and otherwise improve the guess and continue the process using the improved guess as the new guess. 
;;; Write a procedure iterative-improve that takes two procedures as arguments: a method for telling whether a guess is good enough and a method for improving a guess. 
;;; Iterative-improve should return as its value a procedure that takes a guess as argument and keeps improving the guess until it is good enough. 
;;; Rewrite the sqrt procedure of 1.1.7 and the fixed-point procedure of 1.3.3 in terms of iterative-improve. 

; sqrt procedure and sub-procedures from SICP 1.1.7
(define (sqrt x)
   (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
   (if (good-enough? guess x)
       guess
       (sqrt-iter (improve guess x)
                  x)))

(define (improve guess x)
   (average guess (/ x guess)))

(define (average x y)
   (/ (+ x y) 2))

(define (good-enough? guess x)
 (< (abs (- (square guess) x)) 0.001))

(define (square x) (* x x))


; fixed-point procedure from SICP 1.3.3
(define tolerance 0.00001)
(define (fixed-point f first-guess)
   (define (close-enough? v1 v2)
     (< (abs (- v1 v2)) tolerance))
   (define (try guess)
     (let ((next (f guess)))
       (if (close-enough? guess next)
           next
           (try next))))
   (try first-guess))

(define (iterative-improve good-enough? improve)
  (define (iter guess)
    (if (good-enough? guess)
        guess
        (iter (improve guess))))
  iter)

(define (sqrt x)
  ((iterative-improve (lambda(guess) 
                        (< (abs (- (square guess) x)) 0.001))
                      (lambda(guess) 
                        (average guess (/ x guess))))
    1.0))

(sqrt 4) ; => 2.0000000929222947
(sqrt 9) ; => 3.00009155413138

(define (fixed-point f first-guess)
  ((iterative-improve (lambda(guess) 
                        (< (abs (- (f guess) guess)) 0.00001))
                      (lambda(guess) (f guess)))
   first-guess))
   
; we can test this by approximating the golden ration using 1 + 1/x
(fixed-point (lambda(x) (+ 1 (/ 1 x))) 2.0) ; => 1.6180371352785146

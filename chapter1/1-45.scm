;;; Exercise 1.45: 
;;; We saw in 1.3.3 that attempting to compute square roots by naively finding a fixed point of y ↦ x / y does not converge, and that this can be fixed by average damping. 
;;; The same method works for finding cube roots as fixed points of the average-damped y ↦ x / y^2 . 
;;; Unfortunately, the process does not work for fourth roots—a single average damp is not enough to make a fixed-point search for y ↦ x / y^3 converge. 
;;; On the other hand, if we average damp twice (i.e., use the average damp of the average damp of y ↦ x / y^3 ) the fixed-point search does converge. 
;;; Do some experiments to determine how many average damps are required to compute nth roots as a fixed-point search based upon repeated average damping of y ↦ x / y^(n − 1) . 
;;; Use this to implement a simple procedure for computing n th roots using fixed-point, average-damp, and the repeated procedure of Exercise 1.43. 
;;; Assume that any arithmetic operations you need are available as primitives. 
(define (repeated f n)
  (define (compose f g)
    (lambda (x) (f (g x))))
  (if (= n 1) 
      f
      (compose f (repeated f (- n 1)))))

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average-damp f)
  (define (average x y)
    (/ (+ x y) 2))
  (lambda (x) 
    (average x (f x))))

(define (nth-root x n)
  (fixed-point 
   (average-damp 
    (lambda(y) (/ x (expt y (- n 1)))))
   1.0))

; just to verify that average-damping 4th roots does not work 
(nth-root 100 2)   ; => 10.0
(nth-root 1000 3)  ; => 10.000002544054729
(nth-root 10000 4) ; => doesn't terminate

; we can fix this by using the repeated procedure to average-damp more 
; than once 
(define (nth-root x n)
  (fixed-point
   ((repeated average-damp 2)
    (lambda (y) (/ x (expt y (- n 1)))))
   1.0))

; average damping twices works up to n = 7
(nth-root 10000 4)     ; => 10.
(nth-root 100000 5)    ; => 9.99999869212542
(nth-root 1000000 6)   ; => 9.999996858149522
(nth-root 10000000 7)  ; => 9.9999964240619
(nth-root 100000000 8) ; => doesn't terminate

; let's see what happens when we increase the damps to 3
(define (nth-root x n)
  (fixed-point
   ((repeated average-damp 3)
    (lambda (y) (/ x (expt y (- n 1)))))
   1.0))

; average damping 3 times works up to n = 15 
(nth-root 1000000000 9)         ; => 10.00000028322885
(nth-root 10000000000 10)       ; => 10.000001863218898
(nth-root 100000000000 11)      ; => 10.000001257784588
(nth-root 1000000000000 12)     ; => 10.000002864627799
(nth-root 10000000000000 13)    ; => 9.999996751002548
(nth-root 100000000000000 14)   ; => 10.000003649458597
(nth-root 1000000000000000 15)  ; => 10.000004551348447
(nth-root 10000000000000000 16) ; doesn't terminate

; by using these three trials, we can see a pattern 
; average damps | highest n
; --------------------------
;       1       |    3 
;       2       |    7
;       3       |   15

; based on these findings I would posit that the number of average damps 
; needed for some n is n = 2^(average damps + 1) - 1
; we can test this by increasing the number of average damps to 4
; and testing that we can get 31, but not 32
(define (nth-root x n)
  (fixed-point
   ((repeated average-damp 4)
    (lambda (y) (/ x (expt y (- n 1)))))
   1.0))

; switching to powers of 2
(nth-root (expt 2 31) 31) ; => 2.0000031663503988
(nth-root (expt 2 32) 32) ; => 2.0000073159030616

; Well, that goes against what I just said above; but n = 2^a+1 - 1 still
; seems like a sane bound, so we'll use that. We need to isolate a from
; the above formula which we can do by rewriting the formula as
; log2(n) = a + 1 - 1
;         = a
; so we just need to compute the log base 2 of n and probably floor it
; since we don't want fractional results
(define (log2 n)
  (/ (log n) (log 2)))

(define (nth-root x n)
  (fixed-point
   ((repeated average-damp (floor (log2 n)))
    (lambda (y) (/ x (expt y (- n 1)))))
   1.0))

(nth-root 4294967296 32) ; => 2.000000000000006
(nth-root 18446744073709551616 64) ; => overflow 
(nth-root 340282366920938463463374607431768211456 128) ; => overflow

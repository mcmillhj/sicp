;;; Exercise 1.39: 
;;; A continued fraction representation of the tangent function was published in 1770 by the German mathematician J.H. Lambert: 
;;;    tan x = x  
;;;            ----
;;;            1 − x^2
;;;                ----
;;;                3 − x^2 
;;;                    ---- 
;;;                    5 − … , 
;;; where x is in radians. 
;;; 
;;; Define a procedure (tan-cf x k) that computes an approximation to the tangent function based on Lambert’s formula. 
;;; k specifies the number of terms to compute, as in Exercise 1.37. 
(define (cont-frac n d k)
  (define (frac i)
    (let ((N (n i))
          (D (d i)))
    (if (< i k)
        (/ N (+ D (frac (+ i 1))))
        (/ N D))))
  (frac 1))

(define (tan-cf x k)
  (define (n i)
    (if (= i 1)
        x 
        (- (* x x))))
  (define (d i)
    (- (* 2 i) 1))
  (cont-frac n d k))

(tan (/ pi 6))
; => .5773502691896717
(tan-cf (/ pi 6) 10)
; => .5773502691896717
(tan (/ pi 4))
; => 1.0000000000001035
(tan-cf (/ pi 4) 10))
; => 1.0000000000001035

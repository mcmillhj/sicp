;;; Exercise 1.44: 
;;; The idea of smoothing a function is an important concept in signal processing. 
;;; If f is a function and d x is some small number, then the smoothed version of f 
;;; is the function whose value at a point x is the average of f ( x − d x ) , f ( x ) , and f ( x + d x ) . 
;;; Write a procedure smooth that takes as input a procedure that computes f and returns a procedure that computes the smoothed f . 
;;; It is sometimes valuable to repeatedly smooth a function (that is, smooth the smoothed function, and so on) to obtain the n-fold smoothed function. 
;;; Show how to generate the n-fold smoothed function of any given function using smooth and repeated from Exercise 1.43. 
(define (smooth f)
  (define dx 0.00001)
  (define (average a b c)
    (/ (+ a b c) 3))
  (lambda(x) 
    (average (f (- x dx)) (f x) (f (+ x dx)))))

(define (n-fold-smoothed f n)
  (repeated (smooth f) n))

; we can use schemes sin function to test smoothness
((n-fold-smoothed sin 2) (/ pi 2))     ; => .8414709847618375
(sin (sin (/ pi 2)))                   ; => .8414709848078965

((n-fold-smoothed sin 3) (/ pi 2))     ; => .7456241416100116
(sin (sin (sin (/ pi 2))))             ; => .7456241416655579

((n-fold-smoothed sin 4) (/ pi 2))     ; => .6784304772973179
(sin (sin (sin (sin (/ pi 2)))))       ; => .6784304773607402

((n-fold-smoothed sin 5) (/ pi 2))     ; => .627571831978862
(sin (sin (sin (sin (sin (/ pi 2)))))) ; => .6275718320491591

; in all of the above cases, the smoothing function precise
; up to 8 decimal digits 

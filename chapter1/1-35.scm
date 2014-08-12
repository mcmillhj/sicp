;;; Exercise 1.35: 
;;; Show that the golden ratio φ (1.2.2) is a fixed point of the transformation x ↦ 1 + 1 / x , 
;;; and use this fact to compute φ by means of the fixed-point procedure. 

; the golden ratio approximates to 1.6180
φ = 1 + sqrt(5)/2 ~=~ 1.6180

; pick an arbitrary number x (5 in this case)
; and apply f(x) = 1 + 1 / x to itself over and over
; until there is a change of less than 0.00001
x = 5 
  = 1 + 1 / 5 
  = 1 + 0.2
  = 1.2 

x = 1.2 
  = 1 + 1 / 1.2 
  = 1 + 0.8333
  = 1.8333 

x = 1.8333 
  = 1 + 1 / 1.8333 
  = 1 + 0.5454
  = 1.5454

x = 1.5454 
  = 1 + 1 / 1.5454
  = 1 + 0.6470
  = 1.6470

x = 1.6470
  = 1 + 1 / 1.6470 
  = 1 + 0.6071
  = 1.6071

x = 1.6071
  = 1 + 1 / 1.6071
  = 1 + 0.6222
  = 1.6222

x = 1.6222
  = 1 + 1 / 1.6222
  = 1 + 0.6164
  = 1.6164

x = 1.6164
  = 1 + 1 / 1.6164
  = 1 + 0.6186
  = 1.6186

x = 1.6186
  = 1 + 1 / 1.6186
  = 1 + 0.6178 
  = 1.6178

x = 1.6178
  = 1 + 1 / 1.6178
  = 1 + 0.6181
  = 1.6181

x = 1.6181 
  = 1 + 1 / 1.6181
  = 1 + 0.6180
  = 1.6180

x = 1.6180 
  = 1 + 1 / 1.6180 
  = 1 + 0.6180
  = 1.6180

; STOP, less than 0.00001 change 12 applications

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 5.0)
; => 1.618035882908404

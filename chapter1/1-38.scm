;;; Exercise 1.38: 
;;; In 1737, the Swiss mathematician Leonhard Euler published a memoir De Fractionibus Continuis, 
;;; which included a continued fraction expansion for e − 2 , where e is the base of the natural logarithms. 
;;; In this fraction, the N i are all 1, and the D i are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, …. 
;;; Write a program that uses your cont-frac procedure from Exercise 1.37 to approximate e , based on Euler’s expansion. 

; e ~ 2.71828
; e - 2 = .7182
(cont-frac (lambda(i) 1.0)
           (lambda(i) 
             (if (not (= 0 (remainder (+ i 1) 3)))
                 1
                 (* 2 (/ (+ i 1) 3))))
                      
           5)
; => .71875

(cont-frac (lambda(i) 1.0)
           (lambda(i) 
             (if (not (= 0 (remainder (+ i 1) 3)))
                 1
                 (* 2 (/ (+ i 1) 3))))
                      
           6)
; => .717948717948718

(cont-frac (lambda(i) 1.0)
           (lambda(i) 
             (if (not (= 0 (remainder (+ i 1) 3)))
                 1
                 (* 2 (/ (+ i 1) 3))))
                      
           8)
; => .7182795698924731

(define e 
  (+ 2 
     (cont-frac (lambda(i) 1.0)
                (lambda(i) 
                  (if (not (= 0 (remainder (+ i 1) 3)))
                      1
                      (* 2 (/ (+ i 1) 3))))
                
                8)))
; => 2.718279569892473

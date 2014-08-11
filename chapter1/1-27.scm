;;; Exercise 1.27: 
;;; Demonstrate that the Carmichael numbers listed in Footnote 47 really do fool the Fermat test:
;;;    561, 1105, 1729, 2465, 2821, and 6601
;;; That is, write a procedure that takes an integer n and tests whether a n is congruent to a modulo n for every a < n , and try your procedure on the given Carmichael numbers. 


; We can re-use the fermat-test procedure from 1.24 and modify it to take a given value 
; not generate a random one 
(define (fermat-test n)
   (define (try-it a)
     (= (expmod a n n) a))
   (try-it (+ 1 (random-integer (- n 1)))))

(define (fermat-test n a)
  (= (expmod a n n) a))

; Given this definition we also need the expmod procedure
(define (expmod base exp m)
  (define (even? n)
    (= (remainder n 2) 0))
  (define (square n)
    (* n n))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m)))) 

; Now we can create the new fermat test procedure
(define (fermat-test-all n)
  (define (fermat-test n a)
    (= (expmod a n n) a))
  (define (loop a)
    (cond ((= a 1) #t)
          ((not (fermat-test n a)) #f)
          (else (loop (- a 1)))))
  (loop (- n 1)))

(fermat-test-all 561)  ; => #t
(fermat-test-all 1105) ; => #t
(fermat-test-all 1729) ; => #t
(fermat-test-all 2465) ; => #t
(fermat-test-all 2821) ; => #t
(fermat-test-all 6601) ; => #t

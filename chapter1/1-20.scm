;;; Exercise 1.20.  
;;; The process that a procedure generates is of course dependent on the rules used by the interpreter. 
;;; As an example, consider the iterative gcd procedure given above. 
;;; Suppose we were to interpret this procedure using normal-order evaluation, as discussed in section 1.1.5. (The normal-order-evaluation rule for if is described in exercise 1.5.) 
;;; Using the substitution method (for normal order), illustrate the process generated in evaluating (gcd 206 40) and indicate the remainder operations that are actually performed. 
;;; How many remainder operations are actually performed in the normal-order evaluation of (gcd 206 40)? In the applicative-order evaluation? 

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; Normal-order evaluation fully expand and reduce
(gcd 206 40) 
(if (= 40 0)
    206 
    (gcd 40 (remainder 206 40)))

(gcd 40 (remainder 206 40))
(if (= (remainder 206 40) 0)
    40
    (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))
; reduce primitive expression in the if statement (1 remainder)
(if (= 6 0)
    40
    (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))

(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
(if (= (remainder 40 (remainder 206 40)) 0)
    (remainder 206 40)
    (gcd (remainder 40 (remainder 206 40))
	 (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; reduce primitive expression in the if statement (2 remainders) 
(if (= 4 0)
    (remainder 206 40)
    (gcd (remainder 40 (remainder 206 40))
	 (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

(gcd (remainder 40 (remainder 206 40))
     (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

(if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0)
    (remainder 40 (remainder 206 40))
    (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
	 (remainder (remainder 40 (remainder 206 40))
		    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))
; reduce prmitive expression in the if statement (4 remainders)
(if (= 2 0)
    (remainder 40 (remainder 206 40))
    (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
	 (remainder (remainder 40 (remainder 206 40))
		    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))

(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
     (remainder (remainder 40 (remainder 206 40))
		(remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))
(if (= (remainder (remainder 40 (remainder 206 40))
		  (remainder (remainder 206 40) 
			     (remainder 40 (remainder 206 40)))) 0)
    (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
    (gcd (remainder (remainder 40 (remainder 206 40))
		    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
	 (remainder  (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
		     (remainder (remainder 40 (remainder 206 40))
				(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))
; reduce primitive expression in if statement (7 remainders)
(if (= 0 0)
    (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
    (gcd (remainder (remainder 40 (remainder 206 40))
		    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
	 (remainder  (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
		     (remainder (remainder 40 (remainder 206 40))
				(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))
; evaluate final expression (4 remainders) 
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
(remainder 6 (remainder 40 6))
(remainder 6 4)
; => 2

; Total of 1 + 2 + 4 + 7 + 4 = 18 remainders using normal-order application 

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; Applicative-order evaluation, evaluate arguments and then apply operators
(gcd 206 40)
(if (= 40 0)
    206
    (gcd 40 (remainder 206 40)))

(gcd 40 (remainder 206 40))
(gcd 40 6)
(if (= 6 0)
    40 
    (gcd 6 (remainder 40 6)))

(gcd 6 (remainder 40 6))
(gcd 6 4)
(if (= 4 0)
    6
    (gcd 4 (remainder 6 4)))

(gcd 4 (remainder 6 4))
(gcd 4 2)
(if (= 2 0)
    4 
    (gcd 2 (remainder 4 2)))

(gcd 2 (remainder 4 2))
(gcd 2 0)
(if (= 0 0)
    2
    (gcd 2 (remainder 2 0)))

; => 2
; 4 remainders evaulated

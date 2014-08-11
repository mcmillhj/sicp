;;; Exercise 1.25.  
;;; Alyssa P. Hacker complains that we went to a lot of extra work in writing expmod. After all, she says, since we already know how to compute exponentials, we could have simply written

(define (expmod base exp m)
  (define (fast-expt b n)
    (cond ((= n 0) 1)
          ((even? n) (square (fast-expt b (/ n 2))))
          (else (* b (fast-expt b (- n 1))))))
  (remainder (fast-expt base exp) m))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m)))) 

;; Is she correct? Would this procedure serve as well for our fast prime tester? Explain. 
No, Alyssa is not correct. The important difference is that the original expmod procedure 
computes its result using successive squaring without having to deal with numbers that are much 
larger than m. This observation comes from a footnote with the original code: 

"The reduction steps in the cases where the exponent e is greater than 1 are based on the fact that, 
for any integers x, y, and m, we can find the remainder of x times y modulo m by computing separately the remainders of x modulo m and y modulo m, 
multiplying these, and then taking the remainder of the result modulo m. 
For instance, in the case where e is even, we compute the remainder of be/2 modulo m, square this, and take the remainder modulo m. 
This technique is useful because it means we can perform our computation without ever having to deal with numbers much larger than m."

Example to verify this is correct: 

5 * 7 mod 31 = 4
5 mod 31 = 5 
7 mod 31 = 7 
         = 5 * 7 mod 31
         = 35 mod 31
         = 4

Alyssa's method takes much longer to compute due to how the time complexit of even 
primitive operations increases as the size of their operations increases. It is much faster
to add two 32-bit integers than two 128-bit integers.

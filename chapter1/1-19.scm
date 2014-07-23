;;; Exercise 1.19.   
;; There is a clever algorithm for computing the Fibonacci numbers in a logarithmic number of steps. 
;; Recall the transformation of the state variables a and b in the fib-iter process of section 1.2.2: a <- a + b and b <- a. i
;; Call this transformation T, and observe that applying T over and over again n times, starting with 1 and 0, produces the pair Fib(n + 1) and Fib(n). In other words, the Fibonacci numbers are produced by applying Tn, the nth power of the transformation T, starting with the pair (1,0). 
;; Now consider T to be the special case of p = 0 and q = 1 in a family of transformations Tpq, where Tpq transforms the pair (a,b) according to a bq + aq + ap and b bp + aq. 
;; Show that if we apply such a transformation Tpq twice, the effect is the same as using a single transformation Tp'q' of the same form, and compute p' and q' in terms of p and q. 
;; This gives us an explicit way to square these transformations, and thus we can compute Tn using successive squaring, as in the fast-expt procedure. 
;; Put this all together to complete the following procedure, which runs in a logarithmic number of steps

T   = a <- a + b
      b <- a

Tpq = a <- bq + aq + ap
      b <- bp + aq

We can verify that this transformation T is a special case of transformation Tpq where p = 0 and q = 1 by substituting
the values of p and q into the formula for transformation Tpq:

a = bq + aq + ap 
b = bp + aq

a = b(1) + a(1) + a(0)
  = b + a

b = b(0) + a(1)
  = a 

We can apply Tpq twice by defining two new variables, substituting, and simplifying:

a1 = bq + aq + ap
b1 = bp + aq

Now we can define a2 and b2 in terms of a1 and b2: 

a2 = b1q + a1q + a1p
b2 = b1p + a1q

and substitute the previous values in:

a2 = (bp + aq)q + (bq + aq + ap)q + (bq + aq + ap)p
b2 = (bp + aq)p + (bq + aq + ap)q

and simplify the results, keeping in mind we are trying to find p' and q' (b2 = bp' + aq', a2 = bq' + aq' + ap'):

a2 = (bp + aq)q + (bq + aq + ap)q + (bq + aq + ap)p
   = (bpq + aqq) + (bqq + apq + apq) + (bpq + apq + app)
   = bpq + aqq + bqq + apq + apq + bpq + apq + app
   = (bpq + bpq + bqq) + (apq + apq + aqq) + (aqq + app)
   = b(2pq + qq) + a(2pq + qq) + a(qq + pp)

b2 = (bp + aq)p + (bq + aq + ap)q
   = (bpp + apq) + (bqq + aqq + apq)
   = bpp + apq + bqq + aqq + apq
   = bpp + bqq + 2apq + aqq
   = (bpp + bqq) + (2apq + aqq)
   = b(pp + qq)  + a(2pq + qq)

p' = p^2 + q^2
q' = 2pq + q^2

Now that we have the values for p' and q' we can paste them into the fib procedure

(define (fib n)
  (define (fib-iter a b p q count)
    (cond ((= count 0) b)
	  ((even? count)
	   (fib-iter a
		     b
		     (+ (* p p) (* q q))        ; compute p'
		     (+ (* 2 (* p q)) (* q q))  ; compute q'
                   (/ count 2)))
	  (else (fib-iter (+ (* b q) (* a q) (* a p))
			  (+ (* b p) (* a q))
			  p
			  q
			  (- count 1)))))
  
  (fib-iter 1 0 0 1 n))

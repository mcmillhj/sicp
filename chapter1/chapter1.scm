;;; Exercise 1.1.  Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

10                         ; => 10
(+ 5 3 4)                  ; => 12
(- 9 1)                    ; => 8
(/ 6 2)                    ; => 3
(+ (* 2 4) (- 4 6))        ; => 6
(define a 3)               ; => a
(define b (+ a 1))         ; => b
(+ a b (* a b))            ; => 19
(if (and (> b a)
         (< b (* a b)))
    b
    a)                     ; => 4
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))           ; => 16
(+ 2 (if (> a b) b a))     ; => 5
(* (cond ((> a b) a)
         ((< a b) b)   
         (else -1))
   (+ a 1))                ; => 16

;;; Exercise 1.2. Translate the following expression into prefix form 
;;; 5 + 4 + (2 - (3 - (6 + 4/5)))
;;; ---------------------------
;;;      3(6 - 2)(2 - 7)

(/ 
 (+ 5 4 
    (- 2 
       (- 3 
	  (+ 6 (/ 4 5)))))
 (* 3 
    (- 6 2) 
    (- 2 7)))

;;;  Exercise 1.3.  Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers. 

(define (max a b)
  (if (< a b) b a))

(define (min a b)
i  (if (< a b) a b))

(define (sum-of-squares a b)
  (+ (square a) (square b)))

(define (biggest-2-sum-of-squares a b c)
  (sum-of-squares (max a b) (max (min a b) c)))

(biggest-2-sum-of-squares 3 4 5)

;;; Exercise 1.4.  
;;; Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure: 

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;;;The above if expression returns a procedure + or - predicated on whether or not b is greater than 0. If b > 0, then a and b are added. If b < 0, b is subtracted from a (subtracting a negative number is the same as adding a positive number). The second set of surrounding parentheses then applies whichever procedure was returned by the if expression to the operands a and b.  

(a-plus-abs-b 5 -2) => (- 5 -2) => 7
(a-plus-abs-b 5  2) => (+ 5  2) => 7

;;; Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

;;; Then he evaluates the expression

(test 0 (p))

;;; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? 

Using applicative-order evaluation the operands are first evaluated before applying the operator test, in this case since the application of (p) is one of the operands it will be evaluated. However, since the the body of procedure p is itself an application of p, in applicative-order evaluation this will result in a program that applies (p) infinitely. 

;;; What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

Using normal-order application the values of the operands 0 and (p) are not evaluated until they are needed. This means that instead of evaluating (p) infinitely this program will enter the test procedure, evaluate the if expression and execute the consequent. 

;; Newton's method for computing square roots

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

;; A guess is improved by averaging it with the quotient of the radicand and the old guess:

(define (improve guess x)
  (average guess (/ x guess)))

where

(define (average x y)
  (/ (+ x y) 2))

;; We also have to say what we mean by ``good enough.'' The following will do for illustration, but it is not really a very good test. (See exercise 1.7.) The idea is to improve the answer until it is close enough so that its square differs from the radicand by less than a predetermined tolerance (here 0.001):22

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

;; Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

;; Eva demonstrates the program for Alyssa:

;; (new-if (= 2 3) 0 5)
;; 5

;; (new-if (= 1 1) 0 5)
;; 0

;; Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
	  guess
          (sqrt-iter (improve guess x)
                     x)))

;; What happens when Alyssa attempts to use this to compute square roots? Explain. 

Recall from the previous sections that (if <predicate> <consequent> <alternative>) is a special form that does two things: 1. It evaluates the predicate 2. If the <predicate> was true it evaluates the <consequent>, otherwise it evaluates the <alternative>. the (new-if ...) procedure doesn't have this special form, so each time the production is applied it evaluates both of its operands and results in an infinite recursion due to the applicative-order evaluation that scheme uses.


;; Exercise 1.7.  The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers? 

The problem is as the guess is refined, we stop when we reach a guess that is within 0.001 of the target. For small numbers, this presents a large range of inaccuracy. For large numbers, the problem is the floating point numbers themselves. As the number gets larger and larger, the way it is represented becomes increasingly less precise. (sqrt 99999999999999) will never return because we are unable to represent it within the tolerance of 0.001. 

The solution as hinted at in the question is to alter the implementation of good-enough? to not consider guess and x, but guess and the previous guess. Now once the absolute value of the difference of the previous and current guess are within 0.001 we can stop. This means that repeated applications of improve are no longer improving the guess by any magnitude that we care about i.e. the answer is "good enough". Notice below that I have hidden the implementation details of sqrt away be defining all of my needed helper functions inside of sqrt's body.

(define (sqrt x)
  (define (good-enough? guess previous-guess)
    (< (abs (- guess previous-guess))
       0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess previous-guess)
    (if (good-enough? guess previous-guess)
	guess
	(sqrt-iter (improve guess) guess)))
  (sqrt-iter 1.0 0))

;; Exercise 1.8.  Newton's method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better approximation is given by the value
;; x/y^2 + 2y
;; ----------
;;     3

We can implement this cube-root procedure in exactly the same fashion as the sqrt procedure above, the only implementation different will be the improve procedure: 

(define (cbrt x)
  (define (good-enough? guess previous-guess)
    (< (abs (- guess previous-guess))
       0.001))
  (define (improve guess)
    (/ (+ (/ x (square guess)) (* 2 guess))
       3))
  (define (cube-iter guess previous-guess)
    (if (good-enough? guess previous-guess)
	guess
	(cube-iter (improve guess) guess)))
  (cube-iter 1.0 0))

In fact since they share some functionality, we can factor "(good-enough? ...)" out of both implementations:

(define (good-enough? guess previous-guess)
    (< (abs (- guess previous-guess))
       0.001))
(define (average a b)
  (/ (+ a b) 2))

(define (sqrt x)
  (define (improve guess)
    (average guess (/ x guess)))
  (define (iter guess previous-guess)
    (if (good-enough? guess previous-guess)
	guess
	(iter (improve guess) guess)))
  (iter 1.0 0))

(define (cbrt x)
  (define (improve guess)
    (/ (+ (/ x (square guess)) (* 2 guess)) 3))
  (define (iter guess previous-guess)
    (if (good-enough? guess previous-guess)
	guess
	(iter (improve guess) guess)))
  (iter 1.0 0))

;; Exercise 1.9.  Each of the following two procedures defines a method for adding two positive integers in terms of the procedures inc, which increments its argument by 1, and dec, which decrements its argument by 1.

;; (define (+ a b)
;;   (if (= a 0)
;;       b
;;       (inc (+ (dec a) b))))

;; (define (+ a b)
;;   (if (= a 0)
;;       b
;;       (+ (dec a) (inc b))))

;; Using the substitution model, illustrate the process generated by each procedure in evaluating (+ 4 5). Are these processes iterative or recursive? 

The first procedure is recursive, each application of "+" chains another deferred application of "(inc ...)"
(+ 4 5)
(inc (+ 3 5))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9

The second procedure is iterative, each iteration adds no more deferred actions
(+ 4 5)
(+ 3 6)
(+ 2 7)
(+ 1 8)
(+ 0 9)
9

;; Exercise 1.10.  The following procedure computes a mathematical function called Ackermann's function.

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

;; What are the values of the following expressions?

(A 1 10) => 1024
 
(A 2 4)  => 65536

(A 3 3)  => 65536 

;; Consider the following procedures, where A is the procedure defined above:

(define (f n) (A 0 n)) 

(define (g n) (A 1 n))

(define (h n) (A 2 n))

(define (k n) (* 5 n n))

;; Give concise mathematical definitions for the functions computed by the procedures f, g, and h for positive integer values of n. For example, (k n) computes 5n2. 

f(n) = 2n

g(n) = 2^n
g(0) = 0

h(n) = 2^h(n-1)
h(0) = 0
h(1) = 2

;; Exercise 1.11.  A function f is defined by the rule that f(n) = n if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n> 3. Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process. 

(define (f n) 
  (if (< n 3) 
      n
      (+ (f (- n 1)) 
	 (* 2 (f (- n 2))) 
	 (* 3 (f (- n 3))))))


(define (f2 n)
  (if (< n 3)
      n
      (f-iter 2 1 0 n)))

(define (f-iter a b c count)
  (if (< count 3)
      a
      (f-iter (+ a (* 2 b) (* 3 c))
	      a 
	      b
	      (- count 1))))



;; Exercise 1.12.  The following pattern of numbers is called Pascal's triangle.

;;            1
;;          1   1
;;        1   2   1
;;      1   3   3   1
;;     1  4   6   4  1 
;;     ...............

;; The numbers at the edge of the triangle are all 1, and each number inside the triangle is the sum of the two numbers above it.
;; Write a procedure that computes elements of Pascal's triangle by means of a recursive process. 

;; pascal(r,c) -> { undefined if r < c 
;;                { 1         if c == 0 or r == c
;;                { pascal(r-1,c) + pascal(r-1,c-1) 
i
(define (pascal r c)
  (cond ((< r c) #f)
	((or (= r c) (= 0 c)) 1) 
	(else (+ (pascal (- r 1) c)
		 (pascal (- r 1) (- c 1))))))


;; Exercise 1.13.  
;; Prove that Fib(n) is the closest integer to PHI^n/sqrt5, where PHI = (1 + sqrt(5))/2. Hint: Let PSI = (1 - sqrt(5))/2. 
;; Use induction and the definition of the Fibonacci numbers (see section 1.2.2) to prove that Fib(n) = (PHI^n - PSI^n)/ sqrt(5). 

PHI = (1 + sqrt5) / 2
PSI = (1 - sqrt5) / 2

         { 0                    if n == 0
Fib(n) = { 1                    if n == 1
         { Fib(n-1) + Fib(n-2)  else 
i
(*Lemma 1) Fib(n) = (PHI^n - PSI^n) / sqrt5

Prove for 0 and 1:

Fib(0) = (PHI^0 - PSI^0) / sqrt5                                  # Lemma 1
       = ( ((1 + sqrt5)/2)^0 - ((1 - sqrt5)/2)^0 ) / sqrt5        # Definintion of PHI and PSI
       = ( 1 - 1 ) / sqrt5                                        # Defintion of n^0
       = 0 / sqrt5                                                 
       = 0
TRUE for n = 0

Fib(1) = (PHI^1 - PSI^1) / sqrt5                                  # Lemma 1
       = ( ((1 + sqrt5)/2)^1 - ((1 - sqrt5)/2)^1 ) / sqrt5        # Definition of PHI and PSI
       = ( (1 + sqrt5)/2 - (1 - sqrt5)/2 ) / sqrt5                # Definition of n^1
       = ( (1/2 + sqrt5/2) - (1/2 - sqrt5/2) ) / sqrt5
       = ( 1/2 + sqrt5/2 - 1/2 + sqrt5/2 ) / sqrt5 
       = ( 2 * sqrt5/2 ) / sqrt5
       = ( sqrt5 ) / sqrt5
       = 1
TRUE for n = 1

Inductive step: Assuming Lemma 1 is true for n-1 and n-2, prove for n:

Fib(n) = Fib(n-1) + Fib(n-2)                                                         # Definition of Fibonacci sequence 
       = (PHI^(n-1) - PSI^(n-1))/sqrt5 + (PHI^(n-2) - PSI^(n-2))/sqrt5               # Lemma 1 
       = PHI^(n-1) - PSI^(n-1) + PHI^(n-2) - PSI^(n-2) / sqrt5                       
       = PHI^(n-2)*(PHI^(n-1)/PHI^(n-2)) - PSI^(n-2)*(PSI^(n-1)/PSI^(n-2)) / sqrt5   # factor out common terms
       = PHI^(n-2)*(PHI + 1) - PSI^(n-2)*(PSI + 1) / sqrt5                           # x^(n-2) + x^(n-1) = x^(n-2) + x * x^(n-2) = x^(n-2) * (x + 1)
       = PHI^(n-2)*PHI^2 - PSI^(n-2)^PSI^2 / sqrt5                                   # Property of PHI and PSI PHI^2 = PHI + 1, PSI^2 = PSI + 1 
       = PHI^(n-2+2) - PSI^(n-2+2) / sqrt5                                           # addition of exponents
       = PHI^n - PSI^n / sqrt5 
       = PHI^n / sqrt5                                                               # as N gets increasingly larger, PSI becomes smaller and smaller


;; Exercise 1.14.  Draw the tree illustrating the process generated by the count-change procedure of section 1.2.2 in making change for 11 cents. What are the orders of growth of the space and number of steps used by this process as the amount to be changed increases? 

(cc 11 5) 
   (cc  11 4)
      (cc  11 3)
        (cc 11 2)
          (cc 11 1)
            (cc 11 0)
              0
            (cc 10 1)
              (cc 10 0)
                0
              (cc 9 1)
                (cc 9 0)
                  0
                (cc 8 1)
                  (cc 8 0)
                    0
                  (cc 7 1)
                    (cc 7 0)
                      0
                    (cc 6 1)
                      (cc 6 0)
                        0
                      (cc 5 1)
                        (cc 5 0)
                          0
                        (cc 4 1)
                          (cc 4 0)
                            0
                          (cc 3 1)
                            (cc 3 0)
                              0
                            (cc 2 1)
                              (cc 2 0)
                                0
                              (cc 1 1)
                                (cc 1 0)
                                  0
                                (cc 0 1)
                                  1
          (cc 6 2)
            (cc 6 1)
              (cc 6 0)
                0
              (cc 5 1)
                (cc 5 0)
                  0
                (cc 4 1)
                  (cc 4 0)
                    0
                  (cc 3 1)
                    (cc 3 0)
                      0
                    (cc 2 1)
                      (cc 2 0)
                        0
                      (cc 1 1)
                        (cc 1 0)
                          0
                        (cc 0 1)
                          1
            (cc 1 2)
              (cc 1 1)
                (cc 1 0)
                  0
                (cc 0 1)
                  1
              (cc -4 2)
                0
        (cc 1 3)
          (cc 1 2)
            (cc 1 1)
              (cc 1 0) 
                0
              (cc 0 1)
                1
            (cc -4 2)
              0
          (cc -9 3)
            0   
      (cc -14 4)
        0
   (cc -39 5)
      0

(define (count-change amount)
  (define (cc amount kinds-of-coins)
    (cond ((= amount 0) 1)
	  ((or (< amount 0) (= kinds-of-coins 0)) 0)
	  (else (+ (cc amount
		       (- kinds-of-coins 1))
		   (cc (- amount
                        (first-denomination kinds-of-coins))
		       kinds-of-coins)))))
  (define (first-denomination kinds-of-coins)
    (cond ((= kinds-of-coins 1) 1)
	  ((= kinds-of-coins 2) 5)
	  ((= kinds-of-coins 3) 10)
	  ((= kinds-of-coins 4) 25)
	  ((= kinds-of-coins 5) 50)))
  (cc amount 5))

(define (sq x)
  (** x 2))

(define (cb x)
  (** x 3))

;;; Exercise 1.15. The sine of an angle (specified in radians) can be computed by making use of the approximation sin x ~ x if x is sufficiently small, and the trigonometric identity 
;;; 
;;; sin x = 3*sin*(x/3) - 4*sin^3*(x/3)
;;; to reduce the size of the argument of sin. (For purposes of this exercise an angle is considered ``sufficiently small'' if its magnitude is not greater than 0.1 radians.) 
;;; These ideas are incorporated in the following procedures:

(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

;;; a.  How many times is the procedure p applied when (sine 12.15) is evaluated?

(sine 12.15)
(p (sine 4.05))
(p (p (sine 1.35)))
(p (p (p (sine 0.45))))
(p (p (p (p (sine 0.15)))))
(p (p (p (p (p (sine 0.05))))))
(p (p (p (p (p 0.05)))))
(p (p (p (p 0.1495))))
(p (p (p 0.435134551)))
(p (p 0.975846534))
(p −0.789563121)
−0.399803428

procedure p is applied 5 times before the base case of the procedure is reached.


;;; b.  What is the order of growth in space and number of steps (as a function of a) used by the process generated by the sine procedure when (sine a) is evaluated? 

Space:
The sine procedure only calls itself a single time, the space growth for this procedure is all in the deferred calls to procedure p. Calls to procedure p scale logirithmically with the size of the input n. To increase to number of times that p is called by 1, you must increase the input size to the function by a factor of 3. This means that the space complexity of sine is O(log_3).

Number of steps:
The number of "steps" in taken when the since procedure is called is equivalent to number of times that the procedure p is applied * 2 (for the sine single sine application in each step). This would give a time complexity of O(2*log_3), but in Big O notation constants are discarded; so the the time complexity is also O(log_3).

;;; Exercise 1.16.  
;;; Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt. 
;;; (Hint: Using the observation that (bn/2)2 = (b2)n/2, keep, along with the exponent n and the base b, an additional state variable a, and define the state transformation in such a way that the product a bn is unchanged from state to state. 
;;; At the beginning of the process a is taken to be 1, and the answer is given by the value of a at the end of the process. In general, the technique of defining an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.) 

(define (even? n)
  (= (remainder n 2) 0))
(define (square n)
  (* n n))

(define (fast-expt b n)
  (define (expr-iter b n a)
    (cond (= n 0) a
	  (even? n) (expt-iter (square b) (/ n 2) a)
	  (else (expt-iter b (- n 1) (* a b)))))
  (expr-iter b n 1))

;;; Exercise 1.17.  
;;; The exponentiation algorithms in this section are based on performing exponentiation by means of repeated multiplication. 
;;; In a similar way, one can perform integer multiplication by means of repeated addition. 
;;; The following multiplication procedure (in which it is assumed that our language can only add, not multiply) is analogous to the expt procedure:

(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

;;; This algorithm takes a number of steps that is linear in b. Now suppose we include, together with addition, operations double, which doubles an integer, and halve, which divides an (even) integer by 2.
;;; Using these, design a multiplication procedure analogous to fast-expt that uses a logarithmic number of steps. 

;;; We can make similar rules for integer multiplication that we used to exponentiation in the previous exercise
;;; a * b = 2 * (a * b/2)   if b is even 
;;; a * b = a + a * (b - 1) if b is odd 
;;; this above piece tells us at what steps to use the double and halve procedures

(define (double x)
  (+ x x))
(define (halve x)
  (/ x 2))
(define (even? x)
  (= (remainder x 2) 0))

(define (fast-* a b)
  (cond ((= b 0) 0)
	((= b 1) a)
	((even? b) (doble (fast-* a (halve b))))
	(else (+ a (fast-* a (- b 1))))))

;;; Exercise 1.18.  
;;; Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps

(define (double x)
  (+ x x))
(define (halve x)
  (/ x 2))
(define (even? x)
  (= (remainder x 2) 0))

(define (mult a b)
  (define (mult-iter a b p)
    (cond ((= b 0) p)
	((even? b) (mult-iter (double a) (halve b) p))
	(else (mult-iter a (- b 1) (+ p a)))))
  (mult-iter a b 0))

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

;;; Exercise 1.21.  
;;; Use the smallest-divisor procedure to find the smallest divisor of each of the following numbers: 199, 1999, 19999. 

(define (smallest-divisor n)
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (square x)
    (* x x))
  (find-divisor n 2))

(smallest-divisor 199)   ; => 199
(smallest-divisor 1999)  ; => 1999
(smallest-divisor 19999) ; => 7

;; The results of applying the procedure smallest-divisor to 199, 1999, and 19999 is that we can see that 199 and 1999 are prime; because they are
;; their own smallest divisors. 19999 is not prime because it is divisible by 7


;;; Exercise 1.22.  
;;; Most Lisp implementations include a primitive called runtime that returns an integer that specifies the amount of time the system has been running (measured, for example, in microseconds). 
;;; The following timed-prime-test procedure, when called with an integer n, prints n and checks to see if n is prime. 
;;; If n is prime, the procedure prints three asterisks followed by the amount of time used in performing the test.

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (prime? n)
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (square x)
    (* x x))
  (define (smallest-divisor n)
    (find-divisor n 2))
  (= n (smallest-divisor n)))

;;; Using this procedure, write a procedure search-for-primes that checks the primality of consecutive odd integers in a specified range. 
;;; Use your procedure to find the three smallest primes larger than 1000; larger than 10,000; larger than 100,000; larger than 1,000,000. 
;;; Note the time needed to test each prime. 
;;; Since the testing algorithm has order of growth of (n), you should expect that testing for primes around 10,000 should take about 10 times as long as testing for primes around 1000. 
;;; Do your timing data bear this out? 
;;; How well do the data for 100,000 and 1,000,000 support the n prediction? 
;;; Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation? 

(define (search-for-primes start end)
  (if (even? start)
      (search-for-primes (+ 1 start) end)
      (cond ((< start end) (timed-prime-test start)
	     (search-for-primes (+ 2 start) end)))))

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
;;; If n is prime, the procedure prints three asterisks followed by the amxount of time used in performing the test.
(define (runtime) 
  (let ((p (cons 0 0))) 
    ((make-primitive-procedure 'nanotime-since-utc-epoch 1) p) 
    (* 1000 (+ (car p) (/ (cdr p) 1e9)))))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (prime? n)
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

;; smallest 3 primes larger than 1_000
;; (search-for-primes 1000 1020)
;; 1001
;; 1003
;; 1005
;; 1007
;; 1009 *** .078857421875
;; 1011
;; 1013 *** .0791015625
;; 1015
;; 1017
;; 1019 *** .0791015625

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)
;; 10001
;; 10003
;; 10005
;; 10007 *** .243896484375
;; 10009 *** .243896484375
;; 10011
;; 10013
;; 10015
;; 10017
;; 10019
;; 10021
;; 10023
;; 10025
;; 10027
;; 10029
;; 10031
;; 10033
;; 10035
;; 10037 *** .2431640625

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** .7587890625
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** .7578125
;; 100021
;; 100023
;; 100025
;; 100027
;; 100029
;; 100031
;; 100033
;; 100035
;; 100037
;; 100039
;; 100041
;; 100043 *** .77709960937

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** 2.382080078125
;; 1000005
;; 1000007
;; 1000009
;; 1000011
;; 1000013
;; 1000015
;; 1000017
;; 1000019
;; 1000021
;; 1000023
;; 1000025
;; 1000027
;; 1000029
;; 1000031
;; 1000033 *** 2.448974609375
;; 1000035
;; 1000037 *** 2.10791015625


;; Results
;; n         |  prime   | time (ms)      | avg time (ms)
;; ----------------------------------------------------- 
;;    1000   |    1009  | 0.078857421875 |
;;    1000   |    1013  | 0.0791015625   |
;;    1000   |    1019  | 0.0791015625   | 0.079020182  

;;   10000   |   10007  | 0.243896484375 | 
;;   10000   |   10009  | 0.243896484375 | 
;;   10000   |   10037  | 0.2431640625   | 0.243652344   x 3.08 slower

;;  100000   |  100003  | 0.7587890625   |
;;  100000   |  100019  | 0.7578125      |
;;  100000   |  100043  | 0.77709960937  | 0.764567057   x 3.14 slower

;; 1000000   | 1000003  | 2.382080078125 |
;; 1000000   | 1000033  | 2.448974609375 |
;; 1000000   | 1000037  | 2.10791015625  | 2.312988281   x 3.03 slower

;;; Since the testing algorithm has order of growth of (n), you should expect that testing for primes around 10,000 should take about 10 times as long as testing for primes around 1000. 
;;; Do your timing data bear this out? 
No, the timing data shows that for each order of magnitude increase (10x) in the input size execution only took ~3x longer. 

;;; How well do the data for 100,000 and 1,000,000 support the n prediction? 
Similar to the above, each increase in input size by a factor of 10 took ~3x as long to execute. This is consistent with O(sqrt(10)).  

;;; Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation? 
Yes, these results do seem to verify that programs on my machine run in time proportional to the number of steps required for the computation.

;;; Exercise 1.23: 
;;; The smallest-divisor procedure shown at the start of this section does lots of needless testing: 
;;;    After it checks to see if the number is divisible by 2 there is no point in checking to see if it is divisible by any larger even numbers. 
;;; This suggests that the values used for test-divisor should not be 2, 3, 4, 5, 6, …, but rather 2, 3, 5, 7, 9, …. 
;;; To implement this change, define a procedure next that returns 3 if its input is equal to 2 and otherwise returns its input plus 2. 
;;; Modify the smallest-divisor procedure to use (next test-divisor) instead of (+ test-divisor 1). 
;;; With timed-prime-test incorporating this modified version of smallest-divisor, run the test for each of the 12 primes found in Exercise 1.22. 
;;; Since this modification halves the number of test steps, you should expect it to run about twice as fast. 
;;; Is this expectation confirmed? If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2? 

(define (prime? n)
  (define (smallest-divisor n)
    (define (next test-divisor)
      (if (= test-divisor 2)
          3
          (+ 2 test-divisor)))
    (define (find-divisor n test-divisor)
      (cond ((> (square test-divisor) n) n)
            ((divides? test-divisor n) test-divisor)
            (else (find-divisor n (next test-divisor)))))
    (define (divides? a b)
      (= (remainder b a) 0))
    (define (square x)
      (* x x))
    (find-divisor n 2))
  (= n (smallest-divisor n)))

(define (runtime) 
  (let ((p (cons 0 0))) 
    ((make-primitive-procedure 'nanotime-since-utc-epoch 1) p) 
    (* 1000 (+ (car p) (/ (cdr p) 1e9)))))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (search-for-primes start end)
  (if (even? start)
      (search-for-primes (+ 1 start) end)
      (cond ((< start end) (timed-prime-test start)
	     (search-for-primes (+ 2 start) end)))))

;; smallest 3 primes larger than 1_000
;; (search-for-primes 1000 1020)
;; 1001
;; 1003
;; 1005
;; 1007
;; 1009 *** .02783203125
;; 1011
;; 1013 *** .027099609375
;; 1015
;; 1017
;; 1019 *** .02685546875

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)
;; 10001
;; 10003
;; 10005
;; 10007 *** .077880859375
;; 10009 *** .076904296875
;; 10011
;; 10013
;; 10015
;; 10017
;; 10019
;; 10021
;; 10023
;; 10025
;; 10027
;; 10029
;; 10031
;; 10033
;; 10035
;; 10037 *** .076904296875

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** .252197265625
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** .299072265625
;; 100021
;; 100023
;; 100025
;; 100027
;; 100029
;; 100031
;; 100033
;; 100035
;; 100037
;; 100039
;; 100041
;; 100043 *** .234130859375

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** .76611328125
;; 1000005
;; 1000007
;; 1000009
;; 1000011
;; 1000013
;; 1000015
;; 1000017
;; 1000019
;; 1000021
;; 1000023
;; 1000025
;; 1000027
;; 1000029
;; 1000031
;; 1000033 *** .7587890625
;; 1000035
;; 1000037 *** .7548828125

;; Results
;; n         |  prime   | time (ms)       | avg time (ms) | last avg time (ms)
;; ---------------------------------------------------------------------------  
;;    1000   |    1009  | 0.02783203125   |               |
;;    1000   |    1013  | 0.027099609375  |               | x 2.9 faster 
;;    1000   |    1019  | 0.02685546875   | 0.02726237    | 0.079020182

;;   10000   |   10007  | 0.077880859375  |               |
;;   10000   |   10009  | 0.076904296875  | x 2.8 slower  | x 3.2 faster
;;   10000   |   10037  | 0.076904296875  | 0.077229818   | 0.243652344
 
;;  100000   |  100003  | 0.252197265625  |               |
;;  100000   |  100019  | 0.299072265625  | x 3.4 slower  | x 2.9 faster
;;  100000   |  100043  | 0.234130859375  | 0.26180013    | 0.764567057

;; 1000000   | 1000003  | 0.76611328125   |               |
;; 1000000   | 1000033  | 0.7587890625    | x 2.9 slower  | x 3.0 faster
;; 1000000   | 1000037  | 0.7548828125    | 0.759928385   | 2.312988281
                                            
;;; Since this modification halves the number of test steps, you should expect it to run about twice as fast. 
;;; Is this expectation confirmed? 
More than confirmed, the new timings show that on average using the next procedure increased execution speed by a factor of 3. 
There is probably a small margin of error due to my approximation of (runtime). 

;;; If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2?
The ratio of speeds was 3-to-1 in favor of the next procedure. I think that it is likely if I ran the trial thousands of times that the increase would approach 2. 

;;; Exercise 1.24: 
;;; Modify the timed-prime-test procedure of Exercise 1.22 to use fast-prime? (the Fermat method), and test each of the 12 primes you found in that exercise. 
;;; Since the Fermat test has Θ ( log n ) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? 
;;; Do your data bear this out? 
;;; Can you explain any discrepancy you find? 

(define (fast-prime? n times)
  (define (fermat-test n)
    (define (expmod base exp m)
      (cond ((= exp 0) 1)
            ((even? exp)
             (remainder (square (expmod base (/ exp 2) m))
                        m))
            (else
             (remainder (* base (expmod base (- exp 1) m))
                        m))))        
    
    (define (try-it a)
      (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
  
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (runtime) 
  (let ((p (cons 0 0))) 
    ((make-primitive-procedure 'nanotime-since-utc-epoch 1) p) 
    (* 1000 (+ (car p) (/ (cdr p) 1e9)))))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (fast-prime? n 100)
        (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (search-for-primes start end)
  (if (even? start)
      (search-for-primes (+ 1 start) end)
      (cond ((< start end) (timed-prime-test start)
	     (search-for-primes (+ 2 start) end)))))

;; smallest 3 primes larger than 1_000
;; (search-for-primes 1000 1020)
;; 1001
;; 1003
;; 1005
;; 1007
;; 1009 *** 2.619140625
;; 1011
;; 1013 *** 2.639892578125
;; 1015
;; 1017
;; 1019 *** 2.785888671875

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)

;; 10001
;; 10003
;; 10005
;; 10007 *** 2.626953125
;; 10009 *** 2.503173828125
;; 10011
;; 10013
;; 10015
;; 10017
;; 10019
;; 10021
;; 10023
;; 10025
;; 10027
;; 10029
;; 10031
;; 10033
;; 10035
;; 10037 *** 2.5419921875

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** 2.98974609375
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** 3.051025390625
;; 100021
;; 100023
;; 100025
;; 100027
;; 100029
;; 100031
;; 100033
;; 100035
;; 100037
;; 100039
;; 100041
;; 100043 *** 3.079833984375

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** 3.52490234375
;; 1000005
;; 1000007
;; 1000009
;; 1000011
;; 1000013
;; 1000015
;; 1000017
;; 1000019
;; 1000021
;; 1000023
;; 1000025
;; 1000027
;; 1000029
;; 1000031
;; 1000033 *** 3.522216796875
;; 1000035
;; 1000037 *** 3.716064453125


;;; Since the Fermat test has Θ ( log n ) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? 
;;; Do your data bear this out? 
As we increase the input size in order of magnitude the execution time is not moving by much. 

;;; Can you explain any discrepancy you find? 
Any discrepancies lie in the approximation of the (runtime) primitive and the fact that fast-prime?
is performing its check 100 times for each prime.

;;; Exercise 1.25.  
;;; Alyssa P. Hacker complains that we went to a lot of extra work in writing expmod. After all, she says, since we already know how to compute exponentials, we could have simply written

(define (expmod base exp m)
  (define (fast-expt b n)
    (cond ((= n 0) 1)
          ((even? n) (square (fast-expt b (/ n 2))))
          (else (* b (fast-expt b (- n 1))))))
  (remainder (fast-expt base exp) m))

;; original
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

;;; Exercise 1.26: 
;;; Louis Reasoner is having great difficulty doing Exercise 1.24. 
;;; His fast-prime? test seems to run more slowly than his prime? test. 
;;; Louis calls his friend Eva Lu Ator over to help. 
;;; When they examine Louis’s code, they find that he has rewritten the expmod procedure to use an explicit multiplication, rather than calling square:

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (* (expmod base (/ exp 2) m)
             (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base 
             (expmod base (- exp 1) m))
          m))))

;;; “I don’t see what difference that could make,” says Louis. 
;;; “I do.” says Eva. “By writing the procedure like that, you have transformed the Θ(log ⁡n) process into a Θ(n) process.” 
;;; Explain. 

As written, in the even case Louis' code will make two recursive calls to the expmod procedure with the same arguments.
This means that instead of having a linear recursive algorithm like before, we are now generating a tree of 
recursive procedure calls. Everytime this branch occurs, both subtrees will compute the same result. When we were
using the square procedure instead, there were no wasteful calls to expmod. 

; Here is an example of what the original recursive process looked like: 
(expmod 2 8 2)
   (expmod 2 4 2) 
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)

; Here is how it looks using Louis' expmod procedure
(expmod 2 8 2)
   (expmod 2 4 2)
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2)  
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2)  
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2) 
   (expmod 2 4 2)
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2)  
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)  
            (expmod 2 0 2)  
            (expmod 2 0 2) 

; As a result of this seemingly innocuous change, this changed the expmod procedure from a O(log n) to O(log 2^n) which reduces to O(n) ( log2(2^n) == n ) 

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

    
;;; Exercise 1.28: 
;;; One variant of the Fermat test that cannot be fooled is called the Miller-Rabin test (Miller 1976; Rabin 1980). 
;;; This starts from an alternate form of Fermat’s Little Theorem, which states that if n is a prime number and a is any positive integer less than n , 
;;; then a raised to the ( n − 1 ) -st power is congruent to 1 modulo n . 
;;; To test the primality of a number n by the Miller-Rabin test, we pick a random number a < n and raise a to the (n − 1)-st power modulo n using the expmod procedure. 
;;; However, whenever we perform the squaring step in expmod, we check to see if we have discovered a “nontrivial square root of 1 modulo n ,” that is, 
;;; a number not equal to 1 or n − 1 whose square is equal to 1 modulo n . It is possible to prove that if such a nontrivial square root of 1 exists, then n is not prime. 
;;; It is also possible to prove that if n is an odd number that is not prime, then, for at least half the numbers a < n , computing a n − 1 in this way will 
;;; reveal a nontrivial square root of 1 modulo n . (This is why the Miller-Rabin test cannot be fooled.)
;;; Modify the expmod procedure to signal if it discovers a nontrivial square root of 1, and use this to implement the Miller-Rabin test with a procedure analogous to fermat-test. 
;;; Check your procedure by testing various known primes and non-primes. Hint: One convenient way to make expmod signal is to have it return 0.

(define (expmod base exp m)
  (define (square-check x m)
    (if (and (not (or (= x 1) (= x (- m 1))))
             (= (remainder (* x x) m) 1))
        0
        (remainder (* x x) m)))
  (define (even? n)
    (= (remainder n 2) 0))
  (define (square n)
    (* n n))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square-check (expmod base (/ exp 2) m) m) m))
        (else
         (remainder (* base (expmod base (- exp 1) m)) m)))) 

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 2 (random-integer (- n 2)))))

(miller-rabin-test 561)  ; => #f
(miller-rabin-test 1105) ; => #f
(miller-rabin-test 1729) ; => #f
(miller-rabin-test 2465) ; => #f
(miller-rabin-test 2821) ; => #f
(miller-rabin-test 6601) ; => #f

;;; Exercise 1.29: 
;;; Simpson’s Rule is a more accurate method of numerical integration than the method illustrated above. 
;;; Using Simpson’s Rule, the integral of a function f between a and b is approximated as 
;;; h/3 ( y0 + 4y1 + 2y2 + 4y3 + 2y4 + ⋯ + 2yn − 2 + 4yn − 1 + yn ) , 
;;; where h = ( b − a ) / n , for some even integer n , and y_k = f(a + kh)  
;;; (Increasing n increases the accuracy of the approximation.) 
;;; Define a procedure that takes as arguments f , a , b , and n and returns the value of the integral, computed using Simpson’s Rule. 
;;; Use your procedure to integrate cube between 0 and 1 (with n = 100 and n = 1000 ), and compare the results to those of the integral procedure shown above. 

(define (cube x) (* x x x))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (simpsons f a b n)
  (define h (/ (- b a) n))
  (define (inc x) (+ 1 x))
  (define (y k)
    (f (+ a (* k h))))
  (define (term k)
    (* (cond ((odd? k) 4)
             ((or (= k 0) (= k n)) 1)
             ((even? k) 2))
       (y k)))
  (/ (* h (sum term 0 inc n)) 3))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) 
     dx))

(integral cube 0 1 0.01)   ; .24998750000000042
(simpsons cube 0 1 100.0)  ; .24999999999999992
(integral cube 0 1 0.001)  ; .249999875000001
(simpsons cube 0 1 1000.0) ; .2500000000000003

; We can see from the above example that Simpson's rule is a better
; approximation method for integrals

;;; Exercise 1.30: 
;;; The sum procedure above generates a linear recursion. 
;;; The procedure can be rewritten so that the sum is performed iteratively. 
;;; Show how to do this by filling in the missing expressions in the following definition:

; recursive
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

; iterative
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result 
        (iter (next a) (+ (term a) result))))
  (iter a 0))

;;; Exercise 1.31:
;;; a. The sum procedure is only the simplest of a vast number of similar abstractions that can be captured as higher-order procedures.
;;;    Write an analogous procedure called product that returns the product of the values of a function at points over a given range. 
;;;    Show how to define factorial in terms of product. 
;;;    Also use product to compute approximations to π using the formula 
;;;    π / 4 = 2 ⋅ 4 ⋅ 4 ⋅ 6 ⋅ 6 ⋅ 8 ⋅ ⋯ / 3 ⋅ 3 ⋅ 5 ⋅ 5 ⋅ 7 ⋅ 7 ⋅ ⋯ 

;;; b. If your product procedure generates a recursive process, write one that generates an iterative process. 
;;;    If it generates an iterative process, write one that generates a recursive process. 

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (factorial n)
  (define (inc x) (+ x 1))
  (define (identity x) x)
  (product-iter identity 1 inc n))

(define (wallis-pi n)
  (define (inc x) (+ x 1))
  (define (term x)
    (/ (* 4.0 (square x))
       (- (* 4.0 (square x)) 1)))
  (* 2.0 (product term 1 inc n)))

; iterative version of product
(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

;;; Exercise 1.32:
;;; a. Show that sum and product (Exercise 1.31) are both special cases of a still more general notion called accumulate that combines a collection of terms, using some general accumulation function:

(accumulate 
  combiner null-value term a next b)

;;; Accumulate takes as arguments the same term and range specifications as sum and product, 
;;; together with a combiner procedure (of two arguments) that specifies how the current term 
;;; is to be combined with the accumulation of the preceding terms and a null-value that specifies what base value to use when the terms run out. 
;;; Write accumulate and show how sum and product can both be defined as simple calls to accumulate.

;;; b. If your accumulate procedure generates a recursive process, write one that generates an iterative process. 
;;;    If it generates an iterative process, write one that generates a recursive process. 

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

; iterative version of accumulate
(define (accumulate-iter combiner null-value term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (combiner (term a) acc))))
  (iter a null-value))

;;; Exercise 1.33: 
;;; You can obtain an even more general version of accumulate (Exercise 1.32) by introducing the notion of a filter on the terms to be combined. 
;;; That is, combine only those terms derived from values in the range that satisfy a specified condition. 
;;; The resulting filtered-accumulate abstraction takes the same arguments as accumulate, together with an additional predicate of one argument that specifies the filter. 
;;; Write filtered-accumulate as a procedure. 
;;; Show how to express the following using filtered-accumulate:
;;;  a. the sum of the squares of the prime numbers in the interval a to b (assuming that you have a prime? predicate already written)
;;;  b. the product of all the positive integers less than n that are relatively prime to n (i.e., all positive integers i < n such that GCD ( i , n ) = 1 ). 

(define (filtered-accumulate combiner null-value term a next b filter)
  (if (> a b)
      null-value
      (if (filter (term a))
          (combiner (term a)
                    (filtered-accumulate combiner null-value term (next a) next b filter))
          (filtered-accumulate combiner null-value term (next a) next b filter))))

(define (sum-of-square-primes a b)
  (define (identity x) x)
  (define (inc x) (+ x 1))
  (define (prime? n)
    (define (smallest-divisor n)
      (define (next test-divisor)
        (if (= test-divisor 2)
            3
            (+ 2 test-divisor)))
      (define (find-divisor n test-divisor)
        (cond ((> (square test-divisor) n) n)
              ((divides? test-divisor n) test-divisor)
              (else (find-divisor n (next test-divisor)))))
      (define (divides? a b)
        (= (remainder b a) 0))
      (define (square x)
        (* x x))
      (find-divisor n 2))
    (= n (smallest-divisor n)))
  (filtered-accumulate + 0 identity a inc b prime?)) 
          
(define (product-of-relative-primes-less-than-n n)
  (define (identity x) x)
  (define (inc x) (+ x 1))
  (define (gcd a b)
    (if (= b 0)
        a
        (gcd b (remainder a b))))
  (define (relative-prime? a)
    (= (gcd a n) 1))
  (filtered-accumulate * 1 identity 1 inc n relative-prime?))

;;; Exercise 1.34: 
;;; Suppose we define the procedure

(define (f g) (g 2))

;;; Then we have

(f square)
; => 4

(f (lambda (z) (* z (+ z 1))))
; => 6

;;; What happens if we (perversely) ask the interpreter to evaluate the combination (f f)? Explain. 
An error is generated: 'The object 2 is not applicable'

We can use the substitution method to see why this is happening: 

(f f) 
(f 2) 
(2 2) ; 2 is not a procedure that can be applied

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

;;; Exercise 1.36: 
;;; Modify fixed-point so that it prints the sequence of approximations it generates, using the newline and display primitives shown in Exercise 1.22. 
;;; Then find a solution to x^x = 1000 by finding a fixed point of x ↦ log(1000) / log(x)  
;;; (Use Scheme’s primitive log procedure, which computes natural logarithms.) 
;;; Compare the number of steps this takes with and without average damping. 
;;; (Note that you cannot start fixed-point with a guess of 1, as this would cause division by log(1) = 0 .) 

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display next)
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(fixed-point (lambda (x) (/ (log 1000) (log x))) 10.0)
;; 2.9999999999999996
;; 6.2877098228681545
;; 3.7570797902002955
;; 5.218748919675316
;; 4.1807977460633134
;; 4.828902657081293
;; 4.386936895811029
;; 4.671722808746095
;; 4.481109436117821
;; 4.605567315585735
;; 4.522955348093164
;; 4.577201597629606
;; 4.541325786357399
;; 4.564940905198754
;; 4.549347961475409
;; 4.5596228442307565
;; 4.552843114094703
;; 4.55731263660315
;; 4.554364381825887
;; 4.556308401465587
;; 4.555026226620339
;; 4.55587174038325
;; 4.555314115211184
;; 4.555681847896976
;; 4.555439330395129
;; 4.555599264136406
;; 4.555493789937456
;; 4.555563347820309
;; 4.555517475527901
;; 4.555547727376273
;; 4.555527776815261
;; 4.555540933824255
;; 4.555532257016376
;; 33 steps without average damping 

(fixed-point (lambda (x) (/ (+ x (/ (log 1000) (log x))) 2)) 10.0)
;; 5.095215099176933
;; 4.668760681281611
;; 4.57585730576714
;; 4.559030116711325
;; 4.55613168520593
;; 4.555637206157649
;; 4.55555298754564
;; 4.555538647701617
;; 4.555536206185039
;; 9 steps with average damping

;;; Exercise 1.37:

;;; An infinite continued fraction is an expression of the form 
;;; f = N1 
;;;    ---- 
;;;    D1 + N2 
;;;         ----
;;;         D2 + N3 
;;;              ---- 
;;;              D3 + ...  
;;; As an example, one can show that the infinite continued fraction expansion with the N i and the D i all equal to 1 produces 1 / φ , where φ is the golden ratio (described in 1.2.2). 
;;; One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms. 
;;; Such a truncation—a so-called finite continued fraction k-term finite continued fraction—has the form
;;; f = N1 
;;;    ---- 
;;;    D1 + N2 
;;;         ----
;;;         . + NK 
;;;          .  ---- 
;;;           . DK + ..
;;; Suppose that n and d are procedures of one argument (the term index i ) that return the N i and D i of the terms of the continued fraction. 
;;; Define a procedure cont-frac such that evaluating (cont-frac n d k) computes the value of the k -term finite continued fraction. 
;;; Check your procedure by approximating 1 / φ using

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           k)

;;; for successive values of k. How large must you make k in order to get an approximation that is accurate to 4 decimal places?
;;; If your cont-frac procedure generates a recursive process, write one that generates an iterative process. 
;;; If it generates an iterative process, write one that generates a recursive process. 

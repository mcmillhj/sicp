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

Fib(0) = (PHI^0 - PSI^0) / sqrt5                                  ;; Lemma 1
       = ( ((1 + sqrt5)/2)^0 - ((1 - sqrt5)/2)^0 ) / sqrt5        ;; Definintion of PHI and PSI
       = ( 1 - 1 ) / sqrt5                                        ;; Defintion of n^0
       = 0 / sqrt5
       = 0
TRUE for n = 0

Fib(1) = (PHI^1 - PSI^1) / sqrt5                                  ;; Lemma 1
       = ( ((1 + sqrt5)/2)^1 - ((1 - sqrt5)/2)^1 ) / sqrt5        ;; Definition of PHI and PSI
       = ( (1 + sqrt5)/2 - (1 - sqrt5)/2 ) / sqrt5                ;; Definition of n^1
       = ( (1/2 + sqrt5/2) - (1/2 - sqrt5/2) ) / sqrt5
       = ( 1/2 + sqrt5/2 - 1/2 + sqrt5/2 ) / sqrt5
       = ( 2 * sqrt5/2 ) / sqrt5
       = ( sqrt5 ) / sqrt5
       = 1
TRUE for n = 1

Inductive step: Assuming Lemma 1 is true for n-1 and n-2, prove for n:

Fib(n) = Fib(n-1) + Fib(n-2)                                                         ;; Definition of Fibonacci sequence
       = (PHI^(n-1) - PSI^(n-1))/sqrt5 + (PHI^(n-2) - PSI^(n-2))/sqrt5               ;; Lemma 1
       = PHI^(n-1) - PSI^(n-1) + PHI^(n-2) - PSI^(n-2) / sqrt5
       = PHI^(n-2)*(PHI^(n-1)/PHI^(n-2)) - PSI^(n-2)*(PSI^(n-1)/PSI^(n-2)) / sqrt5   ;; factor out common terms
       = PHI^(n-2)*(PHI + 1) - PSI^(n-2)*(PSI + 1) / sqrt5                           ;; x^(n-2) + x^(n-1) = x^(n-2) + x * x^(n-2) = x^(n-2) * (x + 1)
       = PHI^(n-2)*PHI^2 - PSI^(n-2)^PSI^2 / sqrt5                                   ;; Property of PHI and PSI PHI^2 = PHI + 1, PSI^2 = PSI + 1
       = PHI^(n-2+2) - PSI^(n-2+2) / sqrt5                                           ;; addition of exponents
       = PHI^n - PSI^n / sqrt5
       = PHI^n / sqrt5                                                               ;; as N gets increasingly larger, PSI becomes smaller and smaller

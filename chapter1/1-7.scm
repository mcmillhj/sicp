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

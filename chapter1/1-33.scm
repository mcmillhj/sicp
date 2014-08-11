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
